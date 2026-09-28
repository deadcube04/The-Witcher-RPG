import { RpgDisclosure } from "@/components/primitives/RpgDisclosure";
import {
	BookFacts,
	BookHeading,
	BookNotes,
	BookPage,
	BookSpread,
	BookSubheading,
} from "@/features/bestiary/BestiaryBookPrimitives";
import type { BestiaryThreat } from "@/shared/contracts/bestiary";

function hasContent(
	values: Array<string | number | null | undefined>,
): boolean {
	return values.some(
		(value) => value !== null && value !== undefined && value !== "",
	);
}

function FieldTests({ threat }: { threat: BestiaryThreat }) {
	return (
		<BookFacts
			entries={[
				["Percepção", threat.tests.perception],
				["Iniciativa", threat.tests.initiative],
				["Fortitude", threat.tests.fortitude],
				["Reflexos", threat.tests.reflexes],
				["Vontade", threat.tests.will],
			]}
		/>
	);
}

function Actions({ threat }: { threat: BestiaryThreat }) {
	return (
		<div className="divide-y divide-(--paper-rule)">
			{threat.actions.map((action) => (
				<article key={action.id} className="py-5 first:pt-0 last:pb-0">
					<div className="flex flex-wrap items-baseline justify-between gap-2">
						<h3 className="font-serif text-2xl leading-tight">{action.name}</h3>
						{action.type && (
							<span className="font-mono text-[10px] uppercase tracking-[0.1em] text-(--paper-muted)">
								{action.type}
							</span>
						)}
					</div>
					{action.description && (
						<p className="mt-2 whitespace-pre-line text-sm leading-6">
							{action.description}
						</p>
					)}
					<BookNotes
						entries={[
							["Teste", action.testExpression],
							["Dano", action.damageExpression],
							["Ataques", action.attackCount],
							["Alcance", action.range],
							["Crítico", action.critical],
							["Tipo de dano", action.damageType],
							["Resistência", action.resistance],
						]}
					/>
					{action.sourceRef && (
						<p className="mt-3 font-mono text-[10px] text-(--paper-muted)">
							Fonte: {action.sourceRef}
						</p>
					)}
				</article>
			))}
		</div>
	);
}

function DetailsAndActions({ threat }: { threat: BestiaryThreat }) {
	const hasTests = hasContent(Object.values(threat.tests));
	const hasDefenses = hasContent([
		threat.resistancesText,
		threat.immunitiesText,
		threat.vulnerabilitiesText,
	]);
	const hasPresence = hasContent([
		threat.disturbingPresence,
		threat.presence.difficulty,
		threat.presence.damage,
		threat.presence.immuneNex,
	]);
	const hasLeft =
		hasTests ||
		hasDefenses ||
		hasPresence ||
		Boolean(threat.senses || threat.movement);
	if (!hasLeft && threat.actions.length === 0) return null;
	return (
		<BookSpread label="Leitura de confronto">
			{hasLeft && (
				<BookPage
					folio="Caderno de campo / II"
					className={threat.actions.length === 0 ? "lg:col-span-2" : ""}
				>
					<BookHeading mark="Leitura de confronto" title="Sinais e defesas" />
					{hasTests && (
						<>
							<BookSubheading>Testes</BookSubheading>
							<FieldTests threat={threat} />
						</>
					)}
					{hasContent([threat.senses, threat.movement]) && (
						<>
							<BookSubheading>Sentidos e movimento</BookSubheading>
							<BookNotes
								entries={[
									["Sentidos", threat.senses],
									["Deslocamento", threat.movement],
								]}
							/>
						</>
					)}
					{hasDefenses && (
						<>
							<BookSubheading>Proteção observada</BookSubheading>
							<BookNotes
								entries={[
									["Resistências", threat.resistancesText],
									["Imunidades", threat.immunitiesText],
									["Vulnerabilidades", threat.vulnerabilitiesText],
								]}
							/>
						</>
					)}
					{hasPresence && (
						<>
							<BookSubheading>Presença perturbadora</BookSubheading>
							<BookNotes
								entries={[
									["Registro", threat.disturbingPresence],
									["DT", threat.presence.difficulty],
									["Dano", threat.presence.damage],
									["Imune a partir de NEX", threat.presence.immuneNex],
								]}
							/>
							{threat.presence.immuneNex !== null && (
								<p className="mt-3 text-xs leading-5 text-(--paper-muted)">
									Nota de campo: NEX indica o Nível de Exposição Paranormal de
									um agente.
								</p>
							)}
						</>
					)}
				</BookPage>
			)}
			{threat.actions.length > 0 && (
				<BookPage
					folio="Caderno de campo / III"
					className={!hasLeft ? "lg:col-span-2" : ""}
				>
					<BookHeading mark="Resposta da ameaça" title="Ações registradas" />
					<Actions threat={threat} />
				</BookPage>
			)}
		</BookSpread>
	);
}

