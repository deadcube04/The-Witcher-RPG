import type { CharacterInput, OrdemData } from "@/shared/contracts/character-sheet";
export function createOrdemData(): OrdemData {
	return {
		kind: "ordem-paranormal",
		nex: 5,
		progressionMode: "nex",
		level: null,
		patent: null,
		survivorClassId: null,
		survivorStage: null,
		survivorTrailId: null,
		trailId: null,
		classId: null,
		originId: null,
		creditLimit: null,
		peLimit: 0,
		attributes: {
			agility: 1,
			strength: 1,
			intellect: 1,
			presence: 1,
			vigor: 1,
		},
		resources: {
			health: { current: 0, maximum: 0, temporary: 0, baseMaximum: 0, maxAdjustment: 0 },
			effort: { current: 0, maximum: 0, temporary: 0, baseMaximum: 0, maxAdjustment: 0 },
			sanity: { current: 0, maximum: 0, temporary: 0, baseMaximum: 0, maxAdjustment: 0 },
			determination: null,
		},
	};
}
export function createCharacterInput(
	systemId: string,
	campaignId: string | null,
	systemData: CharacterInput["systemData"],
): CharacterInput {
	return {
		name: "",
		imageUrl: "",
		systemId,
		campaignId,
		supplementId: null,
		supplementRuleIds: [],
		description: "",
		appearance: "",
		personality: "",
		background: "",
		objective: "",
		systemData,
	};
}
