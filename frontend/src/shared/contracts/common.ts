import { z } from 'zod'

export const idSchema = z.uuid()
export const nameSchema = z.string().trim().min(1, 'Informe um nome.').max(160)
export const textSchema = z.string().max(10000)
export const entityMetadata = { id: idSchema, ownerId: idSchema, createdAt: z.iso.datetime(), updatedAt: z.iso.datetime() }
