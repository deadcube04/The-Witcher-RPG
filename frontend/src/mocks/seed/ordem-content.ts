import type {
	CharacterAttackEntry,
	OrdemAttackDefinition,
} from "@/shared/contracts/ordem-attack";
import type {
	CharacterInventoryEntry,
	OrdemInventoryDefinition,
} from "@/shared/contracts/ordem-inventory";
import type {
	CharacterRitualEntry,
	OrdemRitualDefinition,
	RitualElement,
	RitualTier,
} from "@/shared/contracts/ordem-ritual";
import { ordemId, ownerId, seedCharacterId } from "@/mocks/seed/identifiers";

const createdAt = "2026-09-01T12:00:00.000Z";
const official = { kind: "official" } as const;

export const inventoryDefinitionIds = {
	axe: "31000000-0000-4000-8000-000000000001",
	pistol: "31000000-0000-4000-8000-000000000002",
	backpack: "31000000-0000-4000-8000-000000000003",
	kit: "31000000-0000-4000-8000-000000000004",
	ammunition: "31000000-0000-4000-8000-000000000005",
} as const;

const inventoryBase = {
	systemId: ordemId,
	source: official,
	createdAt,
	updatedAt: createdAt,
};

export const ordemInventoryDefinitions: OrdemInventoryDefinition[] = [
	{
		...inventoryBase,
		id: inventoryDefinitionIds.axe,
		kind: "weapon",
		name: "Machado de campo",
		description: "Uma ferramenta pesada adaptada para confrontos próximos.",
		category: 1,
		spaces: 1,
		damageExpression: "1d8+3",
		criticalThreshold: 20,
		criticalMultiplier: 3,
		rangeText: "Corpo a corpo",
		damageType: "Corte",
	},
	{
		...inventoryBase,
		id: inventoryDefinitionIds.pistol,
		kind: "weapon",
		name: "Pistola compacta",
		description: "Arma curta discreta, confiável em distâncias reduzidas.",
		category: 1,
		spaces: 1,
		damageExpression: "2d6",
		criticalThreshold: 18,
		criticalMultiplier: 2,
		rangeText: "Curto",
		damageType: "Balístico",
	},
	{
		...inventoryBase,
		id: inventoryDefinitionIds.backpack,
		kind: "equipment",
		name: "Mochila operacional",
		description: "Compartimentos reforçados para equipamento de investigação.",
		category: 1,
		spaces: 2,
	},
	{
		...inventoryBase,
		id: inventoryDefinitionIds.kit,
		kind: "accessory",
		name: "Kit de investigação",
		description: "Lanterna, marcadores, luvas e ferramentas de coleta.",
		category: 0,
		spaces: 1,
	},
	{
		...inventoryBase,
		id: inventoryDefinitionIds.ammunition,
		kind: "ammunition",
		name: "Munição curta",
		description: "Uma caixa de munição para armas curtas.",
		category: 1,
		spaces: 1,
	},
];

function tier(peCost: number, effect: string, expression: string): RitualTier {
	return {
		peCost,
		effect,
		rolls: expression ? [{ label: "Intensidade", expression }] : [],
	};
}

const ritualNames: Record<RitualElement, string> = {
	blood: "Pulso Carmesim",
	death: "Eco do Fim",
	knowledge: "Olho do Segredo",
	energy: "Eletrocussão",
	fear: "Vulto Imóvel",
};

const ritualDescriptions: Record<RitualElement, string> = {
	blood: "Condensa a vitalidade em uma descarga agressiva.",
	death: "Acelera o desgaste de tudo o que alcança.",
	knowledge: "Revela padrões escondidos por alguns instantes.",
	energy: "Projeta uma corrente instável contra o alvo.",
	fear: "Materializa por um instante uma presença impossível.",
};

