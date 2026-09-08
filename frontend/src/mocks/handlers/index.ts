import { http, HttpResponse } from 'msw'
import { profileInputSchema } from '../../shared/contracts/user'
import { preferencesPatchSchema } from '../../shared/contracts/preferences'
import type { MockRepository } from '../database/repository'
import { campaignHandlers } from './campaigns'
import { characterHandlers } from './characters'
import { body, fail, safe } from './common'

export function createHandlers(repo: MockRepository) {
  return [
    http.get('*/api/v1/me', () => safe(() => HttpResponse.json(repo.read().user))),
    http.patch('*/api/v1/me', ({ request }) => safe(async () => {
      const input = await body(request, profileInputSchema.partial())
      return HttpResponse.json(repo.update((state) => ({ ...state, user: { ...state.user, ...input } })).user)
    })),
    http.get('*/api/v1/me/preferences', () => safe(() => HttpResponse.json(repo.read().preferences))),
    http.patch('*/api/v1/me/preferences', ({ request }) => safe(async () => {
      const input = await body(request, preferencesPatchSchema)
      const state = repo.read()
      const preferences = { ...state.preferences, ...input }
      const system = state.systems.find((item) => item.id === preferences.activeSystemId) ?? fail('RPG_SYSTEM_NOT_FOUND')
      if (input.activeSystemId && input.activeThemeId === undefined) preferences.activeThemeId = system.availableThemes[0] ?? null
      if (preferences.activeThemeId !== null && !system.availableThemes.includes(preferences.activeThemeId)) fail('SYSTEM_MISMATCH')
      return HttpResponse.json(repo.update((data) => ({ ...data, preferences })).preferences)
    })),
    http.get('*/api/v1/rpg-systems', () => safe(() => HttpResponse.json(repo.read().systems))),
    ...campaignHandlers(repo), ...characterHandlers(repo),
  ]
}
