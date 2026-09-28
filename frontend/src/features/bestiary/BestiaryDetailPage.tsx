import { useEffect } from "react";
import { useQuery } from "@tanstack/react-query";
import { Link, useParams, useSearch } from "@tanstack/react-router";
import { useBestiaryTheme } from "@/app/layout/BestiaryThemeContext";
import { BestiaryDetailCover } from "@/features/bestiary/BestiaryDetailCover";
import { BestiaryDetailSections } from "@/features/bestiary/BestiaryDetailSections";
import { BestiarySystemGate } from "@/features/bestiary/BestiarySystemGate";
import {
	BestiaryError,
	BestiaryLoading,
} from "@/features/bestiary/BestiaryRemoteState";
import {
	primaryElementKey,
	elementVisuals,
} from "@/features/bestiary/element-visuals";
import { filtersFromSearch } from "@/features/bestiary/search-state";
import { bestiaryApi } from "@/shared/api/domains";
import { keys } from "@/shared/api/queries";

function BestiaryDetailContent() {
	const { threatId } = useParams({ from: "/bestiary/$threatId" });
	const search = useSearch({ strict: false });
	const filters = filtersFromSearch(search);
	const detail = useQuery({
		queryKey: keys.bestiaryEntry(threatId, filters),
		queryFn: ({ signal }) => bestiaryApi.get(threatId, filters, signal),
	});
	const element = primaryElementKey(detail.data?.creature.elements ?? []);
	useBestiaryTheme(element);
	useEffect(() => {
		const scrollContainer = document.querySelector<HTMLElement>("[data-theme]");
		if (scrollContainer) scrollContainer.scrollTop = 0;
	}, [threatId]);
	if (detail.isPending) return <BestiaryLoading variant="detail" />;
	if (detail.isError)
		return (
			<BestiaryError error={detail.error} retry={() => void detail.refetch()} />
		);
	const { creature, navigation } = detail.data;
	const visual = element ? elementVisuals[element] : null;
	const listSearch = {
		q: filters.q ?? "",
		elementId: filters.elementId ?? "",
		beingTypeId: filters.beingTypeId ?? "",
		sizeId: filters.sizeId ?? "",
		vdMin: filters.vdMin ?? "",
		vdMax: filters.vdMax ?? "",
		sort: filters.sort ?? "name",
	};
	const detailSearch = (previous: typeof search) => ({
		...previous,
		...listSearch,
	});
	return (
		<div
			className={`mx-auto max-w-[1500px] ${visual?.classes ?? "[--element:#b9b3a6] [--paper:#eeeae2] [--paper-ink:#292721] [--paper-muted:#625d53] [--paper-rule:#b8afa0]"}`}
		>
			<nav
				aria-label="Retorno ao arquivo"
				className="mb-6 flex flex-wrap items-center justify-between gap-4"
			>
				<Link
					to="/bestiary"
					search={(previous: Record<string, unknown>) => ({
						...previous,
						...listSearch,
					})}
					className="inline-flex min-h-11 items-center border border-(--edge) px-5 py-2 text-sm font-semibold text-(--ink) hover:border-(--accent) focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-(--accent)"
				>
					← Voltar ao bestiário
				</Link>
				{navigation.position !== null && (
					<p className="font-mono text-xs text-(--muted)">
						Registro {navigation.position} de {navigation.total}
					</p>
				)}
			</nav>
			<BestiaryDetailCover key={threatId} threat={creature} element={element} />
			<BestiaryDetailSections key={threatId} threat={creature} />
			{navigation.position === null && (
				<p
					role="status"
					className="mb-6 border-l-2 border-(--accent) bg-(--surface) p-4 text-sm text-(--ink)"
				>
					Este registro não corresponde aos filtros atuais. O link direto
					permanece disponível.
				</p>
			)}
			<nav
				aria-label="Percorrer ameaças"
				className="mt-8 grid gap-3 border-t border-(--edge)/70 pt-6 sm:grid-cols-2"
			>
				{navigation.previous ? (
					<Link
						to="/bestiary/$threatId"
						params={{ threatId: navigation.previous.id }}
						search={detailSearch}
						className="border border-(--edge) bg-(--surface) p-5 hover:border-(--accent) focus-visible:outline-2 focus-visible:outline-(--accent)"
					>
						<span className="block font-mono text-[10px] uppercase tracking-[0.15em] text-(--muted)">
							Registro anterior
						</span>
						<span className="mt-2 block font-serif text-2xl">
							← {navigation.previous.name}
						</span>
					</Link>
				) : (
					<span
						aria-disabled="true"
						className="border border-(--edge)/50 p-5 opacity-55"
					>
						<span className="block font-mono text-[10px] uppercase tracking-[0.15em] text-(--muted)">
							Registro anterior
						</span>
						<span className="mt-2 block text-sm text-(--muted)">
							Início do catálogo
						</span>
					</span>
				)}
				{navigation.next ? (
					<Link
						to="/bestiary/$threatId"
						params={{ threatId: navigation.next.id }}
						search={detailSearch}
						className="border border-(--edge) bg-(--surface) p-5 text-right hover:border-(--accent) focus-visible:outline-2 focus-visible:outline-(--accent)"
					>
						<span className="block font-mono text-[10px] uppercase tracking-[0.15em] text-(--muted)">
							Próximo registro
						</span>
						<span className="mt-2 block font-serif text-2xl">
							{navigation.next.name} →
						</span>
					</Link>
				) : (
					<span
						aria-disabled="true"
						className="border border-(--edge)/50 p-5 text-right opacity-55"
					>
						<span className="block font-mono text-[10px] uppercase tracking-[0.15em] text-(--muted)">
							Próximo registro
						</span>
						<span className="mt-2 block text-sm text-(--muted)">
							Fim do catálogo
						</span>
					</span>
				)}
			</nav>
		</div>
	);
}

export function BestiaryDetailPage() {
	return (
		<BestiarySystemGate>
			<BestiaryDetailContent />
		</BestiarySystemGate>
	);
}
