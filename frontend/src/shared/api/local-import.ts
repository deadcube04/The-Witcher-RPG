import { z } from "zod";
import { request } from "@/shared/api/client";
import { MockRepository, persistenceKey, type MockDatabase } from "@/mocks/database/repository";
import { createSeed } from "@/mocks/seed/seed";
import type { RpgSystem } from "@/shared/contracts/rpg-system";
import type { OrdemInventoryDefinition } from "@/shared/contracts/ordem-inventory";
import type { OrdemRitualDefinition } from "@/shared/contracts/ordem-ritual";
import type { OrdemAttackDefinition } from "@/shared/contracts/ordem-attack";

const issueSchema = z.strictObject({ kind: z.string(), sourceId: z.uuid(), code: z.string() });
const resultSchema = z.strictObject({ total: z.number().int(), ready: z.number().int(), alreadyImported: z.number().int(), issues: z.array(issueSchema), applied: z.boolean() });
export type ImportResult = z.infer<typeof resultSchema>;
export type ImportItem = { kind: string; sourceId: string; name: string; payload: object; dependencies: string[] };
export const importKey = (item: Pick<ImportItem, "kind" | "sourceId">) => `${item.kind}:${item.sourceId}`;

export const localImportApi = {
	preview: (items: ImportItem[]) => request("/local-import/preview", resultSchema, { method: "POST", body: JSON.stringify({ items: items.map((item) => ({ kind: item.kind, sourceId: item.sourceId, name: item.name, payload: item.payload })) }) }),
	apply: (items: ImportItem[]) => request("/local-import/apply", resultSchema, { method: "POST", body: JSON.stringify({ items: items.map((item) => ({ kind: item.kind, sourceId: item.sourceId, name: item.name, payload: item.payload })) }) }),
};

function changed(current: object, seed: object | undefined): boolean {
	if (!seed) return true;
	const withoutDates = (value: object) => {
		const copy = { ...value } as Record<string, unknown>;
		delete copy.createdAt;
		delete copy.updatedAt;
		return JSON.stringify(copy);
	};
	return withoutDates(current) !== withoutDates(seed);
}
function inventoryInput(definition: OrdemInventoryDefinition): object {
	const base = { kind: definition.kind, name: definition.name, description: definition.description, category: definition.category, spaces: definition.spaces };
	return definition.kind === "weapon" ? { ...base, damageExpression: definition.damageExpression, criticalThreshold: definition.criticalThreshold, criticalMultiplier: definition.criticalMultiplier, rangeText: definition.rangeText, damageType: definition.damageType } : base;
}
function ritualInput(definition: OrdemRitualDefinition): object {
	return { name: definition.name, description: definition.description, element: definition.element, circle: definition.circle, execution: definition.execution, rangeText: definition.rangeText, targetText: definition.targetText, areaText: definition.areaText, durationText: definition.durationText, resistanceText: definition.resistanceText, tiers: definition.tiers };
}
function attackInput(definition: OrdemAttackDefinition): object {
	return { name: definition.name, description: definition.description, skillId: definition.skillId ?? null, skillName: definition.skillName, testExpression: definition.testExpression ?? "", damageExpression: definition.damageExpression, damageType: definition.damageType, criticalThreshold: definition.criticalThreshold, criticalMultiplier: definition.criticalMultiplier, rangeText: definition.rangeText, special: definition.special, sourceItemDefinitionId: definition.sourceItemDefinitionId };
}

