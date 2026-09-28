import archiveHero from "@/assets/archive/archive-hero.webp";
import { motion, useReducedMotion } from "motion/react";
import {
	elementVisuals,
	type BestiaryElementKey,
} from "@/features/bestiary/element-visuals";

export function BestiaryGalleryHeader({
	element,
}: {
	element: BestiaryElementKey | null;
}) {
	const reduced = useReducedMotion();
	const visual = element ? elementVisuals[element] : null;
	return (
		<motion.header
			key={element ?? "archive"}
			initial={reduced ? false : { opacity: 0, y: 16 }}
			animate={{ opacity: 1, y: 0 }}
			transition={{ duration: reduced ? 0 : 0.45, ease: [0.32, 0.72, 0, 1] }}
			className="relative isolate mb-10 min-h-72 overflow-hidden border border-(--edge)/70 bg-[#11120f] md:min-h-84"
		>
			<img
				src={visual?.art ?? archiveHero}
				alt=""
				className={`absolute inset-0 size-full ${visual ? "object-cover object-[50%_36%] opacity-65 md:object-[75%_40%]" : "object-cover opacity-70"}`}
			/>
			<div
				aria-hidden="true"
				className="absolute inset-0 bg-linear-to-r from-black/95 via-black/70 to-black/20"
			/>
			<div className="relative flex min-h-72 flex-col justify-end p-6 text-[#fff8eb] md:min-h-84 md:p-10">
				<p className="font-mono text-[10px] uppercase tracking-[0.24em] text-[#f3dcc0]">
					{visual
						? `Ordem Paranormal / ${visual.mark}`
						: "Ordem Paranormal / Arquivo de ameaças"}
				</p>
				<h1 className="mt-4 max-w-3xl font-serif text-5xl leading-[0.95] tracking-tight md:text-7xl">
					{visual ? `Capítulo: ${visual.name}` : "Bestiário de campo"}
				</h1>
				<p className="mt-5 max-w-xl text-sm leading-6 text-[#e9e1d8] md:text-base">
					{visual?.note ??
						"Abra um capítulo, siga um nome ou percorra todos os registros. Cada página guarda uma ameaça e os indícios para reconhecê-la."}
				</p>
			</div>
		</motion.header>
	);
}
