import { useQuery } from "@tanstack/react-query";
import { RpgCheckbox, RpgNumber, RpgSelect } from "@/components/primitives/RpgControls";
import { queries } from "@/shared/api/queries";
import type { Campaign } from "@/shared/contracts/campaign";
import type { OrdemData } from "@/shared/contracts/character-sheet";
import { expandSupplementRuleIds, selectableSupplementRules, toggleSupplementRule } from "@/shared/lib/supplement-rules";

export function OrdemIdentity({
	value,
	onChange,
	disabled,
	campaign,
	supplementId,
	onSupplementChange,
	supplementRuleIds = [],
	onSupplementRulesChange,
}: {
	value: OrdemData;
	onChange: (value: OrdemData) => void;
	disabled?: boolean;
	campaign?: Campaign;
	supplementId?: string | null;
	onSupplementChange?: (value: string | null) => void;
	supplementRuleIds?: string[];
	onSupplementRulesChange?: (value: string[]) => void;
}) {
	const options = useQuery(queries.characterOptions);
	const supplements = useQuery(queries.supplements);
	const activeId = campaign ? campaign.settings.supplement?.id : supplementId;
	const supplement = supplements.data?.find((entry) => entry.id === activeId);
	const selectedRuleIds = supplement ? expandSupplementRuleIds(supplement.rules, campaign ? campaign.settings.supplement?.ruleIds ?? [] : supplementRuleIds) : [];
	const ruleEnabled = (slug: string) => Boolean(supplement?.rules.some((rule) => rule.slug === slug && selectedRuleIds.includes(rule.id)));
	const toggleStandaloneRule = (id: string) => {
		if (!supplement) return;
		const nextRuleIds = toggleSupplementRule(supplement.rules, supplementRuleIds, id);
		const nextRuleEnabled = (slug: string) => supplement.rules.some((rule) => rule.slug === slug && nextRuleIds.includes(rule.id));
		const resetPatent = value.progressionMode === "patent" && (!nextRuleEnabled("evolucao-por-patentes") || !nextRuleEnabled("jogando-sem-sanidade"));
		const resetLevel = value.progressionMode === "level-nex" && !nextRuleEnabled("nex-experiencia-p100-separando-nivel-e-nex");
		if (resetPatent || resetLevel) onChange({ ...value, progressionMode: "nex", nex: 5, level: null, patent: null });
		onSupplementRulesChange?.(nextRuleIds);
	};
	const modes = [
		{ value: "nex", label: "NEX tradicional" },
		...(supplement && ruleEnabled("nex-experiencia-p100-separando-nivel-e-nex") ? [{ value: "level-nex", label: "Nível separado do NEX" }] : []),
		...(supplement && ruleEnabled("evolucao-por-patentes") && ruleEnabled("jogando-sem-sanidade") ? [{ value: "patent", label: "Evolução por patentes" }] : []),
		...(supplement && (!campaign || campaign.settings.supplement?.categories.includes("survivor")) ? [{ value: "survivor", label: "Sobrevivente" }] : []),
	];
	const classes = (options.data?.classes ?? []).filter((entry) => !campaign || campaign.settings.classes.mode === "all" || campaign.settings.classes.allowedIds.includes(entry.id));
	const origins = (options.data?.origins ?? []).filter((entry) => (!entry.supplementId || entry.supplementId === activeId) && (!campaign || campaign.settings.origins.mode === "all" || campaign.settings.origins.allowedIds.includes(entry.id)));
	const trails = (options.data?.trails ?? []).filter((entry) => {
		if (entry.classId !== value.classId) return false;
		if (!entry.supplementId) return true;
		return entry.supplementId === activeId && (!campaign || Boolean(campaign.settings.supplement?.categories.includes("trails")));
	});
	const survivor = value.progressionMode === "survivor";
	return (
		<section className="space-y-5">
			<h3 className="border-b border-(--edge) pb-3 text-xl">
				02 / Agente da Ordem
			</h3>
			{!campaign && supplements.data && supplements.data.length > 0 && <div className="rounded-2xl bg-(--panel) p-4"><RpgSelect label="Suplemento desta ficha" value={supplementId ?? ""} onChange={(id) => onSupplementChange?.(id || null)} options={[{ value: "", label: "Sem suplemento" }, ...supplements.data.map((entry) => ({ value: entry.id, label: entry.name }))]} disabled={disabled} /></div>}
			{!campaign && supplement && <div className="rounded-2xl border border-(--edge)/60 bg-(--panel) p-5"><h4 className="font-serif text-xl">Regras opcionais da ficha</h4><p className="mt-1 text-xs leading-5 text-(--muted)">Escolha as regras principais. As regras filhas são incluídas automaticamente.</p><div className="mt-4 grid gap-3 sm:grid-cols-2">{selectableSupplementRules(supplement.rules).map((rule) => <div key={rule.id} className="rounded-xl bg-(--canvas) p-3"><RpgCheckbox label={rule.name} checked={supplementRuleIds.includes(rule.id)} onChange={() => toggleStandaloneRule(rule.id)} disabled={disabled} /><details className="mt-2 text-xs text-(--muted)"><summary className="cursor-pointer text-(--accent)">Ler regra · p. {rule.sourcePage}</summary><p className="mt-2 whitespace-pre-wrap leading-5">{rule.text}</p></details></div>)}</div></div>}
			{supplement && <div className="rounded-2xl border border-(--accent)/30 bg-(--panel) p-4"><p className="font-mono text-[10px] uppercase tracking-[0.16em] text-(--accent)">Sobrevivendo ao Horror</p><p className="mt-1 text-sm text-(--muted)">A progressão e as opções abaixo seguem as regras liberadas para esta ficha.</p></div>}
			<RpgSelect label="Progressão" value={value.progressionMode} onChange={(mode) => {
				if (!modes.some((entry) => entry.value === mode)) return;
				onChange({ ...value, progressionMode: mode as OrdemData["progressionMode"], nex: mode === "survivor" ? 0 : 5, classId: mode === "survivor" ? null : value.classId, trailId: mode === "survivor" ? null : value.trailId, level: mode === "level-nex" ? 1 : null, patent: mode === "patent" ? "recruta" : null, survivorClassId: mode === "survivor" ? supplement?.survivor?.id ?? null : null, survivorStage: mode === "survivor" ? 1 : null, survivorTrailId: null });
			}} options={modes} disabled={disabled} />
			<div className="grid gap-5 sm:grid-cols-2 xl:grid-cols-4">
				{value.progressionMode === "level-nex" && <RpgNumber label="Nível" value={value.level ?? 1} min={1} max={20} onChange={(level) => onChange({ ...value, level })} disabled={disabled} />}
				{value.progressionMode === "patent" && <RpgSelect label="Patente" value={value.patent ?? "recruta"} onChange={(patent) => onChange({ ...value, patent: patent as OrdemData["patent"] })} options={[{ value: "recruta", label: "Recruta" }, { value: "operador", label: "Operador" }, { value: "agente-especial", label: "Agente especial" }, { value: "oficial-de-operacoes", label: "Oficial de operações" }, { value: "agente-de-elite", label: "Agente de elite" }]} disabled={disabled} />}
				{survivor && <RpgSelect label="Estágio" value={String(value.survivorStage ?? 1)} onChange={(stage) => onChange({ ...value, survivorStage: Number(stage), survivorTrailId: Number(stage) < 2 ? null : value.survivorTrailId })} options={[1, 2, 3, 4, 5].map((stage) => ({ value: String(stage), label: `Estágio ${stage}` }))} disabled={disabled} />}
				{survivor && (value.survivorStage ?? 1) >= 2 && <RpgSelect label="Trilha de sobrevivente" value={value.survivorTrailId ?? ""} onChange={(survivorTrailId) => onChange({ ...value, survivorTrailId: survivorTrailId || null })} options={[{ value: "", label: "Escolha a trilha" }, ...(supplement?.survivor?.trails ?? []).map((entry) => ({ value: entry.id, label: entry.name }))]} disabled={disabled} />}
				{!survivor && <RpgSelect
					label="NEX (%)"
					value={String(value.nex)}
					onChange={(nex) => onChange({ ...value, nex: Number(nex) })}
					options={value.progressionMode === "nex" ? (options.data?.nex ?? []).map((entry) => ({ value: String(entry.value), label: `${entry.value}%` })) : [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 99].map((nex) => ({ value: String(nex), label: `${nex}%` }))}
					disabled={disabled || options.isPending || !!options.error}
				/>}
				{!survivor && <RpgSelect
					label="Classe"
					value={value.classId ?? ""}
					onChange={(classId) =>
						onChange({ ...value, classId: classId || null, trailId: null })
					}
					disabled={disabled || options.isPending || !!options.error}
					options={[
						{ value: "", label: "Não definida" },
						...classes.map((entry) => ({
							value: entry.id,
							label: entry.name,
						})),
					]}
				/>}
				{!survivor && <RpgSelect label="Trilha" value={value.trailId ?? ""} onChange={(trailId) => onChange({ ...value, trailId: trailId || null })} options={[{ value: "", label: "Não definida" }, ...trails.map((entry) => ({ value: entry.id, label: entry.name }))]} disabled={disabled || options.isPending || !!options.error} />}
				<RpgSelect
					label="Origem"
					value={value.originId ?? ""}
					onChange={(originId) =>
						onChange({ ...value, originId: originId || null })
					}
					disabled={disabled || options.isPending || !!options.error}
					options={[
						{ value: "", label: "Não definida" },
						...origins.map((entry) => ({
							value: entry.id,
							label: entry.name,
						})),
					]}
				/>
				<RpgSelect
					label="Limite de crédito"
					value={value.creditLimit ?? ""}
					disabled={disabled}
					options={[
						{ value: "", label: "Não definido" },
						{ value: "BAIXO", label: "Baixo" },
						{ value: "MEDIO", label: "Médio" },
						{ value: "ALTO", label: "Alto" },
						{ value: "ILIMITADO", label: "Ilimitado" },
					]}
					onChange={(credit) => {
						if (
							credit === "" ||
							credit === "BAIXO" ||
							credit === "MEDIO" ||
							credit === "ALTO" ||
							credit === "ILIMITADO"
						)
							onChange({ ...value, creditLimit: credit || null });
					}}
				/>
			</div>
			{survivor && supplement?.survivor && <div className="grid gap-4 rounded-2xl border border-(--edge)/60 bg-(--panel) p-5 lg:grid-cols-2">
				<div><p className="font-serif text-xl">{supplement.survivor.name}</p><p className="mt-2 text-sm leading-6 text-(--muted)">{supplement.survivor.trainedSkillsRule}</p><p className="mt-2 text-sm leading-6 text-(--muted)">{supplement.survivor.proficiencyRule}</p></div>
				<div className="space-y-3">{supplement.survivor.stages.filter((entry) => entry.stage <= (value.survivorStage ?? 1)).map((entry) => <article key={entry.stage}><p className="font-mono text-[10px] uppercase tracking-widest text-(--accent)">Estágio {entry.stage} · {entry.featureName}</p><p className="mt-1 text-sm leading-6 text-(--muted)">{entry.effectText}</p></article>)}{supplement.survivor.trails.find((entry) => entry.id === value.survivorTrailId)?.abilities.filter((entry) => entry.stage <= (value.survivorStage ?? 1)).map((entry) => <article key={entry.stage}><p className="font-mono text-[10px] uppercase tracking-widest text-(--accent)">Trilha · {entry.name}</p><p className="mt-1 text-sm leading-6 text-(--muted)">{entry.effectText}</p></article>)}</div>
				{value.survivorStage === 5 && <button type="button" className="min-h-11 rounded-xl border border-(--accent) px-4 text-left text-sm text-(--accent) hover:bg-(--accent)/10" onClick={() => onChange({ ...value, progressionMode: "nex", nex: 5, classId: null, survivorClassId: null, survivorStage: null, survivorTrailId: null })}>Concluir sobrevivência e escolher classe no NEX 5%</button>}
			</div>}
		</section>
	);
}
