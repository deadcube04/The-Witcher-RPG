import type { OrdemAttackInput } from "@/shared/contracts/ordem-attack";
import type { OrdemInventoryInput } from "@/shared/contracts/ordem-inventory";
import type {
	OrdemRitualInput,
	RitualTier,
} from "@/shared/contracts/ordem-ritual";

export const emptyInventoryInput: OrdemInventoryInput = {
	kind: "equipment",
	name: "",
	description: "",
	category: null,
	spaces: 1,
};

export const emptyAttackInput: OrdemAttackInput = {
	name: "",
	description: "",
	skillName: "Luta",
	testExpression: "1d20",
	damageExpression: "1d6",
	damageType: "",
	criticalThreshold: 20,
	criticalMultiplier: 2,
	rangeText: "Corpo a corpo",
	special: "",
	sourceItemDefinitionId: null,
};

const emptyTier: RitualTier = { peCost: 1, effect: "", rolls: [] };
export const emptyRitualInput: OrdemRitualInput = {
	name: "",
	description: "",
	element: "blood",
	circle: 1,
	execution: "Padrão",
	rangeText: "Curto",
	targetText: "Uma criatura",
	areaText: "",
	durationText: "Instantânea",
	resistanceText: "",
	tiers: {
		normal: { ...emptyTier },
		discente: { ...emptyTier, peCost: 3 },
		verdadeiro: { ...emptyTier, peCost: 6 },
	},
};
