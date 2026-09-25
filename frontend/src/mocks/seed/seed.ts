import type { RpgSystem } from "@/shared/contracts/rpg-system";
import { createOrdemInput } from "@/mocks/factories/character";
import {
	dndId,
	ordemId,
	ownerId,
	seedCampaignId,
	seedCharacterId,
	witcherId,
} from "@/mocks/seed/identifiers";
import {
	characterAttackEntries,
	characterInventoryEntries,
	characterRitualEntries,
	ordemAttackDefinitions,
	ordemInventoryDefinitions,
	ordemRitualDefinitions,
} from "@/mocks/seed/ordem-content";

export {
	dndId,
	ordemId,
	ownerId,
	seedCampaignId,
	seedCharacterId,
	witcherId,
} from "@/mocks/seed/identifiers";
export const systems: RpgSystem[] = [
	{
		id: ordemId,
		slug: "ordem-paranormal",
		name: "Ordem Paranormal",
		description: "Investigue o impossível. Atravesse a membrana.",
		status: "available",
		availableThemes: [
			"ordem-sangue",
			"ordem-morte",
			"ordem-conhecimento",
			"ordem-energia",
			"ordem-medo",
		],
	},
	{
		id: dndId,
		slug: "dnd",
		name: "Dungeons & Dragons",
		description: "Aventuras, magia e mundos por descobrir.",
		status: "preview",
		availableThemes: [],
	},
	{
		id: witcherId,
		slug: "witcher",
		name: "The Witcher RPG",
		description: "Monstros, escolhas e caminhos entre reinos.",
		status: "preview",
		availableThemes: [],
	},
];
export function createSeed() {
	const metadata = {
		ownerId,
		createdAt: "2026-09-01T12:00:00.000Z",
		updatedAt: "2026-09-01T12:00:00.000Z",
	};
	return {
		version: 2 as const,
		user: {
			id: ownerId,
			name: "Investigador",
			username: "investigador",
			avatarUrl: "",
		},
		preferences: {
			activeSystemId: ordemId,
			activeThemeId: null,
			sidebarMode: "collapsed" as const,
		},
		systems,
		campaigns: [
			{
				...metadata,
				id: seedCampaignId,
				systemId: ordemId,
				name: "O silêncio de Santa Aurora",
				description:
					"Uma transmissão interrompida. Uma cidade que não deveria estar vazia. O próximo capítulo está em suas mãos.",
				status: "active" as const,
			},
		],
		characters: [
			{
				...createOrdemInput(ordemId, seedCampaignId),
				...metadata,
				id: seedCharacterId,
				name: "Helena Vasconcelos",
				background: "Um arquivo desaparecido levou Helena até Santa Aurora.",
			},
		],
		inventoryDefinitions: ordemInventoryDefinitions,
		ritualDefinitions: ordemRitualDefinitions,
		attackDefinitions: ordemAttackDefinitions,
		characterInventoryEntries,
		characterRitualEntries,
		characterAttackEntries,
	};
}
