import { motion, useReducedMotion } from "motion/react";
import { Link } from "@tanstack/react-router";
import { BestiaryPortrait } from "@/features/bestiary/BestiaryPortrait";
import {
	elementVisuals,
	primaryElementKey,
} from "@/features/bestiary/element-visuals";
import type {
	BestiarySummary,
	BestiaryFilters,
} from "@/shared/contracts/bestiary";

export function BestiaryCard({
	threat,
	filters,
}: {
	threat: BestiarySummary;
	filters: BestiaryFilters;
}) {
	const reduced = useReducedMotion();
	const element = primaryElementKey(threat.elements);
	const visual = element ? elementVisuals[element] : null;
	const search = {
		q: filters.q ?? "",
		elementId: filters.elementId ?? "",
		beingTypeId: filters.beingTypeId ?? "",
		sizeId: filters.sizeId ?? "",
		vdMin: filters.vdMin ?? "",
		vdMax: filters.vdMax ?? "",
		sort: filters.sort ?? "name",
	};
	return (
		<Link
			to="/bestiary/$threatId"
			params={{ threatId: threat.id }}
			search={(previous: Record<string, unknown>) => ({
				...previous,
				...search,
			})}
			onClick={() => {
				const scrollContainer =
					document.querySelector<HTMLElement>("[data-theme]");
				if (scrollContainer)
					sessionStorage.setItem(
						`nexus:bestiary:scroll:${window.location.search}`,
						String(scrollContainer.scrollTop),
					);
			}}
			className="group block h-full focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-(--accent)"
		>
			<motion.article
				whileHover={reduced ? undefined : { y: -5 }}
				whileTap={reduced ? undefined : { scale: 0.99 }}
				transition={{ duration: reduced ? 0 : 0.2 }}
				className={`flex h-full flex-col border border-(--edge)/70 bg-(--surface) ${visual?.classes ?? "[--element:#b9b3a6]"}`}
			>
				<div className="relative border-b border-(--edge)/60 bg-[#151413] p-2">
					<BestiaryPortrait
						src={threat.imageUrl}
						name={threat.name}
						element={element}
						className="h-64 w-full sm:h-72"
					/>
					<span className="absolute left-4 top-4 border border-white/25 bg-black/75 px-2.5 py-1.5 font-mono text-[10px] uppercase tracking-[0.15em] text-white">
						{threat.beingType ?? "Ameaça"}
					</span>
				</div>
				<div className="flex flex-1 flex-col p-5">
					<div className="flex items-start justify-between gap-3">
						<div className="min-w-0">
							<p className="font-mono text-[10px] uppercase tracking-[0.19em] text-(--element)">
								{visual?.mark ?? "REGISTRO SEM ELEMENTO"}
							</p>
							<h3 className="mt-2 font-serif text-3xl leading-[1.05] text-(--ink)">
								{threat.name}
							</h3>
						</div>
						<div className="shrink-0 border-l border-(--edge) pl-3 text-right">
							<span className="block font-mono text-[10px] text-(--muted)">
								VD
							</span>
							<span className="block font-serif text-3xl leading-none text-(--ink)">
								{threat.challengeValue ?? "?"}
							</span>
						</div>
					</div>
					<p className="mt-3 text-[11px] text-(--muted)">
						{threat.challengeValue === null
							? "Valor de Desafio não informado neste registro."
							: "VD indica o Valor de Desafio registrado para um confronto."}
					</p>
					{threat.description && (
						<p className="mt-4 line-clamp-3 text-sm leading-6 text-(--muted)">
							{threat.description}
						</p>
					)}
					<div className="mt-auto pt-5">
						<div className="flex flex-wrap gap-x-3 gap-y-1 border-t border-(--edge)/60 pt-4 font-mono text-[10px] uppercase tracking-[0.08em] text-(--muted)">
							<span>
								{threat.elements.map((item) => item.name).join(" / ") ||
									"Sem elemento"}
							</span>
							<span>{threat.size ?? "Porte não informado"}</span>
						</div>
						<p className="mt-4 text-sm font-semibold text-(--element)">
							Abrir registro <span aria-hidden="true">↗</span>
						</p>
					</div>
				</div>
			</motion.article>
		</Link>
	);
}