function SkillsAndTraits({ threat }: { threat: BestiaryThreat }) {
	return (
		<>
			{threat.skills.length > 0 && (
				<>
					<BookSubheading>Perícias</BookSubheading>
					<BookFacts
						entries={threat.skills.map((skill): [string, string] => [
							skill.name,
							skill.testExpression,
						])}
					/>
				</>
			)}
			{threat.defenseTraits.length > 0 && (
				<>
					<BookSubheading>Traços defensivos</BookSubheading>
					<div className="space-y-3">
						{threat.defenseTraits.map((trait) => (
							<div
								key={trait.id}
								className="border-l-2 border-(--paper-rule) pl-3"
							>
								<p className="font-mono text-[10px] uppercase tracking-[0.12em] text-(--paper-muted)">
									{trait.type}
								</p>
								<p className="mt-1 text-sm leading-6">
									{trait.name}
									{trait.valueText && ` · ${trait.valueText}`}
								</p>
								{trait.sourceRef && (
									<p className="mt-1 font-mono text-[10px] text-(--paper-muted)">
										Fonte: {trait.sourceRef}
									</p>
								)}
							</div>
						))}
					</div>
				</>
			)}
		</>
	);
}

function ProtectedRecords({ threat }: { threat: BestiaryThreat }) {
	return (
		<div className="space-y-4">
			{threat.abilities.length > 0 && (
				<RpgDisclosure
					title={
						<span className="font-serif text-2xl text-(--paper-ink)">
							Habilidades especiais
						</span>
					}
					summary="Registro reservado: a leitura pode antecipar descobertas da investigação."
					className="border border-(--paper-rule) px-4 py-2"
					buttonClassName="px-0! text-(--paper-ink)! hover:bg-transparent!"
					panelClassName="pb-4"
				>
					<div className="space-y-5 border-t border-(--paper-rule) pt-4">
						{threat.abilities.map((ability) => (
							<article key={ability.id}>
								<h4 className="font-serif text-xl">{ability.name}</h4>
								{ability.effectSummary && (
									<p className="mt-2 whitespace-pre-line text-sm leading-6">
										{ability.effectSummary}
									</p>
								)}
								{ability.sourceRef && (
									<p className="mt-2 font-mono text-[10px] text-(--paper-muted)">
										Fonte: {ability.sourceRef}
									</p>
								)}
							</article>
						))}
					</div>
				</RpgDisclosure>
			)}
			{threat.fearEnigmaSummary && (
				<RpgDisclosure
					title={
						<span className="font-serif text-2xl text-(--paper-ink)">
							Enigma do Medo
						</span>
					}
					summary="Registro reservado: abra apenas se desejar conhecer este segredo."
					className="border border-(--paper-rule) px-4 py-2"
					buttonClassName="px-0! text-(--paper-ink)! hover:bg-transparent!"
					panelClassName="pb-4"
				>
					<p className="whitespace-pre-line border-t border-(--paper-rule) pt-4 text-sm leading-6">
						{threat.fearEnigmaSummary}
					</p>
				</RpgDisclosure>
			)}
		</div>
	);
}

function SecondaryRecords({ threat }: { threat: BestiaryThreat }) {
	const hasLeft = threat.skills.length > 0 || threat.defenseTraits.length > 0;
	const hasRight =
		threat.abilities.length > 0 || Boolean(threat.fearEnigmaSummary);
	if (!hasLeft && !hasRight) return null;
	return (
		<BookSpread label="Anotações complementares">
			{hasLeft && (
				<BookPage
					folio="Caderno de campo / IV"
					className={!hasRight ? "lg:col-span-2" : ""}
				>
					<BookHeading
						mark="Anotações complementares"
						title="Traços e perícias"
					/>
					<SkillsAndTraits threat={threat} />
				</BookPage>
			)}
			{hasRight && (
				<BookPage
					folio="Caderno de campo / V"
					className={!hasLeft ? "lg:col-span-2" : ""}
				>
					<BookHeading
						mark="Acesso reservado"
						title="O que o registro oculta"
					/>
					<p className="mb-5 text-sm leading-6 text-(--paper-muted)">
						As páginas lacradas podem revelar o que a investigação ainda não
						encontrou.
					</p>
					<ProtectedRecords threat={threat} />
				</BookPage>
			)}
		</BookSpread>
	);
}

export function BestiaryDetailSections({ threat }: { threat: BestiaryThreat }) {
	return (
		<>
			<DetailsAndActions threat={threat} />
			<SecondaryRecords threat={threat} />
		</>
	);
}
