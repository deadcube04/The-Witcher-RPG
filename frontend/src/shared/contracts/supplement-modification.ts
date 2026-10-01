import { z } from "zod";
import { idSchema } from "@/shared/contracts/common";

export const supplementModificationSchema = z.strictObject({
	id: idSchema,
	name: z.string(),
	effectSummary: z.string(),
	categoryIncrease: z.number().int(),
	sourcePage: z.number().int(),
	appliesTo: z.array(z.string()),
	selected: z.boolean(),
	applicable: z.boolean(),
});
