import type { CharacterInput, OrdemData } from './character-sheet'
export function createOrdemData(): OrdemData {
  return { kind: 'ordem-paranormal', nex: 5, classId: null, originId: null, creditLimit: null,
    attributes: { agility: 1, strength: 1, intellect: 1, presence: 1, vigor: 1 },
    resources: { health: { current: 0, maximum: 0, temporary: 0 }, effort: { current: 0, maximum: 0, temporary: 0 }, sanity: { current: 0, maximum: 0, temporary: 0 } } }
}
export function createCharacterInput(systemId: string, campaignId: string | null, systemData: CharacterInput['systemData']): CharacterInput {
  return { name: '', systemId, campaignId, description: '', appearance: '', personality: '', background: '', objective: '', systemData }
}
