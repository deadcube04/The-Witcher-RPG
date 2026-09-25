import { AnimatePresence, motion, useReducedMotion } from "motion/react";
import type { ReactNode } from "react";
import { PiCaretDownThin } from "react-icons/pi";

export function RpgExpandableCard({
	id,
	expanded,
	onToggle,
	leading,
	title,
	subtitle,
	summary,
	children,
	className = "",
}: {
	id: string;
	expanded: boolean;
	onToggle: () => void;
	leading: ReactNode;
	title: string;
	subtitle: string;
	summary: ReactNode;
	children: ReactNode;
	className?: string;
}) {
	const reduced = useReducedMotion();
	const regionId = `${id}-details`;
	return (
		<motion.article
			layout={!reduced}
			className={`overflow-hidden rounded-xl border border-(--edge) bg-(--canvas) shadow-lg ${className}`}
		>
			<div className="grid grid-cols-[auto_minmax(0,1fr)_auto] items-center gap-3 p-3 sm:p-4">
				<div className="grid size-12 place-items-center text-2xl text-(--accent)">
					{leading}
				</div>
				<div className="min-w-0">
					<p className="truncate font-semibold">{title}</p>
					<p className="truncate text-xs uppercase tracking-wider opacity-60">
						{subtitle}
					</p>
				</div>
				<button
					type="button"
					aria-label={`${expanded ? "Recolher" : "Expandir"} ${title}`}
					aria-expanded={expanded}
					aria-controls={regionId}
					onClick={onToggle}
					className="grid size-11 place-items-center rounded-full border border-(--edge) hover:text-(--accent) focus-visible:outline-2 focus-visible:outline-(--accent)"
				>
					<motion.span
						animate={{ rotate: expanded ? 180 : 0 }}
						transition={{ duration: reduced ? 0 : 0.18 }}
					>
						<PiCaretDownThin aria-hidden="true" />
					</motion.span>
				</button>
			</div>
			<div className="border-t border-(--edge) p-3 sm:p-4">{summary}</div>
			<AnimatePresence initial={false}>
				{expanded && (
					<motion.div
						id={regionId}
						initial={reduced ? false : { opacity: 0, y: -8, scaleY: 0.98 }}
						animate={{ opacity: 1, y: 0, scaleY: 1 }}
						exit={reduced ? undefined : { opacity: 0, y: -8, scaleY: 0.98 }}
						transition={{ duration: reduced ? 0 : 0.2 }}
						className="origin-top overflow-hidden"
					>
						<div className="space-y-4 border-t border-(--edge) p-4">
							{children}
						</div>
					</motion.div>
				)}
			</AnimatePresence>
		</motion.article>
	);
}
