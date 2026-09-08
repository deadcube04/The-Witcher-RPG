import { test, expect, vi } from 'vitest'
import { screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { renderFeature } from '../../test/render'
import { CampaignForm } from './CampaignForm'
import { systems, ordemId } from '../../mocks/seed/seed'

test('valida nome antes de entregar uma campanha para gravação', async () => {
  const save = vi.fn(async () => undefined)
  renderFeature(<CampaignForm initial={{ name: '', description: '', systemId: ordemId, status: 'active' }} systems={systems} pending={false} error={null} onSave={save} />)
  await userEvent.click(screen.getByRole('button', { name: 'Salvar campanha' }))
  expect(save).not.toHaveBeenCalled()
  await userEvent.type(screen.getByLabelText('Nome da campanha'), 'Novo caso')
  await userEvent.click(screen.getByRole('button', { name: 'Salvar campanha' }))
  expect(save).toHaveBeenCalledWith({ name: 'Novo caso', description: '', systemId: ordemId, status: 'active' })
})
