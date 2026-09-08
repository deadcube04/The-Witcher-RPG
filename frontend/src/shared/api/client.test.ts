import { afterEach, expect, test, vi } from 'vitest'
import { z } from 'zod'
import { request } from './client'

afterEach(() => vi.unstubAllGlobals())
test('aceita 204 sem tentar ler JSON', async () => {
  vi.stubGlobal('fetch', async () => new Response(null, { status: 204 }))
  await expect(request('/campaigns/1', z.undefined(), { method: 'DELETE' })).resolves.toBeUndefined()
})
test('rejeita resposta externa inválida', async () => {
  vi.stubGlobal('fetch', async () => Response.json({ name: 42 }))
  await expect(request('/me', z.object({ name: z.string() }))).rejects.toThrow('Resposta inválida')
})
test('preserva código público sem expor mensagem interna', async () => {
  vi.stubGlobal('fetch', async () => Response.json({ error: { code: 'INTERNAL_ERROR', message: 'SQL secret' } }, { status: 500 }))
  await expect(request('/me', z.unknown())).rejects.toMatchObject({ code: 'INTERNAL_ERROR', message: 'Não foi possível concluir a operação.' })
})
