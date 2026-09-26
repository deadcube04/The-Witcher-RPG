import { useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { MutationFeedback, RpgEmptyState, RpgErrorState, RpgSkeleton } from "@/components/feedback/RemoteState";
import { RpgButton, RpgNumber } from "@/components/primitives/RpgControls";
import { errorAdminApi } from "@/shared/api/domains";
import { keys, queries } from "@/shared/api/queries";
import type { RetentionRule } from "@/shared/contracts/application-error";

const labels: Record<RetentionRule["category"], string> = {
	http_4xx: "Respostas 4xx",
	http_500: "HTTP 500",
	http_other_5xx: "Outras respostas 5xx",
};

export function RetentionSettings() {
	const client = useQueryClient();
	const query = useQuery(queries.adminErrorRetention);
	const [draft, setDraft] = useState<RetentionRule[] | null>(null);
	const mutation = useMutation({
		mutationFn: errorAdminApi.updateRetention,
		onSuccess: async () => { setDraft(null); await client.invalidateQueries({ queryKey: keys.adminErrorRetention }); },
	});
	if (query.isPending) return <RpgSkeleton />;
	if (query.isError) return <RpgErrorState error={query.error} retry={() => void query.refetch()} />;
	if (!query.data.rules.length) return <RpgEmptyState title="Regras de retenção indisponíveis">Aplique a migration de observabilidade para configurar a exclusão automática.</RpgEmptyState>;
	const rules = draft ?? query.data.rules;
	const change = (category: RetentionRule["category"], days: number | null) => setDraft(rules.map((rule) => rule.category === category ? { ...rule, days } : rule));
	return <section className="rounded-2xl border border-(--edge)/60 bg-(--surface) p-5 md:p-7"><p className="font-mono text-[10px] uppercase tracking-[0.2em] text-(--accent)">Política para novos registros</p><h2 className="mt-2 font-serif text-3xl">Retenção automática</h2><p className="mt-2 text-sm text-(--muted)">Alterar um padrão afeta ocorrências futuras. Use a seleção em lote para mudar prazos existentes.</p><div className="mt-6 grid gap-5 md:grid-cols-3">{rules.map((rule) => <div key={rule.category} className="rounded-xl border border-(--edge)/50 p-4"><h3 className="font-semibold">{labels[rule.category]}</h3><label className="mt-4 flex items-center gap-2 text-sm"><input type="checkbox" checked={rule.days === null} disabled={rule.category === "http_4xx"} onChange={(event) => change(rule.category, event.target.checked ? null : 30)} className="size-4 accent-(--accent)" />Sem prazo</label><div className="mt-4"><RpgNumber label="Dias até exclusão" value={rule.days ?? 1} min={1} max={36500} disabled={rule.days === null} onChange={(value) => change(rule.category, value)} /></div></div>)}</div><div className="mt-6 flex flex-wrap items-center gap-4"><RpgButton loading={mutation.isPending} disabled={mutation.isPending} onClick={() => mutation.mutate(rules)}>Salvar prazos</RpgButton><MutationFeedback error={mutation.error} success={mutation.isSuccess} /></div></section>;
}
