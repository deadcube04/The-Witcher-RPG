import { z } from "zod";
import { idSchema, nameSchema, textSchema } from "@/shared/contracts/common";
import { contentSourceSchema } from "@/shared/contracts/content-source";

export const inventoryKindSchema = z.enum([
	"weapon",
	"protection",
	"ammunition",
	"accessory",
	"equipment",
	"paranormal",
	"other",
]);

const inventoryBaseSchema = z.strictObject({
	name: nameSchema,
	description: textSchema,
	category: z.number().int().min(0).max(4).nullable(),
	spaces: z.number().int().min(0).max(99),
});

const weaponFields = {
	damageExpression: z.string().trim().min(1).max(60),
	criticalThreshold: z.number().int().min(2).max(20),
	criticalMultiplier: z.number().int().min(2).max(10),
	rangeText: z.string().trim().max(120),
	damageType: z.string().trim().max(80),
};

export const ordemInventoryInputSchema = z.discriminatedUnion("kind", [
	inventoryBaseSchema.extend({ kind: z.literal("weapon"), ...weaponFields }),
	inventoryBaseSchema.extend({ kind: z.literal("protection") }),
	inventoryBaseSchema.extend({ kind: z.literal("ammunition") }),
	inventoryBaseSchema.extend({ kind: z.literal("accessory") }),
	inventoryBaseSchema.extend({ kind: z.literal("equipment") }),
	inventoryBaseSchema.extend({ kind: z.literal("paranormal") }),
	inventoryBaseSchema.extend({ kind: z.literal("other") }),
]);

const definitionFields = {
	id: idSchema,
	systemId: idSchema,
	source: contentSourceSchema,
	createdAt: z.iso.datetime().nullable(),
	updatedAt: z.iso.datetime().nullable(),
};

const inventoryDefinitionBaseSchema = inventoryBaseSchema.extend({
	spaces: z.number().int().min(0).max(99).nullable(),
});
const weaponDefinitionFields = {
	damageExpression: z.string().nullable(),
	criticalThreshold: z.number().int().nullable(),
	criticalMultiplier: z.number().int().nullable(),
	rangeText: z.string().nullable(),
	damageType: z.string().nullable(),
};

export const ordemInventoryDefinitionSchema = z.discriminatedUnion("kind", [
	inventoryDefinitionBaseSchema.extend({
		kind: z.literal("weapon"),
		...weaponDefinitionFields,
		...definitionFields,
	}),
	inventoryDefinitionBaseSchema.extend({
		kind: z.literal("protection"),
		...definitionFields,
	}),
	inventoryDefinitionBaseSchema.extend({
		kind: z.literal("ammunition"),
		...definitionFields,
	}),
	inventoryDefinitionBaseSchema.extend({
		kind: z.literal("accessory"),
		...definitionFields,
	}),
	inventoryDefinitionBaseSchema.extend({
		kind: z.literal("equipment"),
		...definitionFields,
	}),
	inventoryDefinitionBaseSchema.extend({
		kind: z.literal("paranormal"),
		...definitionFields,
	}),
	inventoryDefinitionBaseSchema.extend({ kind: z.literal("other"), ...definitionFields }),
]);

export const characterInventoryEntrySchema = z.strictObject({
	id: idSchema,
	characterId: idSchema,
	definitionId: idSchema,
	quantity: z.number().int().min(1).max(999),
	equipped: z.boolean(),
	notes: textSchema,
	createdAt: z.iso.datetime(),
	updatedAt: z.iso.datetime(),
});

export const characterInventoryItemSchema = z.strictObject({
	entry: characterInventoryEntrySchema,
	definition: ordemInventoryDefinitionSchema,
	linkedAttackCount: z.number().int().min(0),
});

export const inventoryAddSchema = z.strictObject({
	definitionId: idSchema,
	quantity: z.number().int().min(1).max(999).default(1),
});

export const inventoryEntryPatchSchema = z.strictObject({
	definitionId: idSchema.optional(),
	quantity: z.number().int().min(1).max(999).optional(),
	equipped: z.boolean().optional(),
	notes: textSchema.optional(),
});

export type InventoryKind = z.infer<typeof inventoryKindSchema>;
export type OrdemInventoryInput = z.infer<typeof ordemInventoryInputSchema>;
export type OrdemInventoryDefinition = z.infer<
	typeof ordemInventoryDefinitionSchema
>;
export type CharacterInventoryEntry = z.infer<
	typeof characterInventoryEntrySchema
>;
export type CharacterInventoryItem = z.infer<
	typeof characterInventoryItemSchema
>;
export type InventoryEntryPatch = z.infer<typeof inventoryEntryPatchSchema>;
