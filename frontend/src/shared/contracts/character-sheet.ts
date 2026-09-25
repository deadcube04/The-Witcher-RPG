import { z } from "zod";
import { entityMetadata, idSchema, nameSchema, textSchema } from "./common";

const attribute = z.number().int().min(0).max(5);
const resource = z.strictObject({
	current: z.number().int(),
	maximum: z.number().int().min(0),
	temporary: z.number().int().min(0),
	baseMaximum: z.number().int().min(0),
	maxAdjustment: z.number().int(),
});
export const ordemDataSchema = z.strictObject({
	kind: z.literal("ordem-paranormal"),
	nex: z.number().int().min(0).max(99),
	classId: idSchema.nullable(),
	originId: idSchema.nullable(),
	peLimit: z.number().int().min(0),
	creditLimit: z.enum(["BAIXO", "MEDIO", "ALTO", "ILIMITADO"]).nullable(),
	attributes: z.strictObject({
		agility: attribute,
		strength: attribute,
		intellect: attribute,
		presence: attribute,
		vigor: attribute,
	}),
	resources: z.strictObject({
		health: resource,
		effort: resource,
		sanity: resource,
	}),
});
const systemDataSchema = z.discriminatedUnion("kind", [
	ordemDataSchema,
	z.strictObject({ kind: z.literal("dungeons-and-dragons") }),
	z.strictObject({ kind: z.literal("witcher") }),
]);
export const characterInputSchema = z.strictObject({
	name: nameSchema,
	systemId: idSchema,
	campaignId: idSchema.nullable(),
	description: textSchema,
	appearance: textSchema,
	personality: textSchema,
	background: textSchema,
	objective: textSchema,
	systemData: systemDataSchema,
});
export const characterSchema = characterInputSchema.extend(entityMetadata);
export type OrdemData = z.infer<typeof ordemDataSchema>;
export type CharacterSheet = z.infer<typeof characterSchema>;
export type CharacterInput = z.infer<typeof characterInputSchema>;