export const ordemRitualDefinitions: OrdemRitualDefinition[] = (
	["blood", "death", "knowledge", "energy", "fear"] as const
).map((element, index) => ({
	id: `32000000-0000-4000-8000-00000000000${index + 1}`,
	systemId: ordemId,
	source: official,
	createdAt,
	updatedAt: createdAt,
	name: ritualNames[element],
	description: ritualDescriptions[element],
	element,
	circle: index === 4 ? 2 : 1,
	execution: "Padrão",
	rangeText: "Curto",
	targetText: "Uma criatura",
	areaText: "",
	durationText: "Instantânea",
	resistanceText: "Fortitude reduz à metade",
	tiers: {
		normal: tier(1, "Manifesta o efeito em sua forma básica.", "3d6"),
		discente: tier(3, "Amplia a intensidade e o alcance do efeito.", "5d6"),
		verdadeiro: tier(6, "Libera a manifestação em potência máxima.", "8d6"),
	},
}));

const attackBase = {
	systemId: ordemId,
	source: official,
	createdAt,
	updatedAt: createdAt,
};

export const ordemAttackDefinitions: OrdemAttackDefinition[] = [
	{
		...attackBase,
		id: "33000000-0000-4000-8000-000000000001",
		name: "Machadada",
		description: "Um golpe direto usando o peso da lâmina.",
		skillName: "Luta",
		testExpression: "1d20+3",
		damageExpression: "1d8+3",
		damageType: "Corte",
		criticalThreshold: 20,
		criticalMultiplier: 3,
		rangeText: "Corpo a corpo",
		special: "Pode ser realizado com as duas mãos.",
		sourceItemDefinitionId: inventoryDefinitionIds.axe,
	},
	{
		...attackBase,
		id: "33000000-0000-4000-8000-000000000002",
		name: "Disparo controlado",
		description: "Um disparo preparado com uma arma curta.",
		skillName: "Pontaria",
		testExpression: "1d20+5",
		damageExpression: "2d6",
		damageType: "Balístico",
		criticalThreshold: 18,
		criticalMultiplier: 2,
		rangeText: "Curto",
		special: "Consome munição compatível.",
		sourceItemDefinitionId: inventoryDefinitionIds.pistol,
	},
];

export const characterInventoryEntries: CharacterInventoryEntry[] = [
	{
		id: "41000000-0000-4000-8000-000000000001",
		characterId: seedCharacterId,
		definitionId: inventoryDefinitionIds.axe,
		quantity: 1,
		equipped: true,
		notes: "Cabo reforçado com fita isolante.",
		createdAt,
		updatedAt: createdAt,
	},
	{
		id: "41000000-0000-4000-8000-000000000002",
		characterId: seedCharacterId,
		definitionId: inventoryDefinitionIds.backpack,
		quantity: 1,
		equipped: false,
		notes: "",
		createdAt,
		updatedAt: createdAt,
	},
	{
		id: "41000000-0000-4000-8000-000000000003",
		characterId: seedCharacterId,
		definitionId: inventoryDefinitionIds.kit,
		quantity: 1,
		equipped: false,
		notes: "",
		createdAt,
		updatedAt: createdAt,
	},
];

export const characterRitualEntries: CharacterRitualEntry[] = [
	{
		id: "42000000-0000-4000-8000-000000000001",
		characterId: seedCharacterId,
		definitionId: ordemRitualDefinitions[3]?.id ?? "",
		notes: "Aprendido durante a missão em Santa Aurora.",
		createdAt,
		updatedAt: createdAt,
	},
	{
		id: "42000000-0000-4000-8000-000000000002",
		characterId: seedCharacterId,
		definitionId: ordemRitualDefinitions[2]?.id ?? "",
		notes: "",
		createdAt,
		updatedAt: createdAt,
	},
];

export const characterAttackEntries: CharacterAttackEntry[] = [
	{
		id: "43000000-0000-4000-8000-000000000001",
		characterId: seedCharacterId,
		definitionId: ordemAttackDefinitions[0]?.id ?? "",
		sourceInventoryEntryId: characterInventoryEntries[0]?.id ?? null,
		notes: "",
		createdAt,
		updatedAt: createdAt,
	},
];

export const homebrewOwnerId = ownerId;
