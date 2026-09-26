import { HttpResponse, http } from "msw";
import { preferencesPatchSchema } from "@/shared/contracts/preferences";
import { profileInputSchema } from "@/shared/contracts/user";
import type { MockRepository } from "@/mocks/database/repository";
import { campaignHandlers } from "@/mocks/handlers/campaigns";
import { characterHandlers } from "@/mocks/handlers/characters";
import { attackHandlers } from "@/mocks/handlers/attacks";
import { inventoryHandlers } from "@/mocks/handlers/inventory";
import { ritualHandlers } from "@/mocks/handlers/rituals";
import { skillHandlers } from "@/mocks/handlers/skills";
import { body, fail, safe } from "@/mocks/handlers/common";

export function createHandlers(repo: MockRepository) {
	return [
		http.get("*/api/v1/me", () =>
			safe(() => HttpResponse.json(repo.read().user)),
		),
		http.patch("*/api/v1/me", ({ request }) =>
			safe(async () => {
				const input = await body(request, profileInputSchema.partial());
				return HttpResponse.json(
					repo.update((state) => ({
						...state,
						user: { ...state.user, ...input },
					})).user,
				);
			}),
		),
		http.get("*/api/v1/me/preferences", () =>
			safe(() => HttpResponse.json(repo.read().preferences)),
		),
		http.patch("*/api/v1/me/preferences", ({ request }) =>
			safe(async () => {
				const input = await body(request, preferencesPatchSchema);
				const state = repo.read();
				const preferences = { ...state.preferences, ...input };
				const system =
					state.systems.find(
						(item) => item.id === preferences.activeSystemId,
					) ?? fail("RPG_SYSTEM_NOT_FOUND");
				if (
					input.activeSystemId &&
					input.activeSystemId !== state.preferences.activeSystemId &&
					input.activeThemeId === undefined &&
					preferences.activeThemeId !== null &&
					!system.availableThemes.includes(preferences.activeThemeId)
				)
					preferences.activeThemeId = "nexus";
				if (
					preferences.activeThemeId !== null &&
					!system.availableThemes.includes(preferences.activeThemeId)
				)
					fail("SYSTEM_MISMATCH");
				return HttpResponse.json(
					repo.update((data) => ({ ...data, preferences })).preferences,
				);
			}),
		),
		http.get("*/api/v1/rpg-systems", () =>
			safe(() => HttpResponse.json(repo.read().systems)),
		),
		...campaignHandlers(repo),
		...characterHandlers(repo),
		...inventoryHandlers(repo),
		...ritualHandlers(repo),
		...skillHandlers(repo),
		...attackHandlers(repo),
	];
}
