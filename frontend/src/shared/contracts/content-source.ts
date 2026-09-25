import { z } from "zod";
import { idSchema } from "@/shared/contracts/common";

export const contentSourceSchema = z.discriminatedUnion("kind", [
	z.strictObject({ kind: z.literal("official") }),
	z.strictObject({ kind: z.literal("homebrew"), ownerId: idSchema }),
]);

export type ContentSource = z.infer<typeof contentSourceSchema>;
