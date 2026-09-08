import { beforeAll, afterAll, beforeEach, test, expect } from 'vitest'
import { screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { renderFeature, testServer } from '../../test/render'
import { ProfilePage } from './ProfilePage'
import { userApi } from '../../shared/api/domains'

beforeAll(() => testServer.listen({ onUnhandledRequest: 'error' }))
afterAll(() => testServer.close())
beforeEach(() => localStorage.clear())
test('edita o perfil pelo formulário e persiste após salvar', async () => {
  renderFeature(<ProfilePage />)
  const name = await screen.findByLabelText('Nome')
  await userEvent.clear(name)
  await userEvent.type(name, 'Marina')
  await userEvent.click(screen.getByRole('button', { name: 'Salvar perfil' }))
  await screen.findByText('Alterações salvas.')
  expect((await userApi.get()).name).toBe('Marina')
})
