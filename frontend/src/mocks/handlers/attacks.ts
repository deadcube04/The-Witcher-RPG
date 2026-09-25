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
	attackAddSchema,
	attackEntryPatchSchema,
	ordemAttackInputSchema,
} from "@/shared/contracts/ordem-attack";
import { idSchema } from "@/shared/contracts/common";
import { z } from "zod";

const fromInventorySchema = z.strictObject({ inventoryEntryId: idSchema });

export function attackHandlers(repo: MockRepository) {
	return [
		http.get("*/api/v1/ordem/catalog/attacks", ({ request }) =>
			safe(() => {
				const state = repo.read();
				const url = new URL(request.url);
				const query = normalized(url.searchParams.get("query") ?? "");
				const source = url.searchParams.get("source");
				return HttpResponse.json(
					state.attackDefinitions
						.filter((definition) =>
							visibleSource(definition.source, state.user.id),
						)
						.filter(
							(definition) =>
								!query ||
								normalized(
									`${definition.name} ${definition.skillName} ${definition.damageType}`,
								).includes(query),
						)
						.filter((definition) =>
							source !== "official" && source !== "homebrew"
								? true
								: definition.source.kind === source,
						)
						.sort((left, right) =>
							left.name.localeCompare(right.name, "pt-BR"),
						),
				);
			}),
		),
		http.post("*/api/v1/ordem/homebrew/attacks", ({ request }) =>
			safe(async () => {
				const input = await body(request, ordemAttackInputSchema);
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
					attackDefinitions: [...data.attackDefinitions, definition],
				}));
				return HttpResponse.json(definition, { status: 201 });
			}),
		),
		http.patch(
			"*/api/v1/ordem/homebrew/attacks/:definitionId",
			({ request, params }) =>
				safe(async () => {
					const input = await body(request, ordemAttackInputSchema);
					const state = repo.read();
					const id = routeId(params.definitionId);
					const current = state.attackDefinitions.find(
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
						attackDefinitions: data.attackDefinitions.map((item) =>
							item.id === id ? definition : item,
						),
					}));
					return HttpResponse.json(definition);
				}),
		),
		http.delete("*/api/v1/ordem/homebrew/attacks/:definitionId", ({ params }) =>
			safe(() => {
				const state = repo.read();
				const id = routeId(params.definitionId);
				const definition = state.attackDefinitions.find(
					(item) => item.id === id,
				);
				if (
					!definition ||
					definition.source.kind !== "homebrew" ||
					definition.source.ownerId !== state.user.id
				)
					fail("CONTENT_NOT_FOUND");
				if (
					state.characterAttackEntries.some(
						(entry) => entry.definitionId === id,
					)
				)
					fail("CONTENT_IN_USE");
				repo.update((data) => ({
					...data,
					attackDefinitions: data.attackDefinitions.filter(
						(item) => item.id !== id,
					),
				}));
				return new HttpResponse(null, { status: 204 });
			}),
		),
		http.get("*/api/v1/character-sheets/:characterId/attacks", ({ params }) =>
			safe(() => {
				const state = repo.read();
				const characterId = routeId(params.characterId);
				ownedCharacter(state, characterId);
				return HttpResponse.json(
					state.characterAttackEntries
						.filter((entry) => entry.characterId === characterId)
						.map((entry) => {
							const definition =
								state.attackDefinitions.find(
									(item) => item.id === entry.definitionId,
								) ?? fail("CONTENT_NOT_FOUND");
							const inventoryEntry = entry.sourceInventoryEntryId
								? state.characterInventoryEntries.find(
										(item) => item.id === entry.sourceInventoryEntryId,
									)
								: undefined;
							const inventoryDefinition = inventoryEntry
								? state.inventoryDefinitions.find(
										(item) => item.id === inventoryEntry.definitionId,
									)
								: undefined;
							return {
								entry,
								definition,
								sourceInventory:
									inventoryEntry && inventoryDefinition
										? {
												entryId: inventoryEntry.id,
												name: inventoryDefinition.name,
											}
										: null,
							};
						})
						.sort((left, right) =>
							left.definition.name.localeCompare(
								right.definition.name,
								"pt-BR",
							),
						),
				);
			}),
		),
		http.post(
			"*/api/v1/character-sheets/:characterId/attacks/from-inventory",
			({ request, params }) =>
				safe(async () => {
					const input = await body(request, fromInventorySchema);
					const state = repo.read();
					const characterId = routeId(params.characterId);
					ownedCharacter(state, characterId);
					const inventoryEntry =
						state.characterInventoryEntries.find(
							(entry) =>
								entry.id === input.inventoryEntryId &&
								entry.characterId === characterId,
						) ?? fail("CONTENT_NOT_FOUND");
					const inventoryDefinition =
						state.inventoryDefinitions.find(
							(item) => item.id === inventoryEntry.definitionId,
						) ?? fail("CONTENT_NOT_FOUND");
					if (inventoryDefinition.kind !== "weapon") fail("INVALID_REQUEST");
					let definition = state.attackDefinitions.find(
						(item) =>
							item.sourceItemDefinitionId === inventoryEntry.definitionId &&
							visibleSource(item.source, state.user.id),
					);
					if (!definition) {
						const now = new Date().toISOString();
						const generated = {
							id: crypto.randomUUID(),
							systemId: inventoryDefinition.systemId,
							source: inventoryDefinition.source,
							createdAt: now,
							updatedAt: now,
							name: `Ataque com ${inventoryDefinition.name}`,
							description: `Ataque gerado a partir de ${inventoryDefinition.name}.`,
							skillName:
								inventoryDefinition.rangeText === "Corpo a corpo"
									? "Luta"
									: "Pontaria",
							testExpression: "1d20",
							damageExpression: inventoryDefinition.damageExpression,
							damageType: inventoryDefinition.damageType,
							criticalThreshold: inventoryDefinition.criticalThreshold,
							criticalMultiplier: inventoryDefinition.criticalMultiplier,
							rangeText: inventoryDefinition.rangeText,
							special: "",
							sourceItemDefinitionId: inventoryDefinition.id,
						};
						definition = generated;
						repo.update((data) => ({
							...data,
							attackDefinitions: [...data.attackDefinitions, generated],
						}));
					}
					return addAttack(repo, characterId, definition.id, inventoryEntry.id);
				}),
		),
		http.post(
			"*/api/v1/character-sheets/:characterId/attacks",
			({ request, params }) =>
				safe(async () => {
					const input = await body(request, attackAddSchema);
					const state = repo.read();
					const characterId = routeId(params.characterId);
					const character = ownedCharacter(state, characterId);
					const definition =
						state.attackDefinitions.find(
							(item) =>
								item.id === input.definitionId &&
								item.systemId === character.systemId &&
								visibleSource(item.source, state.user.id),
						) ?? fail("CONTENT_NOT_FOUND");
					if (input.sourceInventoryEntryId) {
						const source =
							state.characterInventoryEntries.find(
								(entry) =>
									entry.id === input.sourceInventoryEntryId &&
									entry.characterId === characterId,
							) ?? fail("CONTENT_NOT_FOUND");
						if (
							definition.sourceItemDefinitionId &&
							definition.sourceItemDefinitionId !== source.definitionId
						)
							fail("INVALID_REQUEST");
					}
					return addAttack(
						repo,
						characterId,
						definition.id,
						input.sourceInventoryEntryId,
					);
				}),
		),
		http.patch(
			"*/api/v1/character-sheets/:characterId/attacks/:entryId",
			({ request, params }) =>
				safe(async () => {
					const input = await body(request, attackEntryPatchSchema);
					const state = repo.read();
					const characterId = routeId(params.characterId);
					ownedCharacter(state, characterId);
					const entryId = routeId(params.entryId);
					const current =
						state.characterAttackEntries.find(
							(entry) =>
								entry.id === entryId && entry.characterId === characterId,
						) ?? fail("CONTENT_NOT_FOUND");
					if (input.definitionId) {
						const definition =
							state.attackDefinitions.find(
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
						characterAttackEntries: data.characterAttackEntries.map((item) =>
							item.id === entryId ? entry : item,
						),
					}));
					return HttpResponse.json(entry);
				}),
		),
		http.delete(
			"*/api/v1/character-sheets/:characterId/attacks/:entryId",
			({ params }) =>
				safe(() => {
					const state = repo.read();
					const characterId = routeId(params.characterId);
					ownedCharacter(state, characterId);
					const entryId = routeId(params.entryId);
					if (
						!state.characterAttackEntries.some(
							(entry) =>
								entry.id === entryId && entry.characterId === characterId,
						)
					)
						fail("CONTENT_NOT_FOUND");
					repo.update((data) => ({
						...data,
						characterAttackEntries: data.characterAttackEntries.filter(
							(entry) => entry.id !== entryId,
						),
					}));
					return new HttpResponse(null, { status: 204 });
				}),
		),
	];
}

function addAttack(
	repo: MockRepository,
	characterId: string,
	definitionId: string,
	sourceInventoryEntryId: string | null,
) {
	const state = repo.read();
	if (
		state.characterAttackEntries.some(
			(entry) =>
				entry.characterId === characterId &&
				entry.definitionId === definitionId,
		)
	)
		fail("CONTENT_ALREADY_ADDED");
	const now = new Date().toISOString();
	const entry = {
		id: crypto.randomUUID(),
		characterId,
		definitionId,
		sourceInventoryEntryId,
		notes: "",
		createdAt: now,
		updatedAt: now,
	};
	repo.update((data) => ({
		...data,
		characterAttackEntries: [...data.characterAttackEntries, entry],
	}));
	return HttpResponse.json(entry, { status: 201 });
}
