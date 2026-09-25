import { z } from "zod";
import { idSchema, nameSchema, textSchema } from "@/shared/contracts/common";
import { contentSourceSchema } from "@/shared/contracts/content-source";

export const ordemAttackInputSchema = z.strictObject({
	name: nameSchema,
	description: textSchema,
	skillId: idSchema.nullable().optional(),
	skillName: z.string().trim().min(1).max(120),
	testExpression: z.string().trim().min(1).max(60),
	damageExpression: z.string().trim().min(1).max(60),
	damageType: z.string().trim().max(80),
	criticalThreshold: z.number().int().min(2).max(20),
	criticalMultiplier: z.number().int().min(2).max(10),
	rangeText: z.string().trim().max(120),
	special: textSchema,
	sourceItemDefinitionId: idSchema.nullable(),
});

export const ordemAttackDefinitionSchema = ordemAttackInputSchema.extend({
	skillId: idSchema.nullable().optional(),
	testExpression: z.string().nullable(),
	criticalThreshold: z.number().int().nullable(),
	criticalMultiplier: z.number().int().nullable(),
	id: idSchema,
	systemId: idSchema,
	source: contentSourceSchema,
	createdAt: z.iso.datetime().nullable(),
	updatedAt: z.iso.datetime().nullable(),
});

export const characterAttackEntrySchema = z.strictObject({
	id: idSchema,
	characterId: idSchema,
	definitionId: idSchema,
	sourceInventoryEntryId: idSchema.nullable(),
	notes: textSchema,
	createdAt: z.iso.datetime(),
	updatedAt: z.iso.datetime(),
});

export const characterAttackSchema = z.strictObject({
	entry: characterAttackEntrySchema,
	definition: ordemAttackDefinitionSchema,
	sourceInventory: z
		.strictObject({ entryId: idSchema, name: nameSchema })
		.nullable(),
	test: z.strictObject({ diceCount: z.number().int().min(1), keep: z.enum(["highest", "lowest"]), bonus: z.number().int() }).nullable().optional(),
});

export const attackAddSchema = z.strictObject({
	definitionId: idSchema,
	sourceInventoryEntryId: idSchema.nullable().default(null),
});
export const attackEntryPatchSchema = z.strictObject({
	definitionId: idSchema.optional(),
	sourceInventoryEntryId: idSchema.nullable().optional(),
	notes: textSchema.optional(),
});

export type OrdemAttackInput = z.infer<typeof ordemAttackInputSchema>;
export type OrdemAttackDefinition = z.infer<typeof ordemAttackDefinitionSchema>;
export type CharacterAttackEntry = z.infer<typeof characterAttackEntrySchema>;
export type CharacterAttack = z.infer<typeof characterAttackSchema>;
