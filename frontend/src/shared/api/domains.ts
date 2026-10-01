import { z } from "zod";
import { type CampaignInput, campaignSchema, ordemCampaignSettingsSchema } from "@/shared/contracts/campaign";
import { supplementSchema, reviewIssueSchema, reviewCandidateSchema, supplementReferenceSchema } from "@/shared/contracts/supplement";
import { supplementPowerSchema } from "@/shared/contracts/supplement-power";
import { supplementModificationSchema } from "@/shared/contracts/supplement-modification";
import {
	type CharacterInput,
	characterSchema,
} from "@/shared/contracts/character-sheet";
import {
	preferencesSchema,
	type UserPreferences,
} from "@/shared/contracts/preferences";
import { systemSchema } from "@/shared/contracts/rpg-system";
import { type ProfileInput, userSchema } from "@/shared/contracts/user";
import {
	characterAttackEntrySchema,
	characterAttackSchema,
	type OrdemAttackInput,
	ordemAttackDefinitionSchema,
} from "@/shared/contracts/ordem-attack";
import {
	characterInventoryEntrySchema,
	characterInventoryItemSchema,
	type InventoryEntryPatch,
	type InventoryKind,
	type OrdemInventoryInput,
	ordemInventoryDefinitionSchema,
} from "@/shared/contracts/ordem-inventory";
import {
	characterRitualEntrySchema,
	characterRitualSchema,
	type OrdemRitualInput,
	ordemRitualDefinitionSchema,
} from "@/shared/contracts/ordem-ritual";
import { request } from "@/shared/api/client";
import { characterOptionsSchema } from "@/shared/contracts/character-options";
import { characterSkillSchema, type CharacterSkillUpdate } from "@/shared/contracts/character-skill";
import { errorGroupSchema, errorOccurrenceSchema, errorPageSchema, retentionRulesSchema, type ErrorFilter, type RetentionRule } from "@/shared/contracts/application-error";
import { bestiaryDetailSchema, bestiaryOptionsSchema, bestiaryPageSchema, type BestiaryFilters } from "@/shared/contracts/bestiary";

function withSearch(
	path: string,
	values: Record<string, string | undefined>,
): string {
	const search = new URLSearchParams();
	for (const [key, value] of Object.entries(values)) {
		if (value) search.set(key, value);
	}
	const query = search.toString();
	return query ? `${path}?${query}` : path;
}

