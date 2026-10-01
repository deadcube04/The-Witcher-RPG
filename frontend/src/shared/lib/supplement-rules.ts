import type { Supplement } from "@/shared/contracts/supplement";

type SupplementRule = Supplement["rules"][number];

const coreRuleSlugs: readonly string[] = [
	"nex-experiencia",
	"os-limites-da-compreensao-humana",
	"evolucao-por-patentes",
	"limites-de-itens-vestidos",
	"jogando-sem-sanidade",
];

export function selectableSupplementRules(rules: readonly SupplementRule[]): SupplementRule[] {
	return rules
		.filter((rule) => rule.optional && rule.parentId === null && coreRuleSlugs.includes(rule.slug))
		.sort((left, right) => coreRuleSlugs.indexOf(left.slug) - coreRuleSlugs.indexOf(right.slug));
}

function ruleFamilyIds(rules: readonly SupplementRule[], parentId: string): Set<string> {
	const family = new Set<string>();
	const pending = [parentId];
	while (pending.length > 0) {
		const id = pending.pop();
		if (id === undefined || family.has(id)) continue;
		family.add(id);
		for (const rule of rules) {
			if (rule.optional && rule.parentId === id) pending.push(rule.id);
		}
	}
	return family;
}

export function expandSupplementRuleIds(rules: readonly SupplementRule[], selectedIds: readonly string[]): string[] {
	const selected = new Set(selectedIds);
	const patent = rules.find((rule) => rule.slug === "evolucao-por-patentes");
	if (patent && selected.has(patent.id)) {
		const sanity = rules.find((rule) => rule.slug === "jogando-sem-sanidade");
		if (sanity) selected.add(sanity.id);
	}
	for (const id of selected) {
		for (const member of ruleFamilyIds(rules, id)) selected.add(member);
	}
	return [...selected];
}

export function toggleSupplementRule(rules: readonly SupplementRule[], selectedIds: readonly string[], id: string): string[] {
	const rule = selectableSupplementRules(rules).find((entry) => entry.id === id);
	if (!rule) return [...selectedIds];
	const selected = new Set(expandSupplementRuleIds(rules, selectedIds));
	if (selected.has(id)) {
		for (const member of ruleFamilyIds(rules, id)) selected.delete(member);
		if (rule.slug === "jogando-sem-sanidade") {
			const patent = rules.find((entry) => entry.slug === "evolucao-por-patentes");
			if (patent) {
				for (const member of ruleFamilyIds(rules, patent.id)) selected.delete(member);
			}
		}
	} else {
		selected.add(id);
	}
	return expandSupplementRuleIds(rules, [...selected]);
}
