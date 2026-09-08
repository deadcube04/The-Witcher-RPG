import type { RpgSystem } from '../../shared/contracts/rpg-system'
import { createOrdemInput } from '../factories/character'

export const ordemId = '1e9480ec-e177-4b33-90c7-ea576c87b9af'
export const dndId = 'd92e15b0-2475-4651-8082-cae231a4a6f0'
export const witcherId = 'f1a91d8e-114d-46e7-8dc0-0fd197adcba9'
export const ownerId = 'b9095a83-d2cc-4f27-bb23-4b642f2f1157'
export const seedCampaignId = 'f9f735f0-f83c-4835-aec5-4f8734f47f4d'
export const systems: RpgSystem[] = [
  { id: ordemId, slug: 'ordem-paranormal', name: 'Ordem Paranormal', description: 'Investigue o impossível. Atravesse a membrana.', status: 'available', availableThemes: ['ordem-sangue', 'ordem-morte', 'ordem-conhecimento', 'ordem-energia', 'ordem-medo'] },
  { id: dndId, slug: 'dnd', name: 'Dungeons & Dragons', description: 'Aventuras, magia e mundos por descobrir.', status: 'preview', availableThemes: [] },
  { id: witcherId, slug: 'witcher', name: 'The Witcher RPG', description: 'Monstros, escolhas e caminhos entre reinos.', status: 'preview', availableThemes: [] },
]
export function createSeed() {
  const metadata = { ownerId, createdAt: '2026-09-01T12:00:00.000Z', updatedAt: '2026-09-01T12:00:00.000Z' }
  return { version: 1 as const, user: { id: ownerId, name: 'Investigador', username: 'investigador', avatarUrl: '' },
    preferences: { activeSystemId: ordemId, activeThemeId: null, sidebarMode: 'collapsed' as const }, systems,
    campaigns: [{ ...metadata, id: seedCampaignId, systemId: ordemId, name: 'O silêncio de Santa Aurora', description: 'Uma transmissão interrompida. Uma cidade que não deveria estar vazia. O próximo capítulo está em suas mãos.', status: 'active' as const }],
    characters: [{ ...createOrdemInput(ordemId, seedCampaignId), ...metadata, id: 'e85e3e7c-ab09-479d-924a-e81575526681', name: 'Helena Vasconcelos', background: 'Um arquivo desaparecido levou Helena até Santa Aurora.' }],
  }
}