export const userApi = {
	get: (signal?: AbortSignal) => request("/me", userSchema, { signal }),
	update: (input: ProfileInput) =>
		request("/me", userSchema, {
			method: "PATCH",
			body: JSON.stringify(input),
		}),
};
export const errorAdminApi = {
	groups: (filter: ErrorFilter, signal?: AbortSignal) => request(withSearch("/admin/errors/groups", Object.fromEntries(Object.entries(filter).map(([key, value]) => [key, value === undefined ? undefined : String(value)]))), errorPageSchema(errorGroupSchema), { signal }),
	occurrences: (filter: ErrorFilter, signal?: AbortSignal) => request(withSearch("/admin/errors/occurrences", Object.fromEntries(Object.entries(filter).map(([key, value]) => [key, value === undefined ? undefined : String(value)]))), errorPageSchema(errorOccurrenceSchema), { signal }),
	occurrence: (id: string, signal?: AbortSignal) => request(`/admin/errors/occurrences/${encodeURIComponent(id)}`, errorOccurrenceSchema, { signal }),
	setGroupState: (id: string, state: "open" | "resolved") => request(`/admin/errors/groups/${encodeURIComponent(id)}`, z.undefined(), { method: "PATCH", body: JSON.stringify({ state }) }),
	updateOccurrences: (ids: string[], expiresAt: string | null) => request("/admin/errors/occurrences", z.undefined(), { method: "PATCH", body: JSON.stringify({ ids, expiresAt }) }),
	deleteOccurrences: (ids: string[]) => request("/admin/errors/occurrences", z.undefined(), { method: "DELETE", body: JSON.stringify({ ids }) }),
	retention: (signal?: AbortSignal) => request("/admin/errors/retention", retentionRulesSchema, { signal }),
	updateRetention: (rules: RetentionRule[]) => request("/admin/errors/retention", z.undefined(), { method: "PUT", body: JSON.stringify({ rules }) }),
};
export const preferencesApi = {
	get: (signal?: AbortSignal) =>
		request("/me/preferences", preferencesSchema, { signal }),
	update: (input: Partial<UserPreferences>) =>
		request("/me/preferences", preferencesSchema, {
			method: "PATCH",
			body: JSON.stringify(input),
		}),
};
export const systemsApi = {
	list: (signal?: AbortSignal) =>
		request("/rpg-systems", z.array(systemSchema), { signal }),
};
export const campaignApi = {
	list: (signal?: AbortSignal) =>
		request("/campaigns", z.array(campaignSchema), { signal }),
	get: (id: string, signal?: AbortSignal) =>
		request(`/campaigns/${encodeURIComponent(id)}`, campaignSchema, { signal }),
	create: (input: CampaignInput) =>
		request("/campaigns", campaignSchema, {
			method: "POST",
			body: JSON.stringify(input),
		}),
	updateSettings: (id: string, settings: z.infer<typeof ordemCampaignSettingsSchema>) =>
		request(`/campaigns/${encodeURIComponent(id)}/settings`, campaignSchema, { method: "PATCH", body: JSON.stringify(settings) }),
	remove: (id: string) =>
		request(`/campaigns/${encodeURIComponent(id)}`, z.undefined(), {
			method: "DELETE",
		}),
};
export const supplementApi = {
	list: (signal?: AbortSignal) => request("/ordem/supplements", z.array(supplementSchema), { signal }),
};
export const supplementReviewApi = {
	linkTarget: (supplementId: string, issueId: string, input: { targetKind: string; targetId: string; fieldName: string }) => request(`/admin/supplements/${encodeURIComponent(supplementId)}/issues/${encodeURIComponent(issueId)}/target`, z.undefined(), { method: "PUT", body: JSON.stringify(input) }),
	issues: (supplementId: string, state: "open" | "resolved", signal?: AbortSignal) => request(withSearch(`/admin/supplements/${encodeURIComponent(supplementId)}/issues`, { state }), z.array(reviewIssueSchema), { signal }),
	source: (supplementId: string, issueId: string, signal?: AbortSignal) => request(`/admin/supplements/${encodeURIComponent(supplementId)}/issues/${encodeURIComponent(issueId)}/source`, z.strictObject({ pdfPage: z.number().int(), sourceFile: z.string(), rawText: z.string(), sha256: z.string() }), { signal }),
	candidates: (supplementId: string, issueId: string, signal?: AbortSignal) => request(`/admin/supplements/${encodeURIComponent(supplementId)}/issues/${encodeURIComponent(issueId)}/candidates`, z.array(reviewCandidateSchema), { signal }),
	currentValue: (supplementId: string, kind: string, targetId: string, field: string, signal?: AbortSignal) => request(withSearch(`/admin/supplements/${encodeURIComponent(supplementId)}/targets/${encodeURIComponent(kind)}/${encodeURIComponent(targetId)}`, { field }), z.strictObject({ value: z.string() }), { signal }),
	resolve: (supplementId: string, issueId: string, input: { targetKind: string; targetId: string; fieldName: string; expectedValue: string; newValue: string; justification: string }) => request(`/admin/supplements/${encodeURIComponent(supplementId)}/issues/${encodeURIComponent(issueId)}/resolve`, z.undefined(), { method: "POST", body: JSON.stringify(input) }),
};
export const characterApi = {
	supplementReference: (id: string, signal?: AbortSignal) => request(`/character-sheets/${encodeURIComponent(id)}/supplement-reference`, supplementReferenceSchema, { signal }),
	powers: (id: string, signal?: AbortSignal) => request(`/character-sheets/${encodeURIComponent(id)}/powers`, z.array(supplementPowerSchema), { signal }),
	setPower: (id: string, powerId: string, selected: boolean) => request(`/character-sheets/${encodeURIComponent(id)}/powers/${encodeURIComponent(powerId)}`, z.undefined(), { method: "PUT", body: JSON.stringify({ selected }) }),
	options: (signal?: AbortSignal) => request("/ordem/character-options", characterOptionsSchema, { signal }),
	skills: (id: string, signal?: AbortSignal) => request(`/character-sheets/${encodeURIComponent(id)}/skills`, z.array(characterSkillSchema), { signal }),
	updateSkills: (id: string, updates: CharacterSkillUpdate[]) => request(`/character-sheets/${encodeURIComponent(id)}/skills`, z.array(characterSkillSchema), { method: "PUT", body: JSON.stringify(updates) }),
	list: (signal?: AbortSignal) =>
		request("/character-sheets", z.array(characterSchema), { signal }),
	get: (id: string, signal?: AbortSignal) =>
		request(`/character-sheets/${encodeURIComponent(id)}`, characterSchema, {
			signal,
		}),
	create: (input: CharacterInput) =>
		request("/character-sheets", characterSchema, {
			method: "POST",
			body: JSON.stringify(input),
		}),
	update: (id: string, input: Partial<CharacterInput>) =>
		request(`/character-sheets/${encodeURIComponent(id)}`, characterSchema, {
			method: "PATCH",
			body: JSON.stringify(input),
		}),
	remove: (id: string) =>
		request(`/character-sheets/${encodeURIComponent(id)}`, z.undefined(), {
			method: "DELETE",
		}),
};

