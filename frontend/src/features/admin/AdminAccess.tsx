import type { ReactNode } from "react";
import { useQuery } from "@tanstack/react-query";
import { queries } from "@/shared/api/queries";
import { RpgErrorState, RpgSkeleton } from "@/components/feedback/RemoteState";

export function AdminAccess({ children }: { children: ReactNode }) {
	const user = useQuery(queries.user);
	if (user.isPending) return <RpgSkeleton />;
	if (user.isError) return <RpgErrorState error={user.error} retry={() => void user.refetch()} />;
	if (user.data.role !== "ADMIN") {
		return <section role="alert" className="rounded-3xl border border-(--edge) bg-(--surface) p-8"><p className="font-mono text-xs uppercase tracking-[0.2em] text-(--danger)">Acesso restrito</p><h1 className="mt-3 font-serif text-4xl">Área exclusiva para ADMIN</h1><p className="mt-3 text-sm text-(--muted)">Seu usuário local não possui a role necessária.</p></section>;
	}
	return children;
}
