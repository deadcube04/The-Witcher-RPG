import { motion, useReducedMotion } from "motion/react";
import { BestiaryReveal } from "@/features/bestiary/BestiaryReveal";
import {
	elementKeyFromName,
	elementOrder,
	elementVisuals,
} from "@/features/bestiary/element-visuals";
import type { BestiaryOptions } from "@/shared/contracts/bestiary";

type Props = {
	elements: BestiaryOptions["elements"];
	selectedId: string;
	onSelect: (id: string) => void;
};

export function BestiaryChapterIndex({
	elements,
	selectedId,
	onSelect,
}: Props) {
	const reduced = useReducedMotion();
	const chapters = elementOrder.flatMap((key) => {
		const option = elements.find(
			(item) => elementKeyFromName(item.name) === key,
		);
		return option ? [{ option, visual: elementVisuals[key] }] : [];
	});
	return (
		<section aria-labelledby="bestiary-chapters" className="mb-12">
			<BestiaryReveal className="mb-5 flex flex-wrap items-end justify-between gap-4 border-b border-(--edge)/70 pb-4">
				<div>
					<p className="font-mono text-[10px] uppercase tracking-[0.2em] text-(--accent)">
						Índice de campo
					</p>
					<h2
						id="bestiary-chapters"
						className="mt-2 font-serif text-3xl md:text-4xl"
					>
						Siga os vestígios
					</h2>
				</div>
				<p className="max-w-md text-sm leading-6 text-(--muted)">
					Nota de campo: elementos agrupam registros pela influência paranormal
					observada. O arquivo completo permanece logo abaixo.
				</p>
			</BestiaryReveal>
			<div className="flex snap-x snap-mandatory gap-3 overflow-x-auto pb-4 [scrollbar-color:var(--edge)_var(--canvas)] [scrollbar-width:thin] [&::-webkit-scrollbar]:h-2 [&::-webkit-scrollbar-track]:bg-(--canvas) [&::-webkit-scrollbar-thumb]:bg-(--edge) [&::-webkit-scrollbar-thumb:hover]:bg-(--accent) md:grid md:grid-cols-3 md:overflow-visible 2xl:grid-cols-5">
				{chapters.map(({ option, visual }, index) => (
					<BestiaryReveal
						key={option.id}
						delay={Math.min(index * 0.055, 0.22)}
						className="min-w-[70vw] snap-start sm:min-w-[40vw] md:min-w-0"
					>
						<motion.button
							type="button"
							aria-pressed={selectedId === option.id}
							onClick={() =>
								onSelect(selectedId === option.id ? "" : option.id)
							}
							whileHover={reduced ? undefined : { y: -5 }}
							whileTap={reduced ? undefined : { scale: 0.985 }}
							transition={{ duration: reduced ? 0 : 0.22 }}
							className={`group relative block h-68 w-full overflow-hidden border text-left focus-visible:outline-2 focus-visible:outline-offset-3 focus-visible:outline-(--accent) ${selectedId === option.id ? "border-(--accent)" : "border-(--edge)/70"}`}
						>
							<img
								src={visual.art}
								alt=""
								loading={index < 2 ? "eager" : "lazy"}
								className="absolute inset-0 size-full object-cover opacity-80 group-hover:opacity-95"
							/>
							<span
								aria-hidden="true"
								className="absolute inset-0 bg-linear-to-t from-black/95 via-black/25 to-transparent"
							/>
							<span className="relative flex h-full flex-col justify-between p-4 text-[#fff8eb]">
								<span className="font-mono text-[10px] tracking-[0.2em]">
									{visual.mark}
								</span>
								<span>
									<span className="block font-serif text-3xl leading-none">
										{visual.name}
									</span>
									<span className="mt-2 block text-xs text-[#eee2d1]">
										{selectedId === option.id
											? "Capítulo aberto · voltar ao arquivo"
											: "Abrir capítulo"}
									</span>
								</span>
							</span>
						</motion.button>
					</BestiaryReveal>
				))}
			</div>
		</section>
	);
}
