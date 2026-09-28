import {
	BookFacts,
	BookHeading,
	BookPage,
	BookSpread,
	BookSubheading,
} from "@/features/bestiary/BestiaryBookPrimitives";
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
		<BookSpread label={`Registro de ${threat.name}`}>
			<BookPage folio="Arquivo de ameaças / I">
				<p className="font-mono text-[10px] uppercase tracking-[0.2em] text-(--paper-muted)">
					{visual?.mark ?? "REGISTRO SEM ELEMENTO"} /{" "}
					{threat.group ?? "Ameaça registrada"}
				</p>
				<h1 className="mt-3 font-serif text-5xl leading-[0.95] tracking-tight md:text-6xl xl:text-7xl">
					{threat.name}
				</h1>
				<div className="mt-6 border border-(--paper-rule) bg-[#171614] p-2">
					<BestiaryPortrait
						src={threat.imageUrl}
						name={threat.name}
						element={element}
						priority
						className="h-80 w-full md:h-[27rem]"
					/>
				</div>
				{threat.description && (
					<div className="mt-6">
						<h2 className="font-serif text-2xl">Primeiro relato</h2>
						<p className="mt-2 whitespace-pre-line text-sm leading-7">
							{threat.description}
						</p>
					</div>
				)}
				{threat.sourceRef && (
					<p className="mt-6 font-mono text-[10px] text-(--paper-muted)">
						Fonte do registro: {threat.sourceRef}
					</p>
				)}
			</BookPage>
			<BookPage folio="Arquivo de ameaças / II">
				<BookHeading
					mark="Ficha de reconhecimento"
					title="Como reconhecer esta ameaça"
				/>
				<div className="grid gap-4 border-y border-(--paper-rule) py-5 sm:grid-cols-[auto_1fr] sm:items-center">
					<div className="flex size-28 flex-col items-center justify-center border-2 border-(--paper-ink) text-center">
						<span className="font-mono text-xs tracking-[0.2em]">VD</span>
						<strong className="font-serif text-5xl font-normal leading-none">
							{threat.challengeValue ?? "?"}
						</strong>
					</div>
					<div>
						<p className="font-serif text-xl">Valor de Desafio</p>
						<p className="mt-1 text-sm leading-6 text-(--paper-muted)">
							Nota de campo: esta medida orienta a gravidade de um confronto com
							a ameaça.
						</p>
					</div>
				</div>
				<BookSubheading>Classificação</BookSubheading>
				<dl className="space-y-3 text-sm">
					<div className="grid grid-cols-[7rem_1fr] gap-3 border-b border-(--paper-rule) pb-2">
						<dt className="font-mono text-[10px] uppercase tracking-[0.12em] text-(--paper-muted)">
							Tipo
						</dt>
						<dd>{threat.beingType ?? "Não identificado"}</dd>
					</div>
					<div className="grid grid-cols-[7rem_1fr] gap-3 border-b border-(--paper-rule) pb-2">
						<dt className="font-mono text-[10px] uppercase tracking-[0.12em] text-(--paper-muted)">
							Porte
						</dt>
						<dd>{threat.size ?? "Não informado"}</dd>
					</div>
					<div className="grid grid-cols-[7rem_1fr] gap-3 border-b border-(--paper-rule) pb-2">
						<dt className="font-mono text-[10px] uppercase tracking-[0.12em] text-(--paper-muted)">
							Elementos
						</dt>
						<dd>
							{threat.elements.map((item) => item.name).join(" / ") ||
								"Nenhum registrado"}
						</dd>
					</div>
				</dl>
				<p className="mt-3 text-xs leading-5 text-(--paper-muted)">
					Nota de campo: o elemento classifica a influência paranormal
					observada. Quando há mais de um, o primeiro registro marcado como
					principal conduz esta ficha.
				</p>
				{threat.beingTypeDescription && (
					<p className="mt-5 border-l-2 border-(--paper-rule) pl-3 text-sm leading-6">
						{threat.beingTypeDescription}
					</p>
				)}
				{threat.descriptors.length > 0 && (
					<p className="mt-4 font-mono text-[10px] uppercase tracking-[0.1em] text-(--paper-muted)">
						Indícios: {threat.descriptors.join(" / ")}
					</p>
				)}
				<BookSubheading>Dados essenciais</BookSubheading>
				<BookFacts
					entries={[
						["Defesa", threat.stats.defense],
						["Pontos de vida", threat.stats.hitPoints],
						["Ferido", threat.stats.woundedAt],
					]}
				/>
				<BookSubheading>Atributos</BookSubheading>
				<BookFacts
					entries={[
						["Agilidade", threat.stats.agility],
						["Força", threat.stats.strength],
						["Intelecto", threat.stats.intellect],
						["Presença", threat.stats.presence],
						["Vigor", threat.stats.vigor],
					]}
				/>
			</BookPage>
		</BookSpread>
	);
}
