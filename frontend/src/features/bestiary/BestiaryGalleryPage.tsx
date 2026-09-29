import { useEffect, useMemo, useRef } from "react";
import { useInfiniteQuery, useQuery } from "@tanstack/react-query";
import { useDebouncedValue } from "@tanstack/react-pacer";
import { useNavigate, useSearch } from "@tanstack/react-router";
import { useBestiaryTheme } from "@/app/layout/BestiaryThemeContext";
import { RpgButton } from "@/components/primitives/RpgControls";
import { BestiaryCard } from "@/features/bestiary/BestiaryCard";
import { BestiaryFilters } from "@/features/bestiary/BestiaryFilters";
import { BestiaryGalleryHeader } from "@/features/bestiary/BestiaryGalleryHeader";
import { BestiaryReveal } from "@/features/bestiary/BestiaryReveal";
import {
	BestiaryError,
	BestiaryLoading,
} from "@/features/bestiary/BestiaryRemoteState";
import { BestiarySystemGate } from "@/features/bestiary/BestiarySystemGate";
import { elementKeyFromName } from "@/features/bestiary/element-visuals";
import { filtersFromSearch } from "@/features/bestiary/search-state";
import { bestiaryApi } from "@/shared/api/domains";
import { keys, queries } from "@/shared/api/queries";

