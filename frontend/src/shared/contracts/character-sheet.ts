import { imageUrlSchema } from "@/shared/contracts/media";
import { z } from "zod";
import { entityMetadata, idSchema, nameSchema, textSchema } from "@/shared/contracts/common";

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
	progressionMode: z.enum(["nex", "level-nex", "patent", "survivor"]),
	level: z.number().int().min(1).max(20).nullable(),
	patent: z.enum(["recruta", "operador", "agente-especial", "oficial-de-operacoes", "agente-de-elite"]).nullable(),
	survivorClassId: idSchema.nullable(),
	survivorStage: z.number().int().min(1).max(5).nullable(),
	survivorTrailId: idSchema.nullable(),
	trailId: idSchema.nullable(),
	classId: idSchema.or(z.literal("")).nullable(),
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
		determination: resource.nullable(),
	}),
});
const systemDataSchema = z.discriminatedUnion("kind", [
	ordemDataSchema,
	z.strictObject({ kind: z.literal("dungeons-and-dragons") }),
	z.strictObject({ kind: z.literal("witcher") }),
]);
export const characterInputSchema = z.strictObject({
	name: nameSchema,
	imageUrl: imageUrlSchema,
	systemId: idSchema,
	campaignId: idSchema.nullable(),
	supplementId: idSchema.nullable(),
	supplementRuleIds: z.array(idSchema),
	description: textSchema,
	appearance: textSchema,
	personality: textSchema,
	background: textSchema,
	objective: textSchema,
	systemData: systemDataSchema,
});
export const characterSchema = characterInputSchema.extend({ ...entityMetadata, imageUrl: imageUrlSchema.default("") });
export type OrdemData = z.infer<typeof ordemDataSchema>;
export type CharacterSheet = z.infer<typeof characterSchema>;
export type CharacterInput = z.infer<typeof characterInputSchema>;
