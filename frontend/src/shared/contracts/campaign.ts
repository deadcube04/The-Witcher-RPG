import { z } from "zod";
import { entityMetadata, idSchema, nameSchema, textSchema } from "@/shared/contracts/common";
import { imageUrlSchema } from "@/shared/contracts/media";

const selectionSchema = z.strictObject({
	mode: z.enum(["all", "selected"]),
	allowedIds: z.array(idSchema),
}).refine((value) => value.mode !== "all" || value.allowedIds.length === 0);

export const ordemCampaignSettingsSchema = z.strictObject({
	kind: z.literal("ordem-paranormal"),
	classes: selectionSchema,
	origins: selectionSchema,
});

export const campaignInputSchema = z.strictObject({
	systemId: idSchema,
	name: nameSchema,
	description: textSchema,
	coverImageUrl: imageUrlSchema,
	sheetMode: z.enum(["guided", "free"]),
	settings: ordemCampaignSettingsSchema,
});

export const campaignSchema = campaignInputSchema.extend({
	...entityMetadata,
	status: z.enum(["active", "archived"]),
});

export type Campaign = z.infer<typeof campaignSchema>;
export type CampaignInput = z.infer<typeof campaignInputSchema>;
export type CampaignSelection = z.infer<typeof selectionSchema>;
