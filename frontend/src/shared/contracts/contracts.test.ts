import { expect, test } from "vitest";
import { campaignInputSchema } from "./campaign";
import { ordemDataSchema } from "./character-sheet";
import { createOrdemData } from "./defaults";

test("rejeita campanha sem nome e campos desconhecidos", () => {
	expect(
		campaignInputSchema.safeParse({
			name: " ",
			systemId: "invalid",
			description: "",
			status: "active",
		}).success,
	).toBe(false);
	expect(
		campaignInputSchema.safeParse({
			name: "Caso",
			systemId: "1e9480ec-e177-4b33-90c7-ea576c87b9af",
			description: "",
			status: "active",
			ownerId: "other",
		}).success,
	).toBe(false);
});
test("rejeita dados de Ordem fora dos limites do catálogo", () => {
	const valid = createOrdemData();
	expect(ordemDataSchema.safeParse(valid).success).toBe(true);
	expect(ordemDataSchema.safeParse({ ...valid, nex: 100 }).success).toBe(false);
	expect(
		ordemDataSchema.safeParse({
			...valid,
			attributes: { ...valid.attributes, agility: 6 },
		}).success,
	).toBe(false);
	expect(
		ordemDataSchema.safeParse({
			...valid,
			classId: "e85e3e7c-ab09-479d-924a-e81575526681",
		}).success,
	).toBe(false);
});
