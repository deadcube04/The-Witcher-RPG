import { z } from 'zod'
import { entityMetadata, idSchema, nameSchema, textSchema } from './common'

export const campaignInputSchema = z.strictObject({
  systemId: idSchema, name: nameSchema, description: textSchema, status: z.enum(['active', 'archived']),
})
export const campaignSchema = campaignInputSchema.extend(entityMetadata)
export type Campaign = z.infer<typeof campaignSchema>
export type CampaignInput = z.infer<typeof campaignInputSchema>
