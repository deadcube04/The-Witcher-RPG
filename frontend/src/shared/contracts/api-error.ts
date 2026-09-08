import { z } from 'zod'

export const errorCodeSchema = z.enum(['INVALID_REQUEST', 'USER_NOT_FOUND', 'CAMPAIGN_NOT_FOUND', 'CHARACTER_NOT_FOUND', 'RPG_SYSTEM_NOT_FOUND', 'SYSTEM_MISMATCH', 'CONFLICT', 'INTERNAL_ERROR'])
export const apiErrorSchema = z.object({ error: z.object({ code: errorCodeSchema, message: z.string() }) })
export type ErrorCode = z.infer<typeof errorCodeSchema>
