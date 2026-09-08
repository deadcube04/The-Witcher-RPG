import { beforeAll, afterAll, beforeEach, test, expect } from 'vitest'
import { setupServer } from 'msw/node'
import { createHandlers } from './index'
import { MockRepository } from '../database/repository'
import { campaignApi, characterApi, preferencesApi, userApi } from '../../shared/api/domains'
import { createOrdemInput } from '../factories/character'
import { ordemId, dndId } from '../seed/seed'

const server = setupServer(...createHandlers(new MockRepository(localStorage)))
beforeAll(() => server.listen({ onUnhandledRequest: 'error' }))
afterAll(() => server.close())
beforeEach(() => localStorage.clear())
test('CRUD de campanha preserva fichas como standalone ao excluir', async () => {
  const campaign = await campaignApi.create({ name: 'Caso novo', systemId: ordemId, description: '', status: 'active' })
  const sheet = await characterApi.create({ ...createOrdemInput(ordemId, campaign.id), name: 'Agente' })
  await campaignApi.update(campaign.id, { name: 'Caso revisado' })
  expect((await campaignApi.get(campaign.id)).name).toBe('Caso revisado')
  await campaignApi.remove(campaign.id)
  expect((await characterApi.get(sheet.id)).campaignId).toBeNull()
  await expect(campaignApi.get(campaign.id)).rejects.toMatchObject({ code: 'CAMPAIGN_NOT_FOUND' })
})
test('bloqueia campanha e ficha de sistemas incompatíveis', async () => {
  const campaign = await campaignApi.create({ name: 'Caso', systemId: dndId, description: '', status: 'active' })
  await expect(characterApi.create({ ...createOrdemInput(ordemId, campaign.id), name: 'Agente' })).rejects.toMatchObject({ code: 'SYSTEM_MISMATCH' })
})
test('persiste perfil e tema e mantém entidades ao mudar sistema', async () => {
  await userApi.update({ name: 'Marina', username: 'marina', avatarUrl: '' })
  await preferencesApi.update({ activeThemeId: 'ordem-sangue' })
  expect((await userApi.get()).name).toBe('Marina')
  expect((await preferencesApi.get()).activeThemeId).toBe('ordem-sangue')
  await preferencesApi.update({ activeSystemId: dndId })
  expect((await preferencesApi.get()).activeThemeId).toBeNull()
  expect((await campaignApi.list())[0]?.systemId).toBe(ordemId)
})
test('CRUD de ficha standalone persiste todos os dados', async () => {
  const sheet = await characterApi.create({ ...createOrdemInput(ordemId), name: 'Clara' })
  await characterApi.update(sheet.id, { background: 'Arquivo recuperado' })
  expect(await characterApi.get(sheet.id)).toMatchObject({ campaignId: null, background: 'Arquivo recuperado' })
  await characterApi.remove(sheet.id)
  await expect(characterApi.get(sheet.id)).rejects.toMatchObject({ code: 'CHARACTER_NOT_FOUND' })
})
