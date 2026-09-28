import { z } from "zod";

// PostgreSQL accepts any 128-bit UUID layout; imported threat IDs do not all
// use the RFC variant/version bits enforced by z.uuid(). Match the backend's
// UUID shape validation for records owned by the bestiary catalog.
export const bestiaryIdSchema = z.string().regex(
	/^[0-9a-f]{8}-(?:[0-9a-f]{4}-){3}[0-9a-f]{12}$/i,
);

export const bestiaryOptionSchema = z.strictObject({ id: z.string(), name: z.string() });
export const bestiaryElementSchema = z.strictObject({
	id: bestiaryIdSchema,
	name: z.string(),
	isPrimary: z.boolean(),
});
export const bestiarySummarySchema = z.strictObject({
	id: bestiaryIdSchema,
	name: z.string(),
	description: z.string().nullable(),
	imageUrl: z.string().nullable(),
	beingTypeId: bestiaryIdSchema.nullable(),
	beingType: z.string().nullable(),
	challengeValue: z.number().int().nullable(),
	sizeId: bestiaryIdSchema.nullable(),
	size: z.string().nullable(),
	elements: z.array(bestiaryElementSchema),
});
export const bestiaryOptionsSchema = z.strictObject({
	elements: z.array(bestiaryOptionSchema),
	types: z.array(bestiaryOptionSchema),
	sizes: z.array(bestiaryOptionSchema),
	minVD: z.number().int(),
	maxVD: z.number().int(),
});
export const bestiaryPageSchema = z.strictObject({
	items: z.array(bestiarySummarySchema),
	total: z.number().int().nonnegative(),
	page: z.number().int().positive(),
	pageSize: z.number().int().positive(),
	nextPage: z.number().int().positive().nullable(),
});
export const bestiaryStatsSchema = z.strictObject({
	defense: z.number().int().nullable(),
	hitPoints: z.number().int().nullable(),
	woundedAt: z.number().int().nullable(),
	agility: z.number().int().nullable(),
	strength: z.number().int().nullable(),
	intellect: z.number().int().nullable(),
	presence: z.number().int().nullable(),
	vigor: z.number().int().nullable(),
});
export const bestiaryTestsSchema = z.strictObject({
	perception: z.string().nullable(),
	initiative: z.string().nullable(),
	fortitude: z.string().nullable(),
	reflexes: z.string().nullable(),
	will: z.string().nullable(),
});
export const bestiaryActionSchema = z.strictObject({
	id: bestiaryIdSchema,
	name: z.string(),
	type: z.string().nullable(),
	description: z.string().nullable(),
	testExpression: z.string().nullable(),
	damageExpression: z.string().nullable(),
	attackCount: z.number().int().nullable(),
	range: z.string().nullable(),
	critical: z.string().nullable(),
	damageType: z.string().nullable(),
	resistance: z.string().nullable(),
	sourceRef: z.string().nullable(),
});
export const bestiaryAbilitySchema = z.strictObject({
	id: bestiaryIdSchema,
	name: z.string(),
	effectSummary: z.string().nullable(),
	sourceRef: z.string().nullable(),
});
export const bestiaryDefenseTraitSchema = z.strictObject({
	id: bestiaryIdSchema,
	type: z.string(),
	name: z.string(),
	valueText: z.string().nullable(),
	sourceRef: z.string().nullable(),
});
export const bestiarySkillSchema = z.strictObject({
	id: bestiaryIdSchema,
	name: z.string(),
	testExpression: z.string(),
	sourceRef: z.string().nullable(),
});
export const bestiaryThreatSchema = bestiarySummarySchema.extend({
	beingTypeDescription: z.string().nullable(),
	sourceRef: z.string().nullable(),
	stats: bestiaryStatsSchema,
	tests: bestiaryTestsSchema,
	senses: z.string().nullable(),
	movement: z.string().nullable(),
	disturbingPresence: z.string().nullable(),
	presence: z.strictObject({
		difficulty: z.number().int().nullable(),
		damage: z.string().nullable(),
		immuneNex: z.number().int().nullable(),
	}),
	fearEnigmaSummary: z.string().nullable(),
	group: z.string().nullable(),
	resistancesText: z.string().nullable(),
	immunitiesText: z.string().nullable(),
	vulnerabilitiesText: z.string().nullable(),
	descriptors: z.array(z.string()),
	actions: z.array(bestiaryActionSchema),
	abilities: z.array(bestiaryAbilitySchema),
	defenseTraits: z.array(bestiaryDefenseTraitSchema),
	skills: z.array(bestiarySkillSchema),
});
export const bestiaryNavigationItemSchema = z.strictObject({ id: bestiaryIdSchema, name: z.string() });
export const bestiaryDetailSchema = z.strictObject({
	creature: bestiaryThreatSchema,
	navigation: z.strictObject({
		previous: bestiaryNavigationItemSchema.nullable(),
		next: bestiaryNavigationItemSchema.nullable(),
		position: z.number().int().positive().nullable(),
		total: z.number().int().nonnegative(),
	}),
});

export type BestiaryOptions = z.infer<typeof bestiaryOptionsSchema>;
export type BestiaryElement = z.infer<typeof bestiaryElementSchema>;
export type BestiarySummary = z.infer<typeof bestiarySummarySchema>;
export type BestiaryFilters = {
	q?: string;
	elementId?: string;
	beingTypeId?: string;
	sizeId?: string;
	vdMin?: string;
	vdMax?: string;
	sort?: "name" | "vd-asc" | "vd-desc" | "relevance";
};
export type BestiaryThreat = z.infer<typeof bestiaryThreatSchema>;
export type BestiaryDetail = z.infer<typeof bestiaryDetailSchema>;