export function readLocalImportItems(systems: RpgSystem[]): ImportItem[] {
	if (!window.localStorage.getItem(persistenceKey)) return [];
	const snapshot: MockDatabase = new MockRepository(window.localStorage).read();
	const seed = createSeed();
	const items = new Map<string, ImportItem>();
	const systemId = (sourceId: string) => {
		const source = snapshot.systems.find((item) => item.id === sourceId);
		return systems.find((item) => item.slug === source?.slug)?.id ?? sourceId;
	};
	const add = (item: ImportItem) => items.set(importKey(item), item);
	const campaign = (id: string) => {
		const value = snapshot.campaigns.find((item) => item.id === id);
		if (value && !items.has(`campaign:${id}`)) add({ kind: "campaign", sourceId: id, name: value.name, payload: { systemId: systemId(value.systemId), name: value.name, description: value.description, status: value.status }, dependencies: [] });
	};
	const character = (id: string) => {
		const value = snapshot.characters.find((item) => item.id === id);
		if (!value || items.has(`character:${id}`)) return;
		if (value.campaignId) campaign(value.campaignId);
		add({ kind: "character", sourceId: id, name: value.name, payload: { name: value.name, systemId: systemId(value.systemId), campaignId: value.campaignId, description: value.description, appearance: value.appearance, personality: value.personality, background: value.background, objective: value.objective, systemData: value.systemData }, dependencies: value.campaignId ? [`campaign:${value.campaignId}`] : [] });
	};
	const inventoryDefinition = (id: string) => {
		const value = snapshot.inventoryDefinitions.find((item) => item.id === id);
		if (!value) return;
		const seedValue = seed.inventoryDefinitions.find((item) => item.id === id);
		const kind = value.source.kind === "homebrew" || changed(value, seedValue) ? "inventory-definition" : "official-inventory";
		if (!items.has(`${kind}:${id}`)) add({ kind, sourceId: id, name: value.name, payload: kind === "official-inventory" ? { name: value.name } : inventoryInput(value), dependencies: [] });
	};
	const ritualDefinition = (id: string) => {
		const value = snapshot.ritualDefinitions.find((item) => item.id === id);
		if (!value) return;
		const seedValue = seed.ritualDefinitions.find((item) => item.id === id);
		const kind = value.source.kind === "homebrew" || changed(value, seedValue) ? "ritual-definition" : "official-ritual";
		if (!items.has(`${kind}:${id}`)) add({ kind, sourceId: id, name: value.name, payload: kind === "official-ritual" ? { name: value.name } : ritualInput(value), dependencies: [] });
	};
	const attackDefinition = (id: string) => {
		const value = snapshot.attackDefinitions.find((item) => item.id === id);
		if (!value) return;
		const seedValue = seed.attackDefinitions.find((item) => item.id === id);
		const kind = value.source.kind === "homebrew" || changed(value, seedValue) ? "attack-definition" : "official-attack";
		if (value.sourceItemDefinitionId) inventoryDefinition(value.sourceItemDefinitionId);
		const dependency = value.sourceItemDefinitionId ? [...items.keys()].find((key) => key.endsWith(`:${value.sourceItemDefinitionId}`) && (key.startsWith("inventory-definition:") || key.startsWith("official-inventory:"))) : undefined;
		if (!items.has(`${kind}:${id}`)) add({ kind, sourceId: id, name: value.name, payload: kind === "official-attack" ? { name: value.name } : attackInput(value), dependencies: dependency ? [dependency] : [] });
	};

	for (const value of snapshot.campaigns) if (changed(value, seed.campaigns.find((item) => item.id === value.id))) campaign(value.id);
	for (const value of snapshot.characters) if (changed(value, seed.characters.find((item) => item.id === value.id))) character(value.id);
	for (const value of snapshot.inventoryDefinitions) if (value.source.kind === "homebrew" || changed(value, seed.inventoryDefinitions.find((item) => item.id === value.id))) inventoryDefinition(value.id);
	for (const value of snapshot.ritualDefinitions) if (value.source.kind === "homebrew" || changed(value, seed.ritualDefinitions.find((item) => item.id === value.id))) ritualDefinition(value.id);
	for (const value of snapshot.attackDefinitions) if (value.source.kind === "homebrew" || changed(value, seed.attackDefinitions.find((item) => item.id === value.id))) attackDefinition(value.id);
	const inventoryEntry = (id: string) => {
		const value = snapshot.characterInventoryEntries.find((item) => item.id === id);
		if (!value || items.has(`inventory-entry:${id}`)) return;
		character(value.characterId);
		inventoryDefinition(value.definitionId);
		const dependency = [...items.keys()].find((key) => key.endsWith(`:${value.definitionId}`) && (key.startsWith("inventory-definition:") || key.startsWith("official-inventory:")));
		add({ kind: "inventory-entry", sourceId: value.id, name: `Item de ${snapshot.characters.find((item) => item.id === value.characterId)?.name ?? "ficha"}`, payload: { characterSourceId: value.characterId, definitionSourceId: value.definitionId, quantity: value.quantity, equipped: value.equipped, notes: value.notes }, dependencies: [`character:${value.characterId}`, ...(dependency ? [dependency] : [])] });
	};
	for (const value of snapshot.characterInventoryEntries) if (changed(value, seed.characterInventoryEntries.find((item) => item.id === value.id))) inventoryEntry(value.id);
	for (const value of snapshot.characterRitualEntries) if (changed(value, seed.characterRitualEntries.find((item) => item.id === value.id))) { character(value.characterId); ritualDefinition(value.definitionId); const dependency = [...items.keys()].find((key) => key.endsWith(`:${value.definitionId}`) && (key.startsWith("ritual-definition:") || key.startsWith("official-ritual:"))); add({ kind: "ritual-entry", sourceId: value.id, name: `Ritual de ${snapshot.characters.find((item) => item.id === value.characterId)?.name ?? "ficha"}`, payload: { characterSourceId: value.characterId, definitionSourceId: value.definitionId, notes: value.notes }, dependencies: [`character:${value.characterId}`, ...(dependency ? [dependency] : [])] }); }
	for (const value of snapshot.characterAttackEntries) if (changed(value, seed.characterAttackEntries.find((item) => item.id === value.id))) { character(value.characterId); attackDefinition(value.definitionId); if (value.sourceInventoryEntryId) inventoryEntry(value.sourceInventoryEntryId); const dependency = [...items.keys()].find((key) => key.endsWith(`:${value.definitionId}`) && (key.startsWith("attack-definition:") || key.startsWith("official-attack:"))); const inventoryDependency = value.sourceInventoryEntryId ? `inventory-entry:${value.sourceInventoryEntryId}` : undefined; add({ kind: "attack-entry", sourceId: value.id, name: `Ataque de ${snapshot.characters.find((item) => item.id === value.characterId)?.name ?? "ficha"}`, payload: { characterSourceId: value.characterId, definitionSourceId: value.definitionId, sourceInventoryEntryId: value.sourceInventoryEntryId, notes: value.notes }, dependencies: [`character:${value.characterId}`, ...(dependency ? [dependency] : []), ...(inventoryDependency ? [inventoryDependency] : [])] }); }
	const rank: Record<string, number> = { campaign: 0, character: 1, "official-inventory": 2, "inventory-definition": 2, "official-ritual": 2, "ritual-definition": 2, "official-attack": 3, "attack-definition": 3, "inventory-entry": 4, "ritual-entry": 4, "attack-entry": 5 };
	return [...items.values()].sort((a, b) => (rank[a.kind] ?? 99) - (rank[b.kind] ?? 99));
}

export function selectedImportItems(items: ImportItem[], selected: Set<string>): ImportItem[] {
	const byKey = new Map(items.map((item) => [importKey(item), item]));
	const resolved = new Set<string>();
	const include = (key: string) => { if (resolved.has(key)) return; const item = byKey.get(key); if (!item) return; resolved.add(key); item.dependencies.forEach(include); };
	selected.forEach(include);
	return items.filter((item) => resolved.has(importKey(item)));
}
