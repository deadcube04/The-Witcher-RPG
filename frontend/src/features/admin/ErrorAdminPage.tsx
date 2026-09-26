import { useState } from "react";
import { Link } from "@tanstack/react-router";
import { PageHeader } from "@/components/navigation/PageHeader";
import { RpgButton, RpgInput, RpgSelect } from "@/components/primitives/RpgControls";
import { AdminAccess } from "@/features/admin/AdminAccess";
import { ErrorGroupList } from "@/features/admin/ErrorGroupList";
import { ErrorOccurrenceList } from "@/features/admin/ErrorOccurrenceList";
import { RetentionSettings } from "@/features/admin/RetentionSettings";
import type { ErrorFilter } from "@/shared/contracts/application-error";

type View = "groups" | "occurrences" | "retention";
type FilterDraft = {
	status: string;
	state: "" | "open" | "resolved";
	route: string;
	requestId: string;
	since: string;
	until: string;
};
const emptyFilters: FilterDraft = { status: "", state: "", route: "", requestId: "", since: "", until: "" };

export function ErrorAdminPage() {
	const [view, setView] = useState<View>("groups");
	const [page, setPage] = useState(1);
	const [draft, setDraft] = useState<FilterDraft>(emptyFilters);
	const [activeFilter, setActiveFilter] = useState<FilterDraft>(emptyFilters);
	const filter: ErrorFilter = {
		page,
		...(activeFilter.status ? { status: Number(activeFilter.status) } : {}),
		...(activeFilter.state ? { state: activeFilter.state } : {}),
		...(activeFilter.route.trim() ? { route: activeFilter.route.trim() } : {}),
		...(activeFilter.requestId.trim() ? { requestId: activeFilter.requestId.trim() } : {}),
		...(activeFilter.since ? { since: new Date(activeFilter.since).toISOString() } : {}),
		...(activeFilter.until ? { until: new Date(activeFilter.until).toISOString() } : {}),
	};
	const change = <K extends keyof FilterDraft>(key: K, value: FilterDraft[K]) => setDraft((current) => ({ ...current, [key]: value }));
	const applyFilters = () => { setActiveFilter(draft); setPage(1); };
	const clearFilters = () => { setDraft(emptyFilters); setActiveFilter(emptyFilters); setPage(1); };
	return <AdminAccess>
		<PageHeader eyebrow="Administração / Observabilidade" title="Erros da aplicação" description="Investigue falhas, acompanhe reincidências e controle a retenção dos registros." />
		<p className="mb-6 text-sm text-(--muted)"><Link to="/admin" className="underline">Administração</Link> / Erros</p>
		<div className="mb-6 flex flex-wrap gap-2" role="group" aria-label="Conteúdo de erros">{([ ["groups", "Grupos"], ["occurrences", "Ocorrências"], ["retention", "Retenção"] ] as const).map(([key, label]) => <RpgButton key={key} secondary={view !== key} onClick={() => { setView(key); setPage(1); }}>{label}</RpgButton>)}</div>
		{view !== "retention" && <form onSubmit={(event) => { event.preventDefault(); applyFilters(); }} className="mb-5 grid gap-4 rounded-2xl border border-(--edge)/60 bg-(--surface) p-4 sm:grid-cols-2 xl:grid-cols-3">
			<label className="space-y-2 text-sm"><span className="block font-semibold">Status HTTP</span><input type="number" min={400} max={599} value={draft.status} onChange={(event) => change("status", event.target.value)} placeholder="Todos" className="min-h-11 w-full rounded-xl border border-(--edge) bg-(--canvas) px-3 focus-visible:outline-2 focus-visible:outline-(--accent)" /></label>
			<RpgSelect label="Estado do grupo" value={draft.state} onChange={(value) => change("state", value === "open" || value === "resolved" ? value : "")} options={[{ value: "", label: "Todos" }, { value: "open", label: "Aberto" }, { value: "resolved", label: "Resolvido" }]} />
			<RpgInput label="Rota" value={draft.route} onChange={(value) => change("route", value)} />
			<RpgInput label="Request ID" value={draft.requestId} onChange={(value) => change("requestId", value)} />
			<label className="space-y-2 text-sm"><span className="block font-semibold">Desde</span><input aria-label="Desde" type="datetime-local" value={draft.since} onChange={(event) => change("since", event.target.value)} className="min-h-11 w-full rounded-xl border border-(--edge) bg-(--canvas) px-3 text-sm focus-visible:outline-2 focus-visible:outline-(--accent)" /></label>
			<label className="space-y-2 text-sm"><span className="block font-semibold">Até</span><input aria-label="Até" type="datetime-local" value={draft.until} onChange={(event) => change("until", event.target.value)} className="min-h-11 w-full rounded-xl border border-(--edge) bg-(--canvas) px-3 text-sm focus-visible:outline-2 focus-visible:outline-(--accent)" /></label>
			<div className="flex gap-3 sm:col-span-2 xl:col-span-3"><RpgButton submit>Aplicar filtros</RpgButton><RpgButton secondary onClick={clearFilters}>Limpar</RpgButton></div>
		</form>}
		{view === "groups" && <ErrorGroupList filter={filter} onPage={setPage} />}
		{view === "occurrences" && <ErrorOccurrenceList filter={filter} onPage={setPage} />}
		{view === "retention" && <RetentionSettings />}
	</AdminAccess>;
}
