import { RpgTermHelp } from "@/components/primitives/RpgTermHelp";
import { BestiaryPortrait } from "@/features/bestiary/BestiaryPortrait";
import {
	elementVisuals,
	type BestiaryElementKey,
} from "@/features/bestiary/element-visuals";
import type { BestiaryThreat } from "@/shared/contracts/bestiary";

export function BestiaryDetailCover({
	threat,
	element,
}: {
	threat: BestiaryThreat;
	element: BestiaryElementKey | null;
}) {
	const visual = element ? elementVisuals[element] : null;
	return (
		<header className="mb-8 grid gap-6 lg:grid-cols-[minmax(0,1.1fr)_minmax(20rem,0.9fr)] lg:items-end lg:gap-10">
			<div className="relative overflow-hidden rounded-[1.75rem] bg-[#151413] p-1.5 ring-1 ring-(--edge)/35">
				<BestiaryPortrait
					src={threat.imageUrl}
					name={threat.name}
					element={element}
					priority
					className="h-72 w-full rounded-[1.4rem] sm:h-96 lg:h-[31rem]"
				/>
			</div>
			<div className="pb-1 lg:pb-6">
				<p className="text-xs font-semibold uppercase tracking-[0.18em] text-(--accent)">
					{visual?.name ?? "Ameaça"}
					{threat.group ? ` / ${threat.group}` : ""}
				</p>
				<h1 className="mt-4 max-w-[12ch] font-serif text-5xl leading-[0.94] tracking-[-0.045em] text-(--ink) sm:text-6xl xl:text-7xl">
					{threat.name}
				</h1>
				<div className="mt-8 grid grid-cols-2 gap-x-5 gap-y-5 border-t border-(--edge)/45 pt-6 sm:grid-cols-3">
					<div>
						<div className="flex items-center gap-1.5">
							<span className="text-xs text-(--muted)">VD</span>
							<RpgTermHelp
								term="VD"
								explanation="Valor de Desafio: indica a gravidade prevista de um confronto."
							/>
						</div>
						<p className="mt-1 font-serif text-4xl leading-none">
							{threat.challengeValue ?? "—"}
						</p>
					</div>
					<div>
						<p className="text-xs text-(--muted)">Tipo</p>
						<p className="mt-2 text-sm font-semibold">
							{threat.beingType ?? "Não identificado"}
						</p>
					</div>
					<div>
						<p className="text-xs text-(--muted)">Elemento</p>
						<p className="mt-2 text-sm font-semibold">
							{threat.elements.map((item) => item.name).join(" / ") ||
								"Não registrado"}
						</p>
					</div>
				</div>
			</div>
		</header>
	);
}
