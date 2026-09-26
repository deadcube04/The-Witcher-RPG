import { z } from "zod";

const errorBodySchema = z.record(z.string(), z.unknown());
const headersSchema = z.record(z.string(), z.string());
export const errorGroupSchema = z.object({
	id: z.uuid(),
	method: z.string(),
	route: z.string(),
	status: z.number().int(),
	errorCode: z.string(),
	failureKind: z.string(),
	state: z.enum(["open", "resolved"]),
	firstOccurredAt: z.iso.datetime(),
	lastOccurredAt: z.iso.datetime(),
	totalOccurrences: z.number().int(),
	availableCount: z.number().int(),
	resolvedAt: z.iso.datetime().nullable(),
});
export const errorOccurrenceSchema = z.object({
	id: z.uuid(),
	groupId: z.uuid(),
	requestId: z.string(),
	userId: z.uuid().nullable(),
	occurredAt: z.iso.datetime(),
	method: z.string(),
	route: z.string(),
	status: z.number().int(),
	errorCode: z.string(),
	failureKind: z.string(),
	errorMessage: z.string(),
	panicStack: z.string(),
	requestHeaders: headersSchema.nullable(),
	responseHeaders: headersSchema.nullable(),
	requestBody: errorBodySchema.nullable(),
	responseBody: errorBodySchema.nullable(),
	expiresAt: z.iso.datetime().nullable(),
});
export const errorPageSchema = <T extends z.ZodType>(item: T) => z.object({
	items: z.array(item),
	page: z.number().int(),
	pageSize: z.number().int(),
	totalItems: z.number().int(),
});
export const retentionRuleSchema = z.object({
	category: z.enum(["http_4xx", "http_500", "http_other_5xx"]),
	days: z.number().int().nullable(),
});
export const retentionRulesSchema = z.object({ rules: z.array(retentionRuleSchema) });
export type ErrorGroup = z.infer<typeof errorGroupSchema>;
export type ErrorOccurrence = z.infer<typeof errorOccurrenceSchema>;
export type ErrorFilter = {
	page?: number;
	status?: number;
	state?: "open" | "resolved";
	route?: string;
	requestId?: string;
	since?: string;
	until?: string;
};
export type RetentionRule = z.infer<typeof retentionRuleSchema>;
