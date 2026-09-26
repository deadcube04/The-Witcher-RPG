import { useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { RpgButton } from "@/components/primitives/RpgControls";
import { RpgConfirmDialog } from "@/components/overlay/RpgConfirmDialog";
import {
	RpgEmptyState,
	RpgErrorState,
	RpgSkeleton,
} from "@/components/feedback/RemoteState";
import { errorAdminApi } from "@/shared/api/domains";
import { queries } from "@/shared/api/queries";
import type { ErrorFilter } from "@/shared/contracts/application-error";

function json(value: unknown): string {
	return JSON.stringify(value ?? {}, null, 2);
}

export function ErrorOccurrenceList({
	filter,
	onPage,
}: {
	filter: ErrorFilter;
	onPage: (page: number) => void;
}) {
	const client = useQueryClient();
	const result = useQuery(queries.adminErrorOccurrences(filter));
	const [selected, setSelected] = useState<string[]>([]);
	const [detailID, setDetailID] = useState<string | null>(null);
	const [deleteOpen, setDeleteOpen] = useState(false);
	const [expiryMode, setExpiryMode] = useState<"none" | "date">("none");
	const [expiry, setExpiry] = useState("");
	const details = useQuery({
		...queries.adminErrorOccurrence(detailID ?? ""),
		enabled: detailID !== null,
	});
	const mutation = useMutation({
		mutationFn: async (
			action: { type: "delete" } | { type: "expiry"; value: string | null },
		) => {
			if (action.type === "delete")
				return errorAdminApi.deleteOccurrences(selected);
			return errorAdminApi.updateOccurrences(selected, action.value);
		},
		onSuccess: async () => {
			setSelected([]);
			setDetailID(null);
			setDeleteOpen(false);
			await client.invalidateQueries({ queryKey: ["admin", "errors"] });
		},
	});
	if (result.isPending) return <RpgSkeleton />;
	if (result.isError)
		return (
			<RpgErrorState error={result.error} retry={() => void result.refetch()} />
		);
	if (result.data.items.length === 0)
		return (
			<RpgEmptyState title="Nenhuma ocorrência encontrada">
				As falhas individuais aparecem aqui para consulta e manutenção.
			</RpgEmptyState>
		);
	const toggle = (id: string) =>
		setSelected((current) =>
			current.includes(id)
				? current.filter((entry) => entry !== id)
				: current.length < 100
					? [...current, id]
					: current,
		);
	const expiryValue =
		expiryMode === "none"
			? null
			: expiry
				? new Date(expiry).toISOString()
				: undefined;
	return (
		<>
			{selected.length > 0 && (
				<section className="mb-4 grid gap-4 rounded-2xl border border-(--edge)/60 bg-(--surface-raised) p-4 md:grid-cols-[1fr_auto_auto]">
					<div>
						<p className="font-semibold">
							{selected.length} ocorrência(s) selecionada(s)
						</p>
						<p className="mt-1 text-xs text-(--muted)">
							A seleção é explícita e limitada a 100 registros.
						</p>
					</div>
					<label className="flex items-center gap-2 text-sm">
						<input
							type="radio"
							name="error-expiry-mode"
							checked={expiryMode === "none"}
							onChange={() => setExpiryMode("none")}
						/>{" "}
						Sem prazo
					</label>
					<div className="flex flex-wrap items-center gap-2">
						<label className="flex items-center gap-2 text-sm">
							<input
								type="radio"
								name="error-expiry-mode"
								checked={expiryMode === "date"}
								onChange={() => setExpiryMode("date")}
							/>{" "}
							Excluir em
						</label>
						<input
							aria-label="Data de exclusão"
							type="datetime-local"
							value={expiry}
							onChange={(event) => setExpiry(event.target.value)}
							disabled={expiryMode !== "date"}
							className="min-h-10 rounded-xl border border-(--edge) bg-(--canvas) px-3 text-sm focus-visible:outline-2 focus-visible:outline-(--accent)"
						/>
						<RpgButton
							disabled={mutation.isPending || expiryValue === undefined}
							loading={mutation.isPending}
							onClick={() =>
								mutation.mutate({ type: "expiry", value: expiryValue ?? null })
							}
						>
							Atualizar prazo
						</RpgButton>
						<RpgButton
							danger
							disabled={mutation.isPending}
							onClick={() => setDeleteOpen(true)}
						>
							Excluir
						</RpgButton>
					</div>
				</section>
			)}
			{mutation.isError && (
				<p role="alert" className="mb-4 text-sm text-(--danger)">
					{mutation.error.message}
				</p>
			)}
			<section className="overflow-hidden rounded-2xl border border-(--edge)/60 bg-(--surface)">
				<div className="overflow-x-auto">
					<table className="w-full min-w-[780px] text-left text-sm">
						<thead className="border-b border-(--edge)/60 font-mono text-[10px] uppercase tracking-wider text-(--muted)">
							<tr>
								<th className="p-4">Selecionar</th>
								<th className="p-4">Resposta</th>
								<th className="p-4">Rota e request ID</th>
								<th className="p-4">Data</th>
								<th className="p-4">Exclusão</th>
							</tr>
						</thead>
						<tbody className="divide-y divide-(--edge)/50">
							{result.data.items.map((item) => (
								<tr
									key={item.id}
									className="align-top hover:bg-(--surface-raised)"
								>
									<td className="p-4">
										<input
											type="checkbox"
											aria-label={`Selecionar ocorrência ${item.requestId}`}
											checked={selected.includes(item.id)}
											disabled={
												!selected.includes(item.id) && selected.length >= 100
											}
											onChange={() => toggle(item.id)}
											className="size-4 accent-(--accent)"
										/>
									</td>
									<td className="p-4">
										<span
											className={`font-mono text-xs ${item.status >= 500 ? "text-(--danger)" : "text-(--accent)"}`}
										>
											{item.status} · {item.errorCode}
										</span>
										<p className="mt-1 text-xs text-(--muted)">
											{item.failureKind}
										</p>
									</td>
									<td className="max-w-xs p-4">
										<p className="break-all">
											{item.method} {item.route}
										</p>
										<button
											type="button"
											onClick={() =>
												setDetailID(detailID === item.id ? null : item.id)
											}
											className="mt-1 break-all font-mono text-xs text-(--accent) underline"
										>
											{item.requestId} ·{" "}
											{detailID === item.id
												? "fechar detalhes"
												: "ver detalhes"}
										</button>
									</td>
									<td className="p-4 text-xs text-(--muted)">
										{new Date(item.occurredAt).toLocaleString()}
									</td>
									<td className="p-4 text-xs text-(--muted)">
										{item.expiresAt
											? new Date(item.expiresAt).toLocaleString()
											: "Sem prazo"}
									</td>
								</tr>
							))}
						</tbody>
					</table>
				</div>
				{detailID && (
					<div className="border-t border-(--edge)/60 p-5">
						{details.isPending ? (
							<p role="status">Carregando detalhe…</p>
						) : details.isError ? (
							<p role="alert" className="text-(--danger)">
								{details.error.message}
							</p>
						) : (
							details.data && (
								<div className="grid gap-5 lg:grid-cols-2">
									<section>
										<h2 className="font-serif text-2xl">Contexto técnico</h2>
										<p className="mt-2 text-sm">
											{details.data.errorMessage ||
												"Sem mensagem técnica adicional."}
										</p>
										<pre className="mt-3 max-h-64 overflow-auto rounded-xl bg-(--canvas) p-3 text-xs">
											{details.data.panicStack || "Sem stack trace."}
										</pre>
									</section>
									<section>
										<h2 className="font-serif text-2xl">Headers saneados</h2>
										<pre className="mt-2 max-h-40 overflow-auto rounded-xl bg-(--canvas) p-3 text-xs">
											{json({
												request: details.data.requestHeaders,
												response: details.data.responseHeaders,
											})}
										</pre>
									</section>
									<section>
										<h2 className="font-serif text-2xl">Corpo da requisição</h2>
										<pre className="mt-2 max-h-64 overflow-auto rounded-xl bg-(--canvas) p-3 text-xs">
											{json(details.data.requestBody)}
										</pre>
									</section>
									<section>
										<h2 className="font-serif text-2xl">Corpo da resposta</h2>
										<pre className="mt-2 max-h-64 overflow-auto rounded-xl bg-(--canvas) p-3 text-xs">
											{json(details.data.responseBody)}
										</pre>
									</section>
								</div>
							)
						)}
					</div>
				)}
				<div className="flex items-center justify-between border-t border-(--edge)/60 p-4 text-xs text-(--muted)">
					<span>
						Página {result.data.page} · {result.data.totalItems} ocorrências
					</span>
					<div className="flex gap-2">
						<RpgButton
							secondary
							disabled={result.data.page <= 1}
							onClick={() => onPage(result.data.page - 1)}
						>
							Anterior
						</RpgButton>
						<RpgButton
							secondary
							disabled={
								result.data.page * result.data.pageSize >=
								result.data.totalItems
							}
							onClick={() => onPage(result.data.page + 1)}
						>
							Próxima
						</RpgButton>
					</div>
				</div>
			</section>
			<RpgConfirmDialog
				open={deleteOpen}
				title="Excluir ocorrências"
				description={`Esta exclusão é definitiva e removerá ${selected.length} ocorrência(s) selecionada(s).`}
				pending={mutation.isPending}
				onCancel={() => setDeleteOpen(false)}
				onConfirm={() => mutation.mutate({ type: "delete" })}
				error={mutation.isError ? mutation.error.message : null}
			/>
		</>
	);
}
