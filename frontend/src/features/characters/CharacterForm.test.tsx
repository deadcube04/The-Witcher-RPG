import { test, expect, vi } from 'vitest'
import { screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { renderFeature } from '../../test/render'
import { CharacterForm } from './CharacterForm'
import { createSeed, systems, ordemId, dndId } from '../../mocks/seed/seed'
import { createOrdemInput } from '../../mocks/factories/character'

test('oferece apenas campanhas compatíveis e salva ficha standalone', async () => {
  const save = vi.fn(async () => undefined)
  const seed = createSeed()
  renderFeature(<CharacterForm initial={{ ...createOrdemInput(ordemId), name: 'Agente' }} systems={systems}
    campaigns={[...seed.campaigns, { ...seed.campaigns[0], id: '58303937-df5a-449b-9085-606c547b9a91', name: 'Campanha incompatível', systemId: dndId }]}
    pending={false} error={null} onSave={save} />)
  await userEvent.click(screen.getByLabelText('Campanha'))
  expect(screen.queryByRole('option', { name: 'Campanha incompatível' })).not.toBeInTheDocument()
  await userEvent.keyboard('{Escape}')
  await userEvent.click(screen.getByRole('button', { name: 'Salvar ficha' }))
  expect(save).toHaveBeenCalledWith(expect.objectContaining({ campaignId: null, systemId: ordemId, name: 'Agente' }))
})
test('salva atributos e recursos editados da ficha de Ordem', async () => {
  const save = vi.fn(async () => undefined)
  renderFeature(<CharacterForm initial={{ ...createOrdemInput(ordemId), name: 'Agente' }} systems={systems} campaigns={[]} pending={false} error={null} onSave={save} />)
  const strength = screen.getByLabelText('Força')
  await userEvent.clear(strength)
  await userEvent.type(strength, '3')
  const health = screen.getByLabelText('Vida máxima')
  await userEvent.clear(health)
  await userEvent.type(health, '20')
  await userEvent.click(screen.getByRole('button', { name: 'Salvar ficha' }))
  expect(save).toHaveBeenCalledWith(expect.objectContaining({ systemData: expect.objectContaining({ attributes: expect.objectContaining({ strength: 3 }), resources: expect.objectContaining({ health: expect.objectContaining({ maximum: 20 }) }) }) }))
})
