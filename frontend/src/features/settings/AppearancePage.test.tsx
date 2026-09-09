import { beforeAll, afterAll, beforeEach, test, expect } from 'vitest'
import { screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { renderFeature, testServer } from '../../test/render'
import { AppearancePage } from './AppearancePage'
import { preferencesApi } from '../../shared/api/domains'

beforeAll(() => testServer.listen({ onUnhandledRequest: 'error' }))
afterAll(() => testServer.close())
beforeEach(() => localStorage.clear())
test('tema escolhido permanece após remontar a tela', async () => {
  const first = renderFeature(<AppearancePage />)
  await userEvent.click(await screen.findByRole('button', { name: 'Aplicar Sangue' }))
  await screen.findByText('Alterações salvas.')
  expect((await preferencesApi.get()).activeThemeId).toBe('ordem-sangue')
  first.unmount()
  renderFeature(<AppearancePage />)
  expect(await screen.findByRole('button', { name: 'Sangue ativo' })).toBeDisabled()
})
test('tema padrão aparece na seleção e pode ser restaurado', async () => {
  renderFeature(<AppearancePage />)
  expect(await screen.findByRole('button', { name: 'Arquivo ativo' })).toBeDisabled()
  await userEvent.click(screen.getByRole('button', { name: 'Aplicar Sangue' }))
  await userEvent.click(await screen.findByRole('button', { name: 'Aplicar Arquivo' }))
  expect(await screen.findByRole('button', { name: 'Arquivo ativo' })).toBeDisabled()
  expect((await preferencesApi.get()).activeThemeId).toBeNull()
})
test('modo da sidebar permanece após salvar a preferência', async () => {
  renderFeature(<AppearancePage />)
  await userEvent.click(await screen.findByLabelText('Modo da sidebar'))
  await userEvent.click(await screen.findByRole('option', { name: 'Sempre retraída' }))
  await screen.findByText('Alterações salvas.')
  expect((await preferencesApi.get()).sidebarMode).toBe('always-collapsed')
})
