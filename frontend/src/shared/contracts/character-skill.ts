import { z } from "zod";
import { idSchema } from "@/shared/contracts/common";

export const characterSkillSchema = z.strictObject({
	id: idSchema,
	name: z.string(),
	slug: z.string(),
	attributeId: idSchema,
	attributeSlug: z.string(),
	trainingLevelId: idSchema.nullable(),
	trainingName: z.string(),
	trainingBonus: z.number().int(),
	otherBonus: z.number().int(),
	bonus: z.number().int(),
	diceCount: z.number().int().min(1),
	keep: z.enum(["highest", "lowest"]),
});
export const characterSkillUpdateSchema = characterSkillSchema.pick({
	id: true,
	attributeId: true,
	trainingLevelId: true,
	otherBonus: true,
});
export type CharacterSkill = z.infer<typeof characterSkillSchema>;
export type CharacterSkillUpdate = z.infer<typeof characterSkillUpdateSchema>;
