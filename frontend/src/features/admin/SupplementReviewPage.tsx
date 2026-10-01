import { useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Link } from "@tanstack/react-router";
import { AdminAccess } from "@/features/admin/AdminAccess";
import { PageHeader } from "@/components/navigation/PageHeader";
import { RpgButton, RpgInput, RpgSelect } from "@/components/primitives/RpgControls";
import { RpgErrorState, RpgSkeleton } from "@/components/feedback/RemoteState";
import { supplementReviewApi } from "@/shared/api/domains";
import { keys, queries } from "@/shared/api/queries";
import type { ReviewIssue } from "@/shared/contracts/supplement";

const fields: Record<string, { value: string; label: string }[]> = {
	origin: [{ value: "name", label: "Nome" }, { value: "description", label: "Descrição" }],
	trail: [{ value: "name", label: "Nome" }, { value: "description", label: "Descrição" }],
	ability: [{ value: "name", label: "Nome" }, { value: "description", label: "Descrição" }],
	ability_detail: [{ value: "effect_text", label: "Efeito" }, { value: "prerequisite_text", label: "Pré-requisito" }],
	item: [{ value: "name", label: "Nome" }, { value: "description", label: "Descrição" }],
	item_detail: [{ value: "special_rule", label: "Regra especial" }, { value: "exact_spaces", label: "Espaços exatos" }, { value: "printed_category", label: "Categoria impressa" }],
	modification: [{ value: "name", label: "Nome" }, { value: "effect_summary", label: "Efeito" }, { value: "category_increase", label: "Aumento de categoria" }],
	ritual: [{ value: "execution", label: "Execução" }, { value: "range_text", label: "Alcance" }, { value: "target_text", label: "Alvo" }, { value: "area_text", label: "Área" }, { value: "duration_text", label: "Duração" }, { value: "resistance_text", label: "Resistência" }],
	rule: [{ value: "name", label: "Nome" }, { value: "rule_text", label: "Texto da regra" }],
	threat: [{ value: "name", label: "Nome" }, { value: "description", label: "Descrição" }],
};

export function SupplementReviewPage() {
	const supplements = useQuery(queries.supplements);
	const [selectedID, setSelectedID] = useState("");
	const [state, setState] = useState<"open" | "resolved">("open");
	const [visible, setVisible] = useState(20);
	const supplementID = selectedID || supplements.data?.[0]?.id || "";
	const issues = useQuery({ ...queries.supplementIssues(supplementID, state), enabled: !!supplementID });
	return <AdminAccess>
		<div className="space-y-8"><Link to="/admin" className="text-sm underline">← Administração</Link><PageHeader eyebrow="Administração / Suplementos" title="Revisão de conteúdo" description="Confira a fonte, ajuste o dado oficial e registre a decisão." />
			{supplements.isPending ? <RpgSkeleton /> : supplements.error ? <RpgErrorState error={supplements.error} retry={() => void supplements.refetch()} /> : <>
				<div className="grid gap-4 rounded-[2rem] bg-(--edge)/35 p-1.5 md:grid-cols-[minmax(0,1fr)_16rem]"><div className="rounded-[calc(2rem-0.375rem)] bg-(--surface) p-5 md:p-7"><RpgSelect label="Suplemento" value={supplementID} onChange={setSelectedID} options={(supplements.data ?? []).map((entry) => ({ value: entry.id, label: entry.name }))} /></div><div className="rounded-[calc(2rem-0.375rem)] bg-(--surface) p-5 md:p-7"><RpgSelect label="Estado" value={state} onChange={(value) => { if (value === "open" || value === "resolved") { setState(value); setVisible(20); } }} options={[{ value: "open", label: "Pendentes" }, { value: "resolved", label: "Resolvidas" }]} /></div></div>
				{issues.isPending ? <RpgSkeleton /> : issues.error ? <RpgErrorState error={issues.error} retry={() => void issues.refetch()} /> : <section aria-label="Pendências de revisão" className="space-y-4"><p className="font-mono text-xs text-(--muted)">{issues.data?.length ?? 0} {state === "open" ? "pendências" : "revisões concluídas"}</p>{issues.data?.length === 0 ? <p className="rounded-2xl bg-(--surface) p-8 text-sm text-(--muted)">Nenhum registro neste estado.</p> : issues.data?.slice(0, visible).map((issue) => <ReviewIssueCard key={issue.id} supplementID={supplementID} issue={issue} />)}{(issues.data?.length ?? 0) > visible && <RpgButton secondary onClick={() => setVisible(visible + 20)}>Ver mais pendências</RpgButton>}</section>}
			</>}</div>
	</AdminAccess>;
}

