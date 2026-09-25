import { z } from "zod";
import { idSchema, nameSchema, textSchema } from "@/shared/contracts/common";
import { contentSourceSchema } from "@/shared/contracts/content-source";

export const ritualElementSchema = z.enum([
	"blood",
	"death",
	"knowledge",
	"energy",
	"fear",
]);

export const ritualRollSchema = z.strictObject({
	label: nameSchema,
	expression: z.string().trim().min(1).max(60),
});

export const ritualTierSchema = z.strictObject({
	peCost: z.number().int().min(0).max(99),
	effect: textSchema.refine((value) => value.trim().length > 0, {
		message: "Informe o efeito.",
	}),
	rolls: z.array(ritualRollSchema).max(8),
});

export const ordemRitualInputSchema = z.strictObject({
	name: nameSchema,
	description: textSchema,
	element: ritualElementSchema,
	circle: z.number().int().min(1).max(4),
	execution: z.string().trim().max(120),
	rangeText: z.string().trim().max(120),
	targetText: z.string().trim().max(180),
	areaText: z.string().trim().max(180),
	durationText: z.string().trim().max(120),
	resistanceText: z.string().trim().max(180),
	tiers: z.strictObject({
		normal: ritualTierSchema,
		discente: ritualTierSchema,
		verdadeiro: ritualTierSchema,
	}),
});

export const ordemRitualDefinitionSchema = ordemRitualInputSchema.extend({
	tiers: ordemRitualInputSchema.shape.tiers.nullable(),
	id: idSchema,
	systemId: idSchema,
	source: contentSourceSchema,
	createdAt: z.iso.datetime().nullable(),
	updatedAt: z.iso.datetime().nullable(),
});

export const characterRitualEntrySchema = z.strictObject({
	id: idSchema,
	characterId: idSchema,
	definitionId: idSchema,
	notes: textSchema,
	createdAt: z.iso.datetime(),
	updatedAt: z.iso.datetime(),
});

export const characterRitualSchema = z.strictObject({
	entry: characterRitualEntrySchema,
	definition: ordemRitualDefinitionSchema,
});

export const ritualAddSchema = z.strictObject({ definitionId: idSchema });
export const ritualEntryPatchSchema = z.strictObject({
	definitionId: idSchema.optional(),
	notes: textSchema.optional(),
});

export type RitualElement = z.infer<typeof ritualElementSchema>;
export type RitualTier = z.infer<typeof ritualTierSchema>;
export type OrdemRitualInput = z.infer<typeof ordemRitualInputSchema>;
export type OrdemRitualDefinition = z.infer<typeof ordemRitualDefinitionSchema>;
export type CharacterRitualEntry = z.infer<typeof characterRitualEntrySchema>;
export type CharacterRitual = z.infer<typeof characterRitualSchema>;
