import { z } from "zod";
import { idSchema } from "@/shared/contracts/common";

export const themeIdSchema = z.enum([
	"nexus",
	"ordem-sangue",
	"ordem-morte",
	"ordem-conhecimento",
	"ordem-energia",
	"ordem-medo",
]);
export const sidebarModeSchema = z.enum([
	"collapsed",
	"expanded",
	"always-collapsed",
]);
export const preferencesSchema = z.strictObject({
	activeSystemId: idSchema,
	activeThemeId: themeIdSchema.nullable(),
	sidebarMode: sidebarModeSchema.default("collapsed"),
	colorMode: z.enum(["system", "light", "dark"]).default("system"),
});
export const preferencesPatchSchema = z
	.strictObject({
		activeSystemId: idSchema.optional(),
		activeThemeId: themeIdSchema.nullable().optional(),
		sidebarMode: sidebarModeSchema.optional(),
		colorMode: z.enum(["system", "light", "dark"]).optional(),
	})
	.refine((value) => Object.keys(value).length > 0);
export type ColorMode = z.infer<typeof preferencesSchema>["colorMode"];
export type PreferencesPatch = z.infer<typeof preferencesPatchSchema>;
export type ThemeId = z.infer<typeof themeIdSchema>;
export type SidebarMode = z.infer<typeof sidebarModeSchema>;
export type UserPreferences = z.infer<typeof preferencesSchema>;