function ReviewIssueCard({ supplementID, issue }: { supplementID: string; issue: ReviewIssue }) {
	const client = useQueryClient();
	const [expanded, setExpanded] = useState(false);
	const [target, setTarget] = useState(issue.targetKind && issue.targetId ? `${issue.targetKind}:${issue.targetId}` : "");
	const [field, setField] = useState(issue.fieldName ?? "");
	const [newValue, setNewValue] = useState<string | null>(null);
	const [justification, setJustification] = useState("");
	const [submissionError, setSubmissionError] = useState("");
	const [kind, targetID] = target.split(":");
	const candidates = useQuery({ queryKey: ["admin", "supplements", supplementID, issue.id, "candidates"], queryFn: ({ signal }) => supplementReviewApi.candidates(supplementID, issue.id, signal), enabled: expanded && !issue.resolved });
	const source = useQuery({ queryKey: ["admin", "supplements", supplementID, issue.id, "source"], queryFn: ({ signal }) => supplementReviewApi.source(supplementID, issue.id, signal), enabled: expanded });
	const current = useQuery({ queryKey: ["admin", "supplements", supplementID, kind, targetID, field], queryFn: ({ signal }) => supplementReviewApi.currentValue(supplementID, kind, targetID, field, signal), enabled: expanded && !!kind && !!targetID && !!field });
	const proposedValue = newValue ?? current.data?.value ?? "";
	const mutation = useMutation({ mutationFn: () => supplementReviewApi.resolve(supplementID, issue.id, { targetKind: kind, targetId: targetID, fieldName: field, expectedValue: current.data?.value ?? "", newValue: proposedValue, justification }), onSuccess: async () => { await client.invalidateQueries({ queryKey: keys.supplementIssues(supplementID, "open") }); await client.invalidateQueries({ queryKey: keys.supplementIssues(supplementID, "resolved") }); await client.invalidateQueries({ queryKey: keys.supplements }); setExpanded(false); } });
	const link = useMutation({ mutationFn: () => supplementReviewApi.linkTarget(supplementID, issue.id, { targetKind: kind, targetId: targetID, fieldName: field }), onSuccess: () => client.invalidateQueries({ queryKey: keys.supplementIssues(supplementID, "open") }) });
	const targetOptions = (candidates.data ?? []).flatMap((entry) => {
		const choices = [{ value: `${entry.kind}:${entry.id}`, label: `${entry.name} · ${entry.kind}` }];
		if (entry.kind === "ability") choices.push({ value: `ability_detail:${entry.id}`, label: `${entry.name} · efeito` }, { value: `ritual:${entry.id}`, label: `${entry.name} · cabeçalho de ritual` });
		if (entry.kind === "item") choices.push({ value: `item_detail:${entry.id}`, label: `${entry.name} · detalhes` });
		return choices;
	});
	return <article className="rounded-[2rem] bg-(--edge)/35 p-1.5"><div className="space-y-5 rounded-[calc(2rem-0.375rem)] bg-(--surface) p-5 md:p-7"><div className="flex flex-wrap items-start justify-between gap-4"><div className="space-y-2"><p className="font-mono text-[10px] uppercase tracking-[0.18em] text-(--accent)">Página {issue.sourcePage} · {issue.kind.replaceAll("_", " ")}</p><h3 className="font-serif text-2xl">{issue.sourceText}</h3><p className="text-sm text-(--muted)">{issue.handling}</p></div>{!issue.resolved && <RpgButton secondary onClick={() => setExpanded(!expanded)}>{expanded ? "Fechar" : "Corrigir"}</RpgButton>}</div>
		{expanded && !issue.resolved && <div className="space-y-5 border-t border-(--edge)/60 pt-5"><details className="rounded-xl bg-(--canvas) p-4 text-sm"><summary className="cursor-pointer font-semibold text-(--accent)">Texto original da página e hash</summary>{source.isPending ? <p className="mt-3">Carregando fonte…</p> : source.error ? <p role="alert" className="mt-3 text-(--danger)">{source.error.message}</p> : <><p className="mt-3 break-all font-mono text-[10px] text-(--muted)">{source.data?.sourceFile} · SHA-256 {source.data?.sha256}</p><pre className="mt-3 max-h-72 overflow-auto whitespace-pre-wrap text-xs leading-5">{source.data?.rawText}</pre></>}</details>{candidates.isPending ? <RpgSkeleton /> : candidates.error ? <RpgErrorState error={candidates.error} retry={() => void candidates.refetch()} /> : <><RpgSelect label="Registro afetado" value={target} onChange={(value) => { setTarget(value); setField(""); setNewValue(null); }} options={[{ value: "", label: "Selecione um registro" }, ...targetOptions]} /><RpgSelect label="Campo a corrigir" value={field} onChange={(value) => { setField(value); setNewValue(null); }} options={[{ value: "", label: "Selecione um campo" }, ...(fields[kind] ?? [])]} />{field && targetID && <div className="flex flex-wrap items-center gap-3 rounded-xl bg-(--canvas) p-4"><RpgButton secondary loading={link.isPending} disabled={issue.targetKind === kind && issue.targetId === targetID && issue.fieldName === field} onClick={() => { void link.mutateAsync().catch(() => undefined); }}>{issue.targetKind === kind && issue.targetId === targetID && issue.fieldName === field ? "Registro associado" : "Associar pendência ao registro"}</RpgButton><p className="text-xs leading-5 text-(--muted)">O conteúdo associado fica oculto das novas escolhas até a correção.</p>{link.error && <p role="alert" className="text-xs text-(--danger)">{link.error.message}</p>}</div>}{current.isPending && field ? <RpgSkeleton /> : current.error ? <RpgErrorState error={current.error} retry={() => void current.refetch()} /> : field && <><div className="rounded-xl bg-(--canvas) p-4"><p className="text-xs font-semibold text-(--muted)">Valor atual</p><p className="mt-2 max-h-40 overflow-y-auto whitespace-pre-wrap text-sm">{current.data?.value || "Vazio"}</p></div><RpgInput label="Valor corrigido" multiline value={proposedValue} onChange={setNewValue} /><RpgInput label="Justificativa da correção" multiline value={justification} onChange={setJustification} />{submissionError && <p role="alert" className="text-sm text-(--danger)">{submissionError}</p>}{mutation.error && <p role="alert" className="text-sm text-(--danger)">{mutation.error.message}</p>}<RpgButton loading={mutation.isPending} disabled={!proposedValue.trim() || proposedValue === current.data?.value || justification.trim().length < 10} onClick={() => { setSubmissionError(""); if (!targetID || !field || !current.data) { setSubmissionError("Escolha registro e campo antes de salvar."); return; } void mutation.mutateAsync().catch(() => undefined); }}>Salvar correção</RpgButton></>}</>}</div>}
		</div></article>;
}
