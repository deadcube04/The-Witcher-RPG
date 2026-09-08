import { afterAll, afterEach, beforeAll, beforeEach, expect, test, vi } from 'vitest'
import { createMemoryHistory, RouterProvider } from '@tanstack/react-router'
import { act, fireEvent, screen } from '@testing-library/react'
import { createAppRouter } from '../../app/router/router'
import { characterApi } from '../../shared/api/domains'
import { renderFeature, testServer } from '../../test/render'

const characterId = 'e85e3e7c-ab09-479d-924a-e81575526681'

beforeAll(() => testServer.listen({ onUnhandledRequest: 'error' }))
afterAll(() => testServer.close())
beforeEach(() => localStorage.clear())
afterEach(() => vi.useRealTimers())

test('edita a ficha localmente e atualiza o indicador após o debounce', async () => {
  const router = createAppRouter(createMemoryHistory({ initialEntries: ['/characters/' + characterId] }))
  renderFeature(<RouterProvider router={router} />)

  const name = await screen.findByLabelText('Nome do personagem')
  const strength = screen.getByLabelText('Força')
  expect(screen.queryByRole('link', { name: 'Editar ficha' })).not.toBeInTheDocument()
  expect(screen.queryByLabelText('NEX (%)')).not.toBeInTheDocument()
  expect(strength).toHaveValue(1)
  expect(screen.queryByLabelText('Vida atual')).not.toBeInTheDocument()
  expect(screen.getByRole('region', { name: 'Recursos' })).toBeInTheDocument()
  expect(screen.getAllByRole('progressbar')).toHaveLength(3)
  expect(screen.getByRole('heading', { name: 'Atributos' })).toBeInTheDocument()
  expect(screen.getByLabelText('Histórico')).toBeInTheDocument()
  expect(screen.queryByLabelText('Sistema da ficha')).not.toBeInTheDocument()
  expect(screen.queryByLabelText('Campanha')).not.toBeInTheDocument()

  vi.useFakeTimers()
  fireEvent.change(strength, { target: { value: '3' } })
  expect(strength).toHaveValue(3)
  expect(screen.getByRole('status', { name: 'Atualizando alterações locais' })).toBeInTheDocument()
  fireEvent.change(name, { target: { value: 'Helena editada' } })
  expect(screen.getByRole('status', { name: 'Atualizando alterações locais' })).toBeInTheDocument()
  act(() => vi.advanceTimersByTime(999))
  expect(screen.getByRole('status', { name: 'Atualizando alterações locais' })).toBeInTheDocument()
  act(() => vi.advanceTimersByTime(1))
  expect(screen.getByRole('status', { name: 'Alterações locais atualizadas' })).toBeInTheDocument()
  vi.useRealTimers()
  expect((await characterApi.get(characterId)).name).toBe('Helena Vasconcelos')
})
