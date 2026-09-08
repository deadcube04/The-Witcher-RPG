import { http, HttpResponse } from 'msw'
import { campaignInputSchema } from '../../shared/contracts/campaign'
import type { MockRepository, MockDatabase } from '../database/repository'
import { body, fail, safe } from './common'

function owned(state: MockDatabase, id: string | readonly string[] | undefined) {
  return state.campaigns.find((item) => item.id === id && item.ownerId === state.user.id) ?? fail('CAMPAIGN_NOT_FOUND')
}
export function campaignHandlers(repo: MockRepository) {
  return [
    http.get('*/api/v1/campaigns', () => safe(() => HttpResponse.json(repo.read().campaigns.filter((item) => item.ownerId === repo.read().user.id)))),
    http.get('*/api/v1/campaigns/:id', ({ params }) => safe(() => HttpResponse.json(owned(repo.read(), params.id)))),
    http.post('*/api/v1/campaigns', ({ request }) => safe(async () => {
      const input = await body(request, campaignInputSchema)
      const state = repo.read()
      if (!state.systems.some((system) => system.id === input.systemId)) fail('RPG_SYSTEM_NOT_FOUND')
      const now = new Date().toISOString()
      const campaign = { ...input, id: crypto.randomUUID(), ownerId: state.user.id, createdAt: now, updatedAt: now }
      repo.update((data) => ({ ...data, campaigns: [...data.campaigns, campaign] }))
      return HttpResponse.json(campaign, { status: 201 })
    })),
    http.patch('*/api/v1/campaigns/:id', ({ request, params }) => safe(async () => {
      const input = await body(request, campaignInputSchema.partial())
      const state = repo.read()
      const existing = owned(state, params.id)
      const campaign = { ...existing, ...input, updatedAt: new Date().toISOString() }
      if (!state.systems.some((system) => system.id === campaign.systemId)) fail('RPG_SYSTEM_NOT_FOUND')
      if (state.characters.some((sheet) => sheet.campaignId === campaign.id && sheet.systemId !== campaign.systemId)) fail('SYSTEM_MISMATCH')
      repo.update((data) => ({ ...data, campaigns: data.campaigns.map((item) => item.id === campaign.id ? campaign : item) }))
      return HttpResponse.json(campaign)
    })),
    http.delete('*/api/v1/campaigns/:id', ({ params }) => safe(() => {
      const campaign = owned(repo.read(), params.id)
      repo.update((data) => ({ ...data, campaigns: data.campaigns.filter((item) => item.id !== campaign.id),
        characters: data.characters.map((sheet) => sheet.campaignId === campaign.id ? { ...sheet, campaignId: null, updatedAt: new Date().toISOString() } : sheet) }))
      return new HttpResponse(null, { status: 204 })
    })),
  ]
}
