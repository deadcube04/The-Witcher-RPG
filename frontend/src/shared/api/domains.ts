import { z } from "zod";
import { type CampaignInput, campaignSchema } from "@/shared/contracts/campaign";
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
	update: (id: string, input: Partial<CampaignInput>) =>
		request(`/campaigns/${encodeURIComponent(id)}`, campaignSchema, {
			method: "PATCH",
			body: JSON.stringify(input),
		}),
	remove: (id: string) =>
		request(`/campaigns/${encodeURIComponent(id)}`, z.undefined(), {
			method: "DELETE",
		}),
};
export const characterApi = {
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
	catalog: (query = "", kind?: InventoryKind, signal?: AbortSignal) =>
		request(
			withSearch("/ordem/catalog/inventory", { query, kind }),
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
	catalog: (query = "", element?: string, signal?: AbortSignal) =>
		request(
			withSearch("/ordem/catalog/rituals", { query, element }),
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
	catalog: (query = "", source?: string, signal?: AbortSignal) =>
		request(
			withSearch("/ordem/catalog/attacks", { query, source }),
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
