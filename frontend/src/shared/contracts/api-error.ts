import { z } from "zod";

export const errorCodeSchema = z.enum([
	"INVALID_REQUEST",
	"USER_NOT_FOUND",
	"CAMPAIGN_NOT_FOUND",
	"CHARACTER_NOT_FOUND",
	"RPG_SYSTEM_NOT_FOUND",
	"SYSTEM_MISMATCH",
	"CONTENT_NOT_FOUND",
	"CONTENT_IN_USE",
	"CONTENT_ALREADY_ADDED",
	"CONFLICT",
	"INTERNAL_ERROR",
	"FORBIDDEN",
	"ERROR_LOG_NOT_FOUND",
]);
export const apiErrorSchema = z.object({
	error: z.object({ code: errorCodeSchema, message: z.string() }),
});
export type ErrorCode = z.infer<typeof errorCodeSchema>;
