import { z } from "zod";
import { idSchema } from "@/shared/contracts/common";

export const supplementRuleSchema = z.strictObject({
	id: idSchema,
	parentId: idSchema.nullable(),
	slug: z.string(),
	name: z.string(),
	optional: z.boolean(),
	sourcePage: z.number().int(),
	text: z.string(),
});
export const supplementSchema = z.strictObject({
	id: idSchema,
	systemId: idSchema,
	slug: z.string(),
	name: z.string(),
	categories: z.array(z.string()),
	rules: z.array(supplementRuleSchema),
	survivor: z.strictObject({
		id: idSchema,
		name: z.string(),
		initialPv: z.number().int(),
		initialPe: z.number().int(),
		initialSan: z.number().int(),
		pvPerStage: z.number().int(),
		pePerStage: z.number().int(),
		sanPerStage: z.number().int(),
		trainedSkillsRule: z.string(),
		proficiencyRule: z.string(),
		stages: z.array(z.strictObject({ stage: z.number().int(), featureName: z.string(), effectText: z.string() })),
		trails: z.array(z.strictObject({ id: idSchema, name: z.string(), abilities: z.array(z.strictObject({ stage: z.number().int(), name: z.string(), effectText: z.string() })) })),
	}).nullable(),
});
export const reviewIssueSchema = z.strictObject({
	id: idSchema,
	sourcePage: z.number().int(),
	kind: z.string(),
	sourceText: z.string(),
	handling: z.string(),
	resolved: z.boolean(),
	targetKind: z.string().nullable(),
	targetId: idSchema.nullable(),
	fieldName: z.string().nullable(),
});
export const reviewCandidateSchema = z.strictObject({ id: idSchema, kind: z.string(), name: z.string() });
export const supplementReferenceSchema = z.strictObject({ supplementId: idSchema.nullable(), rules: z.array(supplementRuleSchema), threats: z.array(z.strictObject({ id: idSchema, name: z.string(), description: z.string(), sourcePage: z.number().int() })) });
export type Supplement = z.infer<typeof supplementSchema>;
export type ReviewIssue = z.infer<typeof reviewIssueSchema>;
export type ReviewCandidate = z.infer<typeof reviewCandidateSchema>;