export const inventoryApi = {
	modifications: (characterId: string, entryId: string, signal?: AbortSignal) => request(`/character-sheets/${encodeURIComponent(characterId)}/inventory/${encodeURIComponent(entryId)}/modifications`, z.array(supplementModificationSchema), { signal }),
	setModification: (characterId: string, entryId: string, modificationId: string, selected: boolean) => request(`/character-sheets/${encodeURIComponent(characterId)}/inventory/${encodeURIComponent(entryId)}/modifications/${encodeURIComponent(modificationId)}`, z.undefined(), { method: "PUT", body: JSON.stringify({ selected }) }),
	catalog: (query = "", kind?: InventoryKind, signal?: AbortSignal, characterId?: string) =>
		request(
			withSearch("/ordem/catalog/inventory", { query, kind, characterId }),
			z.array(ordemInventoryDefinitionSchema),
			{ signal },
		),
	list: (characterId: string, signal?: AbortSignal) =>
		request(
			`/character-sheets/${encodeURIComponent(characterId)}/inventory`,
			z.array(characterInventoryItemSchema),
			{ signal },
		),
	add: (characterId: string, definitionId: string) =>
		request(
			`/character-sheets/${encodeURIComponent(characterId)}/inventory`,
			characterInventoryEntrySchema,
			{
				method: "POST",
				body: JSON.stringify({ definitionId, quantity: 1 }),
			},
		),
	updateEntry: (
		characterId: string,
		entryId: string,
		input: InventoryEntryPatch,
	) =>
		request(
			`/character-sheets/${encodeURIComponent(characterId)}/inventory/${encodeURIComponent(entryId)}`,
			characterInventoryEntrySchema,
			{ method: "PATCH", body: JSON.stringify(input) },
		),
	removeEntry: (
		characterId: string,
		entryId: string,
		attackPolicy?: "detach" | "remove",
	) =>
		request(
			withSearch(
				`/character-sheets/${encodeURIComponent(characterId)}/inventory/${encodeURIComponent(entryId)}`,
				{ attackPolicy },
			),
			z.undefined(),
			{ method: "DELETE" },
		),
	createHomebrew: (input: OrdemInventoryInput) =>
		request("/ordem/homebrew/inventory", ordemInventoryDefinitionSchema, {
			method: "POST",
			body: JSON.stringify(input),
		}),
	updateHomebrew: (id: string, input: OrdemInventoryInput) =>
		request(
			`/ordem/homebrew/inventory/${encodeURIComponent(id)}`,
			ordemInventoryDefinitionSchema,
			{ method: "PATCH", body: JSON.stringify(input) },
		),
	removeHomebrew: (id: string) =>
		request(
			`/ordem/homebrew/inventory/${encodeURIComponent(id)}`,
			z.undefined(),
			{ method: "DELETE" },
		),
};

export const ritualApi = {
	catalog: (query = "", element?: string, signal?: AbortSignal, characterId?: string) =>
		request(
			withSearch("/ordem/catalog/rituals", { query, element, characterId }),
			z.array(ordemRitualDefinitionSchema),
			{ signal },
		),
	list: (characterId: string, signal?: AbortSignal) =>
		request(
			`/character-sheets/${encodeURIComponent(characterId)}/rituals`,
			z.array(characterRitualSchema),
			{ signal },
		),
	add: (characterId: string, definitionId: string) =>
		request(
			`/character-sheets/${encodeURIComponent(characterId)}/rituals`,
			characterRitualEntrySchema,
			{ method: "POST", body: JSON.stringify({ definitionId }) },
		),
	updateEntry: (characterId: string, entryId: string, input: { definitionId?: string; notes?: string }) =>
		request(
			`/character-sheets/${encodeURIComponent(characterId)}/rituals/${encodeURIComponent(entryId)}`,
			characterRitualEntrySchema,
			{ method: "PATCH", body: JSON.stringify(input) },
		),
	removeEntry: (characterId: string, entryId: string) =>
		request(
			`/character-sheets/${encodeURIComponent(characterId)}/rituals/${encodeURIComponent(entryId)}`,
			z.undefined(),
			{ method: "DELETE" },
		),
	createHomebrew: (input: OrdemRitualInput) =>
		request("/ordem/homebrew/rituals", ordemRitualDefinitionSchema, {
			method: "POST",
			body: JSON.stringify(input),
		}),
	updateHomebrew: (id: string, input: OrdemRitualInput) =>
		request(
			`/ordem/homebrew/rituals/${encodeURIComponent(id)}`,
			ordemRitualDefinitionSchema,
			{ method: "PATCH", body: JSON.stringify(input) },
		),
	removeHomebrew: (id: string) =>
		request(
			`/ordem/homebrew/rituals/${encodeURIComponent(id)}`,
			z.undefined(),
			{ method: "DELETE" },
		),
};

