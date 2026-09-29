import type { BestiaryThreat } from "@/shared/contracts/bestiary";

function NarrativeSection({
	title,
	text,
}: {
	title: string;
	text?: string | null;
}) {
	return (
		<section className="border-t border-(--edge)/40 py-7 first:border-t-0 first:pt-0 md:grid md:grid-cols-[11rem_minmax(0,1fr)] md:gap-10">
			<h3 className="font-serif text-2xl leading-tight text-(--ink)">
				{title}
			</h3>
			{text?.trim() ? (
				<p className="mt-3 max-w-[68ch] whitespace-pre-line text-sm leading-7 text-(--ink) md:mt-0 md:text-base">
					{text}
				</p>
			) : (
				<p className="mt-3 text-sm italic text-(--muted) md:mt-0">
					Informação ainda não disponível.
				</p>
			)}
		</section>
	);
}

export function BestiaryInformation({ threat }: { threat: BestiaryThreat }) {
	return (
		<div className="mx-auto max-w-5xl pb-12">
			<div className="mb-10 max-w-2xl">
				<h2 className="font-serif text-4xl leading-tight md:text-5xl">
					Conheça a ameaça
				</h2>
				<p className="mt-3 text-sm leading-6 text-(--muted)">
					Relatos e observações sobre sua presença no mundo.
				</p>
			</div>
			<NarrativeSection title="Resumo" text={threat.description} />
			<NarrativeSection title="Aparência" text={threat.appearance} />
			<NarrativeSection title="Comportamento" text={threat.behavior} />
			<NarrativeSection title="História" text={threat.history} />
			{(threat.beingTypeDescription ||
				threat.descriptors.length > 0 ||
				threat.sourceRef) && (
				<div className="mt-8 border-t border-(--edge)/40 pt-6 text-sm leading-6 text-(--muted)">
					{threat.beingTypeDescription && (
						<p className="max-w-[68ch]">{threat.beingTypeDescription}</p>
					)}
					{threat.descriptors.length > 0 && (
						<p className="mt-3">
							Descritores: {threat.descriptors.join(" · ")}
						</p>
					)}
					{threat.sourceRef && (
						<p className="mt-3">Fonte: {threat.sourceRef}</p>
					)}
				</div>
			)}
		</div>
	);
}
