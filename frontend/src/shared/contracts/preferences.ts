import { z } from 'zod'
import { idSchema } from './common'

export const themeIdSchema = z.enum(['ordem-sangue', 'ordem-morte', 'ordem-conhecimento', 'ordem-energia', 'ordem-medo'])
export const sidebarModeSchema = z.enum(['collapsed', 'expanded'])
export const preferencesSchema = z.strictObject({ activeSystemId: idSchema, activeThemeId: themeIdSchema.nullable(), sidebarMode: sidebarModeSchema.default('collapsed') })
export const preferencesPatchSchema = preferencesSchema.partial()
export type ThemeId = z.infer<typeof themeIdSchema>
export type SidebarMode = z.infer<typeof sidebarModeSchema>
export type UserPreferences = z.infer<typeof preferencesSchema>
