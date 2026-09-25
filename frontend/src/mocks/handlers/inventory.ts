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
	inventoryAddSchema,
	inventoryEntryPatchSchema,
	inventoryKindSchema,
	ordemInventoryInputSchema,
} from "@/shared/contracts/ordem-inventory";

export function inventoryHandlers(repo: MockRepository) {
	return [
		http.get("*/api/v1/ordem/catalog/inventory", ({ request }) =>
			safe(() => {
				const state = repo.read();
				const url = new URL(request.url);
				const query = normalized(url.searchParams.get("query") ?? "");
				const kind = inventoryKindSchema.safeParse(
					url.searchParams.get("kind"),
				);
				return HttpResponse.json(
					state.inventoryDefinitions
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
							(definition) => !kind.success || definition.kind === kind.data,
						)
						.sort((left, right) =>
							left.name.localeCompare(right.name, "pt-BR"),
						),
				);
			}),
		),
		http.post("*/api/v1/ordem/homebrew/inventory", ({ request }) =>
			safe(async () => {
				const input = await body(request, ordemInventoryInputSchema);
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
					inventoryDefinitions: [...data.inventoryDefinitions, definition],
				}));
				return HttpResponse.json(definition, { status: 201 });
			}),
		),
		http.patch(
			"*/api/v1/ordem/homebrew/inventory/:definitionId",
			({ request, params }) =>
				safe(async () => {
					const input = await body(request, ordemInventoryInputSchema);
					const state = repo.read();
					const id = routeId(params.definitionId);
					const current = state.inventoryDefinitions.find(
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
						inventoryDefinitions: data.inventoryDefinitions.map((item) =>
							item.id === id ? definition : item,
						),
					}));
					return HttpResponse.json(definition);
				}),
		),
		http.delete(
			"*/api/v1/ordem/homebrew/inventory/:definitionId",
			({ params }) =>
				safe(() => {
					const state = repo.read();
					const id = routeId(params.definitionId);
					const definition = state.inventoryDefinitions.find(
						(item) => item.id === id,
					);
					if (
						!definition ||
						definition.source.kind !== "homebrew" ||
						definition.source.ownerId !== state.user.id
					)
						fail("CONTENT_NOT_FOUND");
					if (
						state.characterInventoryEntries.some(
							(entry) => entry.definitionId === id,
						)
					)
						fail("CONTENT_IN_USE");
					const dependentAttackIds = state.attackDefinitions
						.filter((attack) => attack.sourceItemDefinitionId === id)
						.map((attack) => attack.id);
					if (
						state.characterAttackEntries.some((entry) =>
							dependentAttackIds.includes(entry.definitionId),
						)
					)
						fail("CONTENT_IN_USE");
					repo.update((data) => ({
						...data,
						inventoryDefinitions: data.inventoryDefinitions.filter(
							(item) => item.id !== id,
						),
						attackDefinitions: data.attackDefinitions.map((attack) =>
							attack.sourceItemDefinitionId === id
								? { ...attack, sourceItemDefinitionId: null }
								: attack,
						),
					}));
					return new HttpResponse(null, { status: 204 });
				}),
		),
		http.get("*/api/v1/character-sheets/:characterId/inventory", ({ params }) =>
			safe(() => {
				const state = repo.read();
				const characterId = routeId(params.characterId);
				ownedCharacter(state, characterId);
				return HttpResponse.json(
					state.characterInventoryEntries
						.filter((entry) => entry.characterId === characterId)
						.map((entry) => {
							const definition =
								state.inventoryDefinitions.find(
									(item) => item.id === entry.definitionId,
								) ?? fail("CONTENT_NOT_FOUND");
							return {
								entry,
								definition,
								linkedAttackCount: state.characterAttackEntries.filter(
									(attack) => attack.sourceInventoryEntryId === entry.id,
								).length,
							};
						})
						.sort((left, right) =>
							left.entry.equipped === right.entry.equipped
								? left.definition.name.localeCompare(
										right.definition.name,
										"pt-BR",
									)
								: left.entry.equipped
									? -1
									: 1,
						),
				);
			}),
		),
		http.post(
			"*/api/v1/character-sheets/:characterId/inventory",
			({ request, params }) =>
				safe(async () => {
					const input = await body(request, inventoryAddSchema);
					const state = repo.read();
					const characterId = routeId(params.characterId);
					const character = ownedCharacter(state, characterId);
					const definition =
						state.inventoryDefinitions.find(
							(item) =>
								item.id === input.definitionId &&
								item.systemId === character.systemId &&
								visibleSource(item.source, state.user.id),
						) ?? fail("CONTENT_NOT_FOUND");
					const existing = state.characterInventoryEntries.find(
						(entry) =>
							entry.characterId === characterId &&
							entry.definitionId === definition.id,
					);
					const now = new Date().toISOString();
					const entry = existing
						? {
								...existing,
								quantity: existing.quantity + input.quantity,
								updatedAt: now,
							}
						: {
								id: crypto.randomUUID(),
								characterId,
								definitionId: definition.id,
								quantity: input.quantity,
								equipped: false,
								notes: "",
								createdAt: now,
								updatedAt: now,
							};
					repo.update((data) => ({
						...data,
						characterInventoryEntries: existing
							? data.characterInventoryEntries.map((item) =>
									item.id === entry.id ? entry : item,
								)
							: [...data.characterInventoryEntries, entry],
					}));
					return HttpResponse.json(entry, { status: existing ? 200 : 201 });
				}),
		),
		http.patch(
			"*/api/v1/character-sheets/:characterId/inventory/:entryId",
			({ request, params }) =>
				safe(async () => {
					const input = await body(request, inventoryEntryPatchSchema);
					const state = repo.read();
					const characterId = routeId(params.characterId);
					ownedCharacter(state, characterId);
					const entryId = routeId(params.entryId);
					const current =
						state.characterInventoryEntries.find(
							(entry) =>
								entry.id === entryId && entry.characterId === characterId,
						) ?? fail("CONTENT_NOT_FOUND");
					if (input.definitionId) {
						const definition =
							state.inventoryDefinitions.find(
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
						characterInventoryEntries: data.characterInventoryEntries.map(
							(item) => (item.id === entryId ? entry : item),
						),
					}));
					return HttpResponse.json(entry);
				}),
		),
		http.delete(
			"*/api/v1/character-sheets/:characterId/inventory/:entryId",
			({ request, params }) =>
				safe(() => {
					const state = repo.read();
					const characterId = routeId(params.characterId);
					ownedCharacter(state, characterId);
					const entryId = routeId(params.entryId);
					if (
						!state.characterInventoryEntries.some(
							(entry) =>
								entry.id === entryId && entry.characterId === characterId,
						)
					)
						fail("CONTENT_NOT_FOUND");
					const linked = state.characterAttackEntries.some(
						(attack) => attack.sourceInventoryEntryId === entryId,
					);
					const policy = new URL(request.url).searchParams.get("attackPolicy");
					if (linked && policy !== "detach" && policy !== "remove")
						fail("CONTENT_IN_USE");
					repo.update((data) => ({
						...data,
						characterInventoryEntries: data.characterInventoryEntries.filter(
							(entry) => entry.id !== entryId,
						),
						characterAttackEntries:
							policy === "remove"
								? data.characterAttackEntries.filter(
										(attack) => attack.sourceInventoryEntryId !== entryId,
									)
								: data.characterAttackEntries.map((attack) =>
										attack.sourceInventoryEntryId === entryId
											? { ...attack, sourceInventoryEntryId: null }
											: attack,
									),
					}));
					return new HttpResponse(null, { status: 204 });
				}),
		),
	];
}
