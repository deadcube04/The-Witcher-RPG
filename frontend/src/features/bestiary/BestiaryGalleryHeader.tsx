import {
	elementVisuals,
	type BestiaryElementKey,
} from "@/features/bestiary/element-visuals";

export function BestiaryGalleryHeader({
	element,
}: {
	element: BestiaryElementKey | null;
}) {
	const visual = element ? elementVisuals[element] : null;
	return (
		<header className="mb-10 grid gap-6 border-b border-(--edge)/40 pb-9 md:grid-cols-[minmax(0,1fr)_minmax(14rem,0.6fr)] md:items-end">
			<div>
				<p className="text-xs font-semibold uppercase tracking-[0.18em] text-(--accent)">
					Ordem Paranormal / Bestiário
				</p>
				<h1 className="mt-4 max-w-[14ch] font-serif text-5xl leading-[0.95] tracking-[-0.045em] sm:text-6xl xl:text-7xl">
					{visual ? `Ameaças de ${visual.name}` : "Encontre sua próxima ameaça"}
				</h1>
			</div>
			<p className="max-w-sm text-sm leading-7 text-(--muted)">
				{visual
					? `Explore as criaturas ligadas a ${visual.name}. Os filtros ajudam a refinar sua busca.`
					: "Explore as criaturas do universo e descubra suas histórias, características e fichas."}
			</p>
		</header>
	);
}
