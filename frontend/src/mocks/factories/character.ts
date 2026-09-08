import { createCharacterInput, createOrdemData } from '../../shared/contracts/defaults'
export function createOrdemInput(systemId: string, campaignId: string | null = null) {
  return createCharacterInput(systemId, campaignId, createOrdemData())
}
