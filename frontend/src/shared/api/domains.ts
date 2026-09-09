import { z } from "zod";
import { type CampaignInput, campaignSchema } from "../contracts/campaign";
import {
	type CharacterInput,
	characterSchema,
} from "../contracts/character-sheet";
import {
	preferencesSchema,
	type UserPreferences,
} from "../contracts/preferences";
import { systemSchema } from "../contracts/rpg-system";
import { type ProfileInput, userSchema } from "../contracts/user";
import { request } from "./client";

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
