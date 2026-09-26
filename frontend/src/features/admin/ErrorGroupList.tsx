import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { RpgButton } from "@/components/primitives/RpgControls";
import { RpgEmptyState, RpgErrorState, RpgSkeleton } from "@/components/feedback/RemoteState";
import { errorAdminApi } from "@/shared/api/domains";
import { queries } from "@/shared/api/queries";
import type { ErrorFilter } from "@/shared/contracts/application-error";

export function ErrorGroupList({ filter, onPage }: { filter: ErrorFilter; onPage: (page: number) => void }) {
	const client = useQueryClient();
	const result = useQuery(queries.adminErrorGroups(filter));
	const state = useMutation({
		mutationFn: ({ id, next }: { id: string; next: "open" | "resolved" }) => errorAdminApi.setGroupState(id, next),
		onSuccess: async () => { await client.invalidateQueries({ queryKey: ["admin", "errors"] }); },
	});
	if (result.isPending) return <RpgSkeleton />;
	if (result.isError) return <RpgErrorState error={result.error} retry={() => void result.refetch()} />;
	if (result.data.items.length === 0) return <RpgEmptyState title="Nenhum grupo encontrado">Quando uma requisição falhar, o grupo aparecerá aqui.</RpgEmptyState>;
	return <section className="overflow-hidden rounded-2xl border border-(--edge)/60 bg-(--surface)">
		<div className="overflow-x-auto"><table className="w-full min-w-[760px] text-left text-sm"><thead className="border-b border-(--edge)/60 font-mono text-[10px] uppercase tracking-wider text-(--muted)"><tr><th className="p-4">Falha</th><th className="p-4">Estado</th><th className="p-4">Ocorrências</th><th className="p-4">Última vez</th><th className="p-4">Ação</th></tr></thead><tbody className="divide-y divide-(--edge)/50">{result.data.items.map((group) => <tr key={group.id} className="align-top hover:bg-white/3"><td className="p-4"><span className={`font-mono text-xs ${group.status >= 500 ? "text-(--danger)" : "text-(--accent)"}`}>{group.status} · {group.errorCode}</span><p className="mt-1 font-medium">{group.method} <code className="break-all text-xs">{group.route}</code></p><p className="mt-1 text-xs text-(--muted)">{group.failureKind}</p></td><td className="p-4"><span className="rounded-full border border-(--edge) px-3 py-1 text-xs">{group.state === "open" ? "Aberto" : "Resolvido"}</span></td><td className="p-4"><span className="font-mono">{group.availableCount}</span><span className="text-(--muted)"> disponíveis / {group.totalOccurrences} total</span></td><td className="p-4 text-xs text-(--muted)">{new Date(group.lastOccurredAt).toLocaleString()}</td><td className="p-4"><RpgButton secondary disabled={state.isPending} onClick={() => state.mutate({ id: group.id, next: group.state === "open" ? "resolved" : "open" })}>{group.state === "open" ? "Resolver" : "Reabrir"}</RpgButton></td></tr>)}</tbody></table></div>
		<div className="flex items-center justify-between border-t border-(--edge)/60 p-4 text-xs text-(--muted)"><span>Página {result.data.page} · {result.data.totalItems} grupos</span><div className="flex gap-2"><RpgButton secondary disabled={filter.page === undefined || filter.page <= 1} onClick={() => onPage(Math.max(1, (filter.page ?? 1) - 1))}>Anterior</RpgButton><RpgButton secondary disabled={result.data.page * result.data.pageSize >= result.data.totalItems} onClick={() => onPage(result.data.page + 1)}>Próxima</RpgButton></div></div>
		{state.isError && <p role="alert" className="p-4 text-sm text-(--danger)">{state.error.message}</p>}
	</section>;
}
