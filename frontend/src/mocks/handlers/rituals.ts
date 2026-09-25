import { HttpResponse, http } from "msw";
import type { MockRepository } from "@/mocks/database/repository";
import { body, fail, safe } from "@/mocks/handlers/common";
import {
	normalized,
	ordemSystemId,
	ownedCharacter,
	routeId,
	visibleSource,
} from "@/mocks/handlers/ordem-content-utils";
import {
	ordemRitualInputSchema,
	ritualAddSchema,
	ritualElementSchema,
	ritualEntryPatchSchema,
} from "@/shared/contracts/ordem-ritual";

export function ritualHandlers(repo: MockRepository) {
	return [
		http.get("*/api/v1/ordem/catalog/rituals", ({ request }) =>
			safe(() => {
				const state = repo.read();
				const url = new URL(request.url);
				const query = normalized(url.searchParams.get("query") ?? "");
				const element = ritualElementSchema.safeParse(
					url.searchParams.get("element"),
				);
				return HttpResponse.json(
					state.ritualDefinitions
						.filter((definition) =>
							visibleSource(definition.source, state.user.id),
						)
						.filter(
							(definition) =>
								!query ||
								normalized(
									`${definition.name} ${definition.description}`,
								).includes(query),
						)
						.filter(
							(definition) =>
								!element.success || definition.element === element.data,
						)
						.sort(
							(left, right) =>
								left.circle - right.circle ||
								left.name.localeCompare(right.name, "pt-BR"),
						),
				);
			}),
		),
		http.post("*/api/v1/ordem/homebrew/rituals", ({ request }) =>
			safe(async () => {
				const input = await body(request, ordemRitualInputSchema);
				const state = repo.read();
				const now = new Date().toISOString();
				const definition = {
					...input,
					id: crypto.randomUUID(),
					systemId: ordemSystemId(state),
					source: { kind: "homebrew" as const, ownerId: state.user.id },
					createdAt: now,
					updatedAt: now,
				};
				repo.update((data) => ({
					...data,
					ritualDefinitions: [...data.ritualDefinitions, definition],
				}));
				return HttpResponse.json(definition, { status: 201 });
			}),
		),
		http.patch(
			"*/api/v1/ordem/homebrew/rituals/:definitionId",
			({ request, params }) =>
				safe(async () => {
					const input = await body(request, ordemRitualInputSchema);
					const state = repo.read();
					const id = routeId(params.definitionId);
					const current = state.ritualDefinitions.find(
						(definition) => definition.id === id,
					);
					if (
						!current ||
						current.source.kind !== "homebrew" ||
						current.source.ownerId !== state.user.id
					)
						fail("CONTENT_NOT_FOUND");
					const definition = {
						...current,
						...input,
						updatedAt: new Date().toISOString(),
					};
					repo.update((data) => ({
						...data,
						ritualDefinitions: data.ritualDefinitions.map((item) =>
							item.id === id ? definition : item,
						),
					}));
					return HttpResponse.json(definition);
				}),
		),
		http.delete("*/api/v1/ordem/homebrew/rituals/:definitionId", ({ params }) =>
			safe(() => {
				const state = repo.read();
				const id = routeId(params.definitionId);
				const definition = state.ritualDefinitions.find(
					(item) => item.id === id,
				);
				if (
					!definition ||
					definition.source.kind !== "homebrew" ||
					definition.source.ownerId !== state.user.id
				)
					fail("CONTENT_NOT_FOUND");
				if (
					state.characterRitualEntries.some(
						(entry) => entry.definitionId === id,
					)
				)
					fail("CONTENT_IN_USE");
				repo.update((data) => ({
					...data,
					ritualDefinitions: data.ritualDefinitions.filter(
						(item) => item.id !== id,
					),
				}));
				return new HttpResponse(null, { status: 204 });
			}),
		),
		http.get("*/api/v1/character-sheets/:characterId/rituals", ({ params }) =>
			safe(() => {
				const state = repo.read();
				const characterId = routeId(params.characterId);
				ownedCharacter(state, characterId);
				return HttpResponse.json(
					state.characterRitualEntries
						.filter((entry) => entry.characterId === characterId)
						.map((entry) => ({
							entry,
							definition:
								state.ritualDefinitions.find(
									(definition) => definition.id === entry.definitionId,
								) ?? fail("CONTENT_NOT_FOUND"),
						}))
						.sort(
							(left, right) =>
								left.definition.circle - right.definition.circle ||
								left.definition.name.localeCompare(
									right.definition.name,
									"pt-BR",
								),
						),
				);
			}),
		),
		http.post(
			"*/api/v1/character-sheets/:characterId/rituals",
			({ request, params }) =>
				safe(async () => {
					const input = await body(request, ritualAddSchema);
					const state = repo.read();
					const characterId = routeId(params.characterId);
					const character = ownedCharacter(state, characterId);
					const definition =
						state.ritualDefinitions.find(
							(item) =>
								item.id === input.definitionId &&
								item.systemId === character.systemId &&
								visibleSource(item.source, state.user.id),
						) ?? fail("CONTENT_NOT_FOUND");
					if (
						state.characterRitualEntries.some(
							(entry) =>
								entry.characterId === characterId &&
								entry.definitionId === definition.id,
						)
					)
						fail("CONTENT_ALREADY_ADDED");
					const now = new Date().toISOString();
					const entry = {
						id: crypto.randomUUID(),
						characterId,
						definitionId: definition.id,
						notes: "",
						createdAt: now,
						updatedAt: now,
					};
					repo.update((data) => ({
						...data,
						characterRitualEntries: [...data.characterRitualEntries, entry],
					}));
					return HttpResponse.json(entry, { status: 201 });
				}),
		),
		http.patch(
			"*/api/v1/character-sheets/:characterId/rituals/:entryId",
			({ request, params }) =>
				safe(async () => {
					const input = await body(request, ritualEntryPatchSchema);
					const state = repo.read();
					const characterId = routeId(params.characterId);
					ownedCharacter(state, characterId);
					const entryId = routeId(params.entryId);
					const current =
						state.characterRitualEntries.find(
							(entry) =>
								entry.id === entryId && entry.characterId === characterId,
						) ?? fail("CONTENT_NOT_FOUND");
					if (input.definitionId) {
						const definition =
							state.ritualDefinitions.find(
								(item) => item.id === input.definitionId,
							) ?? fail("CONTENT_NOT_FOUND");
						if (!visibleSource(definition.source, state.user.id))
							fail("CONTENT_NOT_FOUND");
					}
					const entry = {
						...current,
						...input,
						updatedAt: new Date().toISOString(),
					};
					repo.update((data) => ({
						...data,
						characterRitualEntries: data.characterRitualEntries.map((item) =>
							item.id === entryId ? entry : item,
						),
					}));
					return HttpResponse.json(entry);
				}),
		),
		http.delete(
			"*/api/v1/character-sheets/:characterId/rituals/:entryId",
			({ params }) =>
				safe(() => {
					const state = repo.read();
					const characterId = routeId(params.characterId);
					ownedCharacter(state, characterId);
					const entryId = routeId(params.entryId);
					if (
						!state.characterRitualEntries.some(
							(entry) =>
								entry.id === entryId && entry.characterId === characterId,
						)
					)
						fail("CONTENT_NOT_FOUND");
					repo.update((data) => ({
						...data,
						characterRitualEntries: data.characterRitualEntries.filter(
							(entry) => entry.id !== entryId,
						),
					}));
					return new HttpResponse(null, { status: 204 });
				}),
		),
	];
}
