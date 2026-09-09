import { HttpResponse, http } from "msw";
import {
	type CharacterInput,
	characterInputSchema,
} from "../../shared/contracts/character-sheet";
import type { MockDatabase, MockRepository } from "../database/repository";
import { body, fail, safe } from "./common";

function owned(
	state: MockDatabase,
	id: string | readonly string[] | undefined,
) {
	return (
		state.characters.find(
			(item) => item.id === id && item.ownerId === state.user.id,
		) ?? fail("CHARACTER_NOT_FOUND")
	);
}
function validate(input: CharacterInput, state: MockDatabase) {
	const system =
		state.systems.find((item) => item.id === input.systemId) ??
		fail("RPG_SYSTEM_NOT_FOUND");
	if (system.slug !== input.systemData.kind) fail("SYSTEM_MISMATCH");
	if (input.campaignId !== null) {
		const campaign =
			state.campaigns.find(
				(item) =>
					item.id === input.campaignId && item.ownerId === state.user.id,
			) ?? fail("CAMPAIGN_NOT_FOUND");
		if (campaign.systemId !== input.systemId) fail("SYSTEM_MISMATCH");
	}
}
export function characterHandlers(repo: MockRepository) {
	return [
		http.get("*/api/v1/character-sheets", () =>
			safe(() => {
				const state = repo.read();
				return HttpResponse.json(
					state.characters.filter((item) => item.ownerId === state.user.id),
				);
			}),
		),
		http.get("*/api/v1/character-sheets/:id", ({ params }) =>
			safe(() => HttpResponse.json(owned(repo.read(), params.id))),
		),
		http.post("*/api/v1/character-sheets", ({ request }) =>
			safe(async () => {
				const input = await body(request, characterInputSchema);
				const state = repo.read();
				validate(input, state);
				const now = new Date().toISOString();
				const sheet = {
					...input,
					id: crypto.randomUUID(),
					ownerId: state.user.id,
					createdAt: now,
					updatedAt: now,
				};
				repo.update((data) => ({
					...data,
					characters: [...data.characters, sheet],
				}));
				return HttpResponse.json(sheet, { status: 201 });
			}),
		),
		http.patch("*/api/v1/character-sheets/:id", ({ request, params }) =>
			safe(async () => {
				const input = await body(request, characterInputSchema.partial());
				const state = repo.read();
				const sheet = {
					...owned(state, params.id),
					...input,
					updatedAt: new Date().toISOString(),
				};
				validate(sheet, state);
				repo.update((data) => ({
					...data,
					characters: data.characters.map((item) =>
						item.id === sheet.id ? sheet : item,
					),
				}));
				return HttpResponse.json(sheet);
			}),
		),
		http.delete("*/api/v1/character-sheets/:id", ({ params }) =>
			safe(() => {
				const sheet = owned(repo.read(), params.id);
				repo.update((data) => ({
					...data,
					characters: data.characters.filter((item) => item.id !== sheet.id),
				}));
				return new HttpResponse(null, { status: 204 });
			}),
		),
	];
}
