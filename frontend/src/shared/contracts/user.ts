import { z } from "zod";
import { idSchema, nameSchema } from "./common";

export const profileInputSchema = z.strictObject({
	name: nameSchema,
	username: z
		.string()
		.trim()
		.min(2)
		.max(40)
		.regex(
			/^[a-zA-Z0-9_.-]+$/,
			"Use letras, números, ponto, traço ou sublinhado.",
		),
	avatarUrl: z.union([
		z.literal(""),
		z.url().refine((url) => url.startsWith("https://"), "Use uma URL HTTPS."),
	]),
});
export const userSchema = profileInputSchema.extend({ id: idSchema });
export type User = z.infer<typeof userSchema>;
export type ProfileInput = z.infer<typeof profileInputSchema>;
