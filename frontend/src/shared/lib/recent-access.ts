import { z } from "zod";

const recentSchema = z.object({
	kind: z.enum(["campaigns", "characters"]),
	id: z.uuid(),
	name: z.string(),
});
export type RecentAccess = z.infer<typeof recentSchema>;
export function rememberAccess(access: RecentAccess): void {
	try {
		localStorage.setItem("rpg-manager:recent", JSON.stringify(access));
	} catch {
		/* Retomada é opcional, sem bloquear o conteúdo. */
	}
}
export function readRecentAccess(): RecentAccess | null {
	try {
		const raw: unknown = JSON.parse(
			localStorage.getItem("rpg-manager:recent") ?? "null",
		);
		const parsed = recentSchema.safeParse(raw);
		return parsed.success ? parsed.data : null;
	} catch {
		return null;
	}
}
