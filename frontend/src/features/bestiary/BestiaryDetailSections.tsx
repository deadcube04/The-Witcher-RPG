import type { ReactNode } from "react";
import { RpgDisclosure } from "@/components/primitives/RpgDisclosure";
import { RpgTermHelp } from "@/components/primitives/RpgTermHelp";
import type { BestiaryThreat } from "@/shared/contracts/bestiary";

type Fact = [label: string, value: string | number | null | undefined];

function Section({ title, children }: { title: string; children: ReactNode }) {
	return (
		<section className="border-t border-(--edge)/45 py-9 first:border-t-0 first:pt-0">
			<h2 className="mb-6 font-serif text-3xl leading-tight md:text-4xl">
				{title}
			</h2>
			{children}
		</section>
	);
}

function Facts({ entries }: { entries: Fact[] }) {
	const available = entries.filter(
		([, value]) => value !== null && value !== undefined && value !== "",
	);
	if (available.length === 0) return null;
	return (
		<dl className="grid gap-x-8 gap-y-5 sm:grid-cols-2 xl:grid-cols-3">
			{available.map(([label, value]) => (
				<div key={label} className="border-b border-(--edge)/35 pb-3">
					<dt className="text-xs text-(--muted)">{label}</dt>
					<dd className="mt-1 font-serif text-2xl leading-tight">{value}</dd>
				</div>
			))}
		</dl>
	);
}

function Notes({ entries }: { entries: Fact[] }) {
	const available = entries.filter(
		([, value]) => value !== null && value !== undefined && value !== "",
	);
	if (available.length === 0) return null;
	return (
		<dl className="space-y-4">
			{available.map(([label, value]) => (
				<div
					key={label}
					className="grid gap-1 sm:grid-cols-[9rem_minmax(0,1fr)] sm:gap-6"
				>
					<dt className="text-sm text-(--muted)">{label}</dt>
					<dd className="whitespace-pre-line text-sm leading-6">{value}</dd>
				</div>
			))}
		</dl>
	);
}

function Subsection({
	title,
	children,
}: {
	title: string;
	children: ReactNode;
}) {
	return (
		<div className="mt-8 first:mt-0">
			<h3 className="mb-4 text-sm font-semibold uppercase tracking-[0.08em] text-(--muted)">
				{title}
			</h3>
			{children}
		</div>
	);
}

function Actions({ threat }: { threat: BestiaryThreat }) {
	if (threat.actions.length === 0) return null;
	return (
		<Section title="Ações e ataques">
			<div className="space-y-8">
				{threat.actions.map((action) => (
					<article
						key={action.id}
						className="rounded-[1.5rem] bg-(--surface)/65 p-5 ring-1 ring-(--edge)/35 md:p-7"
					>
						<div className="flex flex-wrap items-baseline justify-between gap-3">
							<h3 className="font-serif text-2xl">{action.name}</h3>
							{action.type && (
								<span className="text-xs text-(--muted)">{action.type}</span>
							)}
						</div>
						{action.description && (
							<p className="mt-3 whitespace-pre-line text-sm leading-6">
								{action.description}
							</p>
						)}
						<div className="mt-5 border-t border-(--edge)/35 pt-5">
							<Notes
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
						</div>
						{action.sourceRef && (
							<p className="mt-4 text-xs text-(--muted)">
								Fonte: {action.sourceRef}
							</p>
						)}
					</article>
				))}
			</div>
		</Section>
	);
}

