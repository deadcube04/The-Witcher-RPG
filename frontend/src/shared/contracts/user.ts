import { imageUrlSchema } from "@/shared/contracts/media";
import { z } from "zod";
import { idSchema, nameSchema } from "@/shared/contracts/common";

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
	avatarUrl: imageUrlSchema,
});
export const userSchema = profileInputSchema.extend({
	id: idSchema,
	role: z.enum(["USER", "ADMIN"]).default("USER"),
});
export type User = z.infer<typeof userSchema>;
export type ProfileInput = z.infer<typeof profileInputSchema>;
