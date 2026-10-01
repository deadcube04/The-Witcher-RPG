import { z } from "zod";
import { idSchema } from "@/shared/contracts/common";

const optionSchema = z.strictObject({ id: idSchema, slug: z.string(), name: z.string(), supplementId: idSchema.nullable() });
export const characterOptionsSchema = z.strictObject({
	classes: z.array(optionSchema),
	origins: z.array(optionSchema),
	trails: z.array(z.strictObject({ id: idSchema, name: z.string(), classId: idSchema, supplementId: idSchema.nullable() })),
	attributes: z.array(optionSchema),
	resources: z.array(optionSchema),
	skills: z.array(optionSchema),
	nex: z.array(z.strictObject({ value: z.number().int(), peLimit: z.number().int() })),
	trainingLevels: z.array(z.strictObject({ id: idSchema, name: z.string(), bonus: z.number().int() })),
});
export type CharacterOptions = z.infer<typeof characterOptionsSchema>;