export const attackApi = {
	catalog: (query = "", source?: string, signal?: AbortSignal, characterId?: string) =>
		request(
			withSearch("/ordem/catalog/attacks", { query, source, characterId }),
			z.array(ordemAttackDefinitionSchema),
			{ signal },
		),
	list: (characterId: string, signal?: AbortSignal) =>
		request(
			`/character-sheets/${encodeURIComponent(characterId)}/attacks`,
			z.array(characterAttackSchema),
			{ signal },
		),
	add: (characterId: string, definitionId: string) =>
		request(
			`/character-sheets/${encodeURIComponent(characterId)}/attacks`,
			characterAttackEntrySchema,
			{
				method: "POST",
				body: JSON.stringify({ definitionId, sourceInventoryEntryId: null }),
			},
		),
	addFromInventory: (characterId: string, inventoryEntryId: string) =>
		request(
			`/character-sheets/${encodeURIComponent(characterId)}/attacks/from-inventory`,
			characterAttackEntrySchema,
			{ method: "POST", body: JSON.stringify({ inventoryEntryId }) },
		),
	updateEntry: (characterId: string, entryId: string, input: { definitionId?: string; notes?: string; sourceInventoryEntryId?: string | null }) =>
		request(
			`/character-sheets/${encodeURIComponent(characterId)}/attacks/${encodeURIComponent(entryId)}`,
			characterAttackEntrySchema,
			{ method: "PATCH", body: JSON.stringify(input) },
		),
	removeEntry: (characterId: string, entryId: string) =>
		request(
			`/character-sheets/${encodeURIComponent(characterId)}/attacks/${encodeURIComponent(entryId)}`,
			z.undefined(),
			{ method: "DELETE" },
		),
	createHomebrew: (input: OrdemAttackInput) =>
		request("/ordem/homebrew/attacks", ordemAttackDefinitionSchema, {
			method: "POST",
			body: JSON.stringify(input),
		}),
	updateHomebrew: (id: string, input: OrdemAttackInput) =>
		request(
			`/ordem/homebrew/attacks/${encodeURIComponent(id)}`,
			ordemAttackDefinitionSchema,
			{ method: "PATCH", body: JSON.stringify(input) },
		),
	removeHomebrew: (id: string) =>
		request(
			`/ordem/homebrew/attacks/${encodeURIComponent(id)}`,
			z.undefined(),
			{ method: "DELETE" },
		),
};

export const bestiaryApi = {
	options: (signal?: AbortSignal) =>
		request("/ordem/bestiary/options", bestiaryOptionsSchema, { signal }),
	list: (filters: BestiaryFilters, page: number, signal?: AbortSignal) =>
		request(
			withSearch("/ordem/bestiary", {
				query: filters.q,
				elementId: filters.elementId,
				beingTypeId: filters.beingTypeId,
				sizeId: filters.sizeId,
				vdMin: filters.vdMin,
				vdMax: filters.vdMax,
				sort: filters.sort ?? "name",
				page: String(page),
				pageSize: "24",
			}),
			bestiaryPageSchema,
			{ signal },
		),
	get: (id: string, filters: BestiaryFilters, signal?: AbortSignal) =>
		request(
			withSearch(`/ordem/bestiary/${encodeURIComponent(id)}`, {
				query: filters.q,
				elementId: filters.elementId,
				beingTypeId: filters.beingTypeId,
				sizeId: filters.sizeId,
				vdMin: filters.vdMin,
				vdMax: filters.vdMax,
				sort: filters.sort ?? "name",
			}),
			bestiaryDetailSchema,
			{ signal },
		),
};