function BestiaryGalleryContent() {
	const search = useSearch({ strict: false });
	const navigate = useNavigate();
	const filters = filtersFromSearch(search);
	const options = useQuery(queries.bestiaryOptions);
	const activeElement = options.data?.elements.find(
		(item) => item.id === filters.elementId,
	);
	const activeKey = elementKeyFromName(activeElement?.name);
	useBestiaryTheme(activeKey);
	const [debouncedQuery] = useDebouncedValue(filters.q ?? "", { wait: 300 });
	const requestFilters = useMemo(
		() => ({ ...filters, q: debouncedQuery }),
		[filters, debouncedQuery],
	);
	const filterSignature = JSON.stringify(requestFilters);
	const rangeValid = !(
		filters.vdMin &&
		filters.vdMax &&
		Number(filters.vdMin) > Number(filters.vdMax)
	);
	const list = useInfiniteQuery({
		queryKey: keys.bestiaryList(requestFilters),
		queryFn: ({ pageParam, signal }) =>
			bestiaryApi.list(requestFilters, pageParam, signal),
		initialPageParam: 1,
		getNextPageParam: (lastPage) => lastPage.nextPage ?? undefined,
		enabled: rangeValid,
	});
	const fetchNextPage = list.fetchNextPage;
	const hasNextPage = list.hasNextPage;
	const isFetchingNextPage = list.isFetchingNextPage;
	const sentinelRef = useRef<HTMLDivElement>(null);
	const previousFilterSignature = useRef(filterSignature);
	const restoreKey = `nexus:bestiary:scroll:${window.location.search}`;
	const restored = useRef(false);
	const navigateFilters = (patch: Partial<typeof filters>) => {
		void navigate({
			to: ".",
			search: (previous: Record<string, unknown>) => ({
				...previous,
				...patch,
			}),
			replace: true,
		});
	};
	useEffect(() => {
		if (previousFilterSignature.current === filterSignature) return;
		previousFilterSignature.current = filterSignature;
		sessionStorage.removeItem(
			`nexus:bestiary:scroll:${window.location.search}`,
		);
		const scrollContainer = document.querySelector<HTMLElement>("[data-theme]");
		if (scrollContainer) scrollContainer.scrollTop = 0;
	}, [filterSignature]);
	useEffect(() => {
		const sentinel = sentinelRef.current;
		if (!sentinel || !hasNextPage || isFetchingNextPage || !rangeValid) return;
		const observer = new IntersectionObserver(
			(entries) => {
				if (entries.some((entry) => entry.isIntersecting)) void fetchNextPage();
			},
			{ rootMargin: "600px 0px" },
		);
		observer.observe(sentinel);
		return () => observer.disconnect();
	}, [hasNextPage, isFetchingNextPage, fetchNextPage, rangeValid]);
	useEffect(() => {
		if (restored.current || list.isPending || !list.data) return;
		const savedPosition = sessionStorage.getItem(restoreKey);
		if (savedPosition === null) return;
		const position = Number(savedPosition);
		if (!Number.isFinite(position)) return;
		const animationFrame = window.requestAnimationFrame(() => {
			const scrollContainer =
				document.querySelector<HTMLElement>("[data-theme]");
			if (scrollContainer) scrollContainer.scrollTop = position;
			restored.current = true;
		});
		return () => window.cancelAnimationFrame(animationFrame);
	}, [list.data, list.isPending, restoreKey]);
	if (options.isPending) return <BestiaryLoading variant="gallery" />;
	if (options.isError)
		return (
			<BestiaryError
				error={options.error}
				retry={() => void options.refetch()}
			/>
		);
	const items = list.data?.pages.flatMap((page) => page.items) ?? [];
	const total = list.data?.pages[0]?.total ?? 0;
	return (
		<div className="mx-auto max-w-[1480px]">
			<BestiaryGalleryHeader element={activeKey} />
			<section id="archive-records" aria-labelledby="archive-records-heading">
				<div className="mb-6 flex flex-wrap items-end justify-between gap-4">
					<div>
						<h2
							id="archive-records-heading"
							className="font-serif text-3xl md:text-4xl"
						>
							{filters.elementId === "none"
								? "Ameaças sem elemento"
								: activeElement
									? `Ameaças de ${activeElement.name}`
									: "Todas as ameaças"}
						</h2>
					</div>
				</div>
				<BestiaryFilters
					filters={filters}
					options={options.data}
					onChange={navigateFilters}
				/>
				{!rangeValid && (
					<p
						role="alert"
						className="mb-6 border-l-2 border-(--danger) bg-(--surface) px-4 py-3 text-sm text-(--danger)"
					>
						A VD mínima precisa ser menor ou igual à VD máxima. Revise a faixa
						em “Mais filtros”.
					</p>
				)}
				{rangeValid && list.isPending ? (
					<BestiaryLoading variant="results" />
				) : rangeValid && list.isError && items.length === 0 ? (
					<BestiaryError error={list.error} retry={() => void list.refetch()} />
				) : rangeValid && total === 0 ? (
					<div className="grid min-h-64 place-items-center border border-dashed border-(--edge) bg-(--surface)/60 p-8 text-center">
						<div>
							<h3 className="font-serif text-3xl">Nenhuma ameaça encontrada</h3>
							<p className="mt-3 max-w-md text-sm leading-6 text-(--muted)">
								Tente outro nome ou remova alguns filtros para ver mais ameaças.
							</p>
						</div>
					</div>
				) : (
					rangeValid && (
						<>
							<div className="mb-5 flex flex-wrap items-end justify-between gap-3">
								<p aria-live="polite" className="font-serif text-2xl">
									{total} ameaça{total === 1 ? "" : "s"} catalogada
									{total === 1 ? "" : "s"}
								</p>
								<p className="font-mono text-xs text-(--muted)">
									Exibindo {items.length} de {total}
								</p>
							</div>
							<div className="grid items-stretch gap-5 sm:grid-cols-2 xl:grid-cols-3">
								{items.map((threat, index) => (
									<BestiaryReveal
										key={threat.id}
										delay={Math.min((index % 6) * 0.04, 0.2)}
										className="h-full"
									>
										<BestiaryCard threat={threat} filters={filters} />
									</BestiaryReveal>
								))}
							</div>
							{list.isError && items.length > 0 && (
								<div
									role="alert"
									className="mt-6 border-l-2 border-(--danger) bg-(--surface) p-4 text-sm"
								>
									Não foi possível abrir os próximos registros.{" "}
									<button
										type="button"
										onClick={() => void list.fetchNextPage()}
										className="font-semibold text-(--accent) underline focus-visible:outline-2"
									>
										Tentar novamente
									</button>
								</div>
							)}
							{list.hasNextPage && (
								<div
									ref={sentinelRef}
									className="grid min-h-28 place-items-center py-7"
								>
									<RpgButton
										secondary
										disabled={list.isFetchingNextPage}
										loading={list.isFetchingNextPage}
										onClick={() => void fetchNextPage()}
									>
										Carregar mais ameaças
									</RpgButton>
								</div>
							)}
							{list.isFetchingNextPage && (
								<p
									role="status"
									className="py-4 text-center text-sm text-(--muted)"
								>
									Abrindo próximos registros…
								</p>
							)}
						</>
					)
				)}
			</section>
		</div>
	);
}

export function BestiaryGalleryPage() {
	return (
		<BestiarySystemGate>
			<BestiaryGalleryContent />
		</BestiarySystemGate>
	);
}
