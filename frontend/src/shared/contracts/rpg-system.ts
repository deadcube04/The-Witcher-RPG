import { z } from "zod";
import { idSchema } from "./common";
import { themeIdSchema } from "./preferences";

export const systemSchema = z.strictObject({
	id: idSchema,
	slug: z.enum(["ordem-paranormal", "dnd", "witcher"]),
	name: z.string(),
	description: z.string(),
	status: z.enum(["available", "preview"]),
	availableThemes: z.array(themeIdSchema),
});
export type RpgSystem = z.infer<typeof systemSchema>;
