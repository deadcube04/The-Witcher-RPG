import { z } from "zod";
import { idSchema } from "@/shared/contracts/common";

export const supplementPowerSchema = z.strictObject({
	id: idSchema,
	name: z.string(),
	abilityType: z.string(),
	effectText: z.string(),
	prerequisiteText: z.string().nullable(),
	affinityEffect: z.string().nullable(),
	sourcePage: z.number().int(),
	requiredProgression: z.number().nullable(),
	selected: z.boolean(),
});
export type SupplementPower = z.infer<typeof supplementPowerSchema>;
