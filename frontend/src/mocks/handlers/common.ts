import { HttpResponse } from 'msw'
import { type ZodType } from 'zod'
import { ApiError } from '../../shared/api/client'
import type { ErrorCode } from '../../shared/contracts/api-error'

export function fail(code: ErrorCode): never { throw new ApiError(code) }
export async function body<T>(request: Request, schema: ZodType<T>): Promise<T> {
  const raw: unknown = await request.json().catch(() => fail('INVALID_REQUEST'))
  const result = schema.safeParse(raw)
  if (!result.success) return fail('INVALID_REQUEST')
  return result.data
}
export async function safe(action: () => Response | Promise<Response>): Promise<Response> {
  try { return await action() } catch (error: unknown) {
    const code = error instanceof ApiError ? error.code : 'INTERNAL_ERROR'
    const status = code.endsWith('NOT_FOUND') ? 404 : code === 'INTERNAL_ERROR' ? 500 : code === 'CONFLICT' ? 409 : 400
    return HttpResponse.json({ error: { code, message: new ApiError(code).message } }, { status })
  }
}
