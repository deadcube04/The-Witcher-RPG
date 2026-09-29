import { motion, useReducedMotion } from "motion/react";
import { Link } from "@tanstack/react-router";
import { PiArrowUpRightThin } from "react-icons/pi";
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
			className="group block h-full rounded-[1.7rem] focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-(--accent)"
		>
			<motion.article
				whileHover={reduced ? undefined : { y: -4 }}
				whileTap={reduced ? undefined : { scale: 0.99 }}
				transition={{ duration: reduced ? 0 : 0.32, ease: [0.32, 0.72, 0, 1] }}
				className="flex h-full flex-col rounded-[1.7rem] bg-(--surface)/60 p-1.5 ring-1 ring-(--edge)/30"
			>
				<div className="overflow-hidden rounded-[1.35rem] bg-[#151413]">
					<BestiaryPortrait
						src={threat.imageUrl}
						name={threat.name}
						element={element}
						className="h-48 w-full sm:h-52"
					/>
				</div>
				<div className="flex flex-1 flex-col px-4 pb-4 pt-5 sm:px-5">
					<div className="flex items-start justify-between gap-4">
						<div className="min-w-0">
							<p className="text-[11px] font-semibold uppercase tracking-[0.12em] text-(--accent)">
								{visual?.name ?? "Sem elemento"}
							</p>
							<h3 className="mt-2 font-serif text-3xl leading-[1.05] tracking-tight text-(--ink)">
								{threat.name}
							</h3>
						</div>
						<div className="shrink-0 text-right">
							<span className="block text-[11px] text-(--muted)">VD</span>
							<span className="mt-1 block font-serif text-3xl leading-none">
								{threat.challengeValue ?? "—"}
							</span>
						</div>
					</div>
					{threat.description && (
						<p className="mt-4 line-clamp-2 text-sm leading-6 text-(--muted)">
							{threat.description}
						</p>
					)}
					<div className="mt-auto flex items-end justify-between gap-3 pt-5">
						<p className="text-xs text-(--muted)">
							{threat.beingType ?? "Tipo não identificado"}
							{threat.size ? ` · ${threat.size}` : ""}
						</p>
						<span
							aria-hidden="true"
							className="grid size-9 shrink-0 place-items-center rounded-full bg-(--accent)/10 text-(--accent) ring-1 ring-(--accent)/25"
						>
							<PiArrowUpRightThin className="text-lg" />
						</span>
					</div>
				</div>
			</motion.article>
		</Link>
	);
}