function ProtectedRecords({ threat }: { threat: BestiaryThreat }) {
	if (threat.abilities.length === 0 && !threat.fearEnigmaSummary) return null;
	return (
		<Section title="Registros reservados">
			<p className="mb-6 text-sm text-(--muted)">
				Abra apenas se quiser conhecer informações que podem antecipar
				descobertas.
			</p>
			<div className="space-y-3">
				{threat.abilities.length > 0 && (
					<RpgDisclosure
						title={
							<span className="font-serif text-2xl">Habilidades especiais</span>
						}
						summary="Pode revelar informações da investigação"
						className="rounded-2xl bg-(--surface)/65 px-5 py-2 ring-1 ring-(--edge)/35"
						buttonClassName="px-0! text-(--ink)!"
						panelClassName="pb-5"
					>
						<div className="space-y-6 border-t border-(--edge)/35 pt-5">
							{threat.abilities.map((ability) => (
								<article key={ability.id}>
									<h4 className="font-serif text-xl">{ability.name}</h4>
									{ability.effectSummary && (
										<p className="mt-2 whitespace-pre-line text-sm leading-6">
											{ability.effectSummary}
										</p>
									)}
									{ability.sourceRef && (
										<p className="mt-2 text-xs text-(--muted)">
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
						title={<span className="font-serif text-2xl">Enigma do Medo</span>}
						summary="Pode revelar um segredo da ameaça"
						className="rounded-2xl bg-(--surface)/65 px-5 py-2 ring-1 ring-(--edge)/35"
						buttonClassName="px-0! text-(--ink)!"
						panelClassName="pb-5"
					>
						<p className="whitespace-pre-line border-t border-(--edge)/35 pt-5 text-sm leading-6">
							{threat.fearEnigmaSummary}
						</p>
					</RpgDisclosure>
				)}
			</div>
		</Section>
	);
}

export function BestiaryDetailSections({ threat }: { threat: BestiaryThreat }) {
	const hasTests = Object.values(threat.tests).some(Boolean);
	const hasDefenses = Boolean(
		threat.resistancesText ||
			threat.immunitiesText ||
			threat.vulnerabilitiesText,
	);
	const hasPresence = Boolean(
		threat.disturbingPresence ||
			threat.presence.difficulty !== null ||
			threat.presence.damage ||
			threat.presence.immuneNex !== null,
	);
	return (
		<div className="mx-auto max-w-6xl pb-10">
			<div className="mb-9">
				<h2 className="font-serif text-4xl md:text-5xl">Ficha da ameaça</h2>
				<p className="mt-3 text-sm text-(--muted)">
					Dados de confronto e capacidades registradas.
				</p>
			</div>
			<Section title="Essencial">
				<Facts
					entries={[
						["Defesa", threat.stats.defense],
						["Pontos de vida", threat.stats.hitPoints],
						["Ferido", threat.stats.woundedAt],
						["Porte", threat.size],
					]}
				/>
				<Subsection title="Atributos">
					<Facts
						entries={[
							["Agilidade", threat.stats.agility],
							["Força", threat.stats.strength],
							["Intelecto", threat.stats.intellect],
							["Presença", threat.stats.presence],
							["Vigor", threat.stats.vigor],
						]}
					/>
				</Subsection>
			</Section>
			{(hasTests ||
				threat.senses ||
				threat.movement ||
				hasDefenses ||
				hasPresence) && (
				<Section title="Percepção e defesa">
					{hasTests && (
						<Subsection title="Testes">
							<Facts
								entries={[
									["Percepção", threat.tests.perception],
									["Iniciativa", threat.tests.initiative],
									["Fortitude", threat.tests.fortitude],
									["Reflexos", threat.tests.reflexes],
									["Vontade", threat.tests.will],
								]}
							/>
						</Subsection>
					)}
					{(threat.senses || threat.movement) && (
						<Subsection title="Sentidos e movimento">
							<Notes
								entries={[
									["Sentidos", threat.senses],
									["Deslocamento", threat.movement],
								]}
							/>
						</Subsection>
					)}
					{hasDefenses && (
						<Subsection title="Proteções">
							<Notes
								entries={[
									["Resistências", threat.resistancesText],
									["Imunidades", threat.immunitiesText],
									["Vulnerabilidades", threat.vulnerabilitiesText],
								]}
							/>
						</Subsection>
					)}
					{hasPresence && (
						<Subsection title="Presença perturbadora">
							<Notes
								entries={[
									["Registro", threat.disturbingPresence],
									["DT", threat.presence.difficulty],
									["Dano", threat.presence.damage],
									["Imune a partir de NEX", threat.presence.immuneNex],
								]}
							/>
							{threat.presence.immuneNex !== null && (
								<div className="mt-3 flex items-center gap-2 text-xs text-(--muted)">
									<span>NEX</span>
									<RpgTermHelp
										term="NEX"
										explanation="Nível de Exposição Paranormal de um agente."
									/>
								</div>
							)}
						</Subsection>
					)}
				</Section>
			)}
			<Actions threat={threat} />
			{(threat.skills.length > 0 || threat.defenseTraits.length > 0) && (
				<Section title="Perícias e traços">
					{threat.skills.length > 0 && (
						<Subsection title="Perícias">
							<Facts
								entries={threat.skills.map((skill) => [
									skill.name,
									skill.testExpression,
								])}
							/>
						</Subsection>
					)}
					{threat.defenseTraits.length > 0 && (
						<Subsection title="Traços defensivos">
							<div className="space-y-5">
								{threat.defenseTraits.map((trait) => (
									<div
										key={trait.id}
										className="border-l-2 border-(--accent)/50 pl-4"
									>
										<p className="text-xs text-(--muted)">{trait.type}</p>
										<p className="mt-1 text-sm">
											{trait.name}
											{trait.valueText && ` · ${trait.valueText}`}
										</p>
										{trait.sourceRef && (
											<p className="mt-1 text-xs text-(--muted)">
												Fonte: {trait.sourceRef}
											</p>
										)}
									</div>
								))}
							</div>
						</Subsection>
					)}
				</Section>
			)}
			<ProtectedRecords threat={threat} />
		</div>
	);
}
