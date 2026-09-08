import { test, expect } from 'vitest'
import { MockRepository } from './repository'

test('salva perfil entre instâncias sem depender de estado em memória', () => {
  const data = new Map<string, string>()
  const storage = { getItem: (key: string) => data.get(key) ?? null, setItem: (key: string, value: string) => { data.set(key, value) } }
  const first = new MockRepository(storage)
  first.update((state) => ({ ...state, user: { ...state.user, name: 'Marina' } }))
  expect(new MockRepository(storage).read().user.name).toBe('Marina')
})
test('não sobrescreve dados corrompidos com seed silenciosamente', () => {
  const storage = { getItem: () => '{invalid', setItem: () => { throw new Error('Não deve escrever') } }
  expect(() => new MockRepository(storage).read()).toThrow()
})
