import { HttpResponse, http } from "msw";
import { z } from "zod";
import optionsSnapshot from "@/mocks/seed/ordem-options.json";
import type { MockRepository } from "@/mocks/database/repository";
import { body, fail, safe } from "@/mocks/handlers/common";
import { characterSkillUpdateSchema, type CharacterSkill } from "@/shared/contracts/character-skill";

const options = {
	...optionsSnapshot,
	skills: optionsSnapshot.skills.map(({ id, slug, name }) => ({ id, slug, name })),
};
const attributeNames: Record<string, keyof Extract<ReturnType<MockRepository["read"]>["characters"][number]["systemData"], { kind: "ordem-paranormal" }>["attributes"]> = {
	agilidade: "agility", forca: "strength", intelecto: "intellect", presenca: "presence", vigor: "vigor",
};

export function skillHandlers(repo: MockRepository) {
	const saved = new Map<string, CharacterSkill[]>();
	const get = (id: string): CharacterSkill[] => {
		const state = repo.read();
		const character = state.characters.find((item) => item.id === id && item.ownerId === state.user.id) ?? fail("CHARACTER_NOT_FOUND");
		const data = character.systemData;
		if (data.kind !== "ordem-paranormal") fail("SYSTEM_MISMATCH");
		const current = saved.get(id);
		const value = optionsSnapshot.skills.map((skill) => {
			const attribute = optionsSnapshot.attributes.find((item) => item.id === skill.attributeId) ?? fail("CONTENT_NOT_FOUND");
			const previous = current?.find((item) => item.id === skill.id);
			const attributeId = previous?.attributeId ?? skill.attributeId;
			const chosen = optionsSnapshot.attributes.find((item) => item.id === attributeId) ?? attribute;
			const count = data.attributes[attributeNames[chosen.slug]];
			const trainingLevelId = previous?.trainingLevelId ?? null;
			const level = optionsSnapshot.trainingLevels.find((item) => item.id === trainingLevelId);
			const trainingBonus = level?.bonus ?? 0;
			const otherBonus = previous?.otherBonus ?? 0;
			return { id: skill.id, name: skill.name, slug: skill.slug, attributeId, attributeSlug: chosen.slug, trainingLevelId, trainingName: level?.name ?? "Leigo", trainingBonus, otherBonus, bonus: trainingBonus + otherBonus, diceCount: count === 0 ? 2 : count, keep: count === 0 ? "lowest" : "highest" } satisfies CharacterSkill;
		});
		saved.set(id, value);
		return value;
	};
	return [
		http.get("*/api/v1/ordem/character-options", () => safe(() => HttpResponse.json(options))),
		http.get("*/api/v1/character-sheets/:id/skills", ({ params }) => safe(() => HttpResponse.json(get(String(params.id))))),
		http.put("*/api/v1/character-sheets/:id/skills", ({ request, params }) => safe(async () => {
			const id = String(params.id);
			const updates = await body(request, z.array(characterSkillUpdateSchema).max(28));
			const current = get(id);
			for (const update of updates) {
				if (!current.some((item) => item.id === update.id) || !optionsSnapshot.attributes.some((item) => item.id === update.attributeId) || (update.trainingLevelId && !optionsSnapshot.trainingLevels.some((item) => item.id === update.trainingLevelId))) fail("CONTENT_NOT_FOUND");
			}
			saved.set(id, current.map((item) => {
				const update = updates.find((entry) => entry.id === item.id);
				return update ? { ...item, ...update } : item;
			}));
			return HttpResponse.json(get(id));
		})),
	];
}
