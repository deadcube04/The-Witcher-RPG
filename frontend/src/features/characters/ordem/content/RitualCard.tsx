import { useState } from "react";
import type { IconType } from "react-icons";
import {
	PiDropThin,
	PiEyeThin,
	PiGhostThin,
	PiLightningThin,
	PiSpiralThin,
} from "react-icons/pi";
import { RpgExpandableCard } from "@/components/data-display/RpgExpandableCard";
import { RpgStatChip } from "@/components/data-display/RpgStatChip";
import { RpgButton, RpgInput } from "@/components/primitives/RpgControls";
import type {
	CharacterRitual,
	RitualElement,
	RitualTier,
} from "@/shared/contracts/ordem-ritual";
import { parseDiceExpression } from "@/features/dice/roll";

const elementDetails: Record<
	RitualElement,
	{ label: string; icon: IconType; classes: string }
> = {
	blood: {
		label: "Sangue",
		icon: PiDropThin,
		classes:
			"border-red-500/60 bg-[radial-gradient(circle_at_left,#7f1d1d_0%,#231013_55%,#0b0b0d_100%)] [--accent:#ff7167]",
	},
	death: {
		label: "Morte",
		icon: PiSpiralThin,
		classes:
			"border-zinc-400/60 bg-[linear-gradient(135deg,#34363a_0%,#1a1c20_48%,#070809_100%)] [--accent:#d1d5db]",
	},
	knowledge: {
		label: "Conhecimento",
		icon: PiEyeThin,
		classes:
			"border-amber-400/60 bg-[linear-gradient(120deg,#713f12_0%,#29200e_45%,#0b0b0d_100%)] [--accent:#f7cc63]",
	},
	energy: {
		label: "Energia",
		icon: PiLightningThin,
		classes:
			"border-fuchsia-500/60 bg-[linear-gradient(135deg,#581c87_0%,#25103a_48%,#08070a_100%)] [--accent:#d88cff]",
	},
	fear: {
		label: "Medo",
		icon: PiGhostThin,
		classes:
			"border-slate-200/50 bg-[radial-gradient(ellipse_at_top,#475569_0%,#17181d_45%,#050506_100%)] [--accent:#f1f0ed]",
	},
};

function TierSummary({
	label,
	tier,
	onRoll,
	ritualName,
}: {
	label: string;
	tier: RitualTier;
	onRoll: (label: string, expression: string) => void;
	ritualName: string;
}) {
	const roll = tier.rolls[0];
	return (
		<RpgStatChip
			label={`${label} · ${tier.peCost} PE`}
			value={roll?.expression ?? "Efeito"}
			onActivate={
				roll && parseDiceExpression(roll.expression)
					? () => onRoll(`${ritualName} · ${label}`, roll.expression)
					: undefined
			}
		/>
	);
}

export function RitualCard({
	ritual,
	expanded,
	pending,
	onToggle,
	onRoll,
	onNotesChange,
	onEditDefinition,
	onRemove,
}: {
	ritual: CharacterRitual;
	expanded: boolean;
	pending: boolean;
	onToggle: () => void;
	onRoll: (label: string, expression: string) => void;
	onNotesChange: (notes: string) => void;
	onEditDefinition: () => void;
	onRemove: () => void;
}) {
	const [notes, setNotes] = useState(ritual.entry.notes);
	const definition = ritual.definition;
	const details = elementDetails[definition.element];
	const Icon = details.icon;
	return (
		<RpgExpandableCard
			id={`ritual-${ritual.entry.id}`}
			expanded={expanded}
			onToggle={onToggle}
			leading={<Icon aria-hidden="true" className="size-9" />}
			title={definition.name}
			subtitle={`${definition.circle}º círculo · ${details.label} · ${definition.source.kind === "official" ? "Oficial" : "Homebrew"}`}
			className={details.classes}
			summary={
				definition.tiers ? (
					<div className="grid grid-cols-3 gap-2">
						<TierSummary
							label="Normal"
							tier={definition.tiers.normal}
							onRoll={onRoll}
							ritualName={definition.name}
						/>
						<TierSummary
							label="Discente"
							tier={definition.tiers.discente}
							onRoll={onRoll}
							ritualName={definition.name}
						/>
						<TierSummary
							label="Verdadeiro"
							tier={definition.tiers.verdadeiro}
							onRoll={onRoll}
							ritualName={definition.name}
						/>
					</div>
				) : (
					<RpgStatChip label="Efeitos" value="Não cadastrados" />
				)
			}
		>
			<p className="text-sm leading-6 opacity-80">
				{definition.description || "Sem descrição."}
			</p>
			<dl className="grid gap-3 text-sm sm:grid-cols-2 lg:grid-cols-3">
				<div>
					<dt className="text-xs uppercase opacity-55">Execução</dt>
					<dd>{definition.execution || "—"}</dd>
				</div>
				<div>
					<dt className="text-xs uppercase opacity-55">Alcance</dt>
					<dd>{definition.rangeText || "—"}</dd>
				</div>
				<div>
					<dt className="text-xs uppercase opacity-55">Alvo</dt>
					<dd>{definition.targetText || "—"}</dd>
				</div>
				<div>
					<dt className="text-xs uppercase opacity-55">Área</dt>
					<dd>{definition.areaText || "—"}</dd>
				</div>
				<div>
					<dt className="text-xs uppercase opacity-55">Duração</dt>
					<dd>{definition.durationText || "—"}</dd>
				</div>
				<div>
					<dt className="text-xs uppercase opacity-55">Resistência</dt>
					<dd>{definition.resistanceText || "—"}</dd>
				</div>
			</dl>
			<div className="grid gap-3 lg:grid-cols-3">
				{definition.tiers ? (
					(["normal", "discente", "verdadeiro"] as const).map((key) => {
						const tier = definition.tiers?.[key];
						if (!tier) return null;
						return (
							<section
								key={key}
								className="space-y-3 rounded-lg border border-(--edge)/60 bg-(--surface-raised) p-3"
							>
								<h4 className="font-semibold capitalize">
									{key} · {tier.peCost} PE
								</h4>
								<p className="text-xs leading-5 opacity-75">{tier.effect}</p>
								<div className="flex flex-wrap gap-2">
									{tier.rolls.map((roll) => (
										<button
											key={`${roll.label}-${roll.expression}`}
											type="button"
											disabled={!parseDiceExpression(roll.expression)}
											onClick={() =>
												onRoll(
													`${definition.name} · ${roll.label}`,
													roll.expression,
												)
											}
											className="rounded-sm border border-white/20 px-3 py-2 font-mono text-xs hover:border-(--accent) focus-visible:outline-2 focus-visible:outline-(--accent) disabled:cursor-not-allowed disabled:opacity-50"
										>
											{roll.label}: {roll.expression}
										</button>
									))}
								</div>
							</section>
						);
					})
				) : (
					<p className="text-sm opacity-70">
						Os efeitos deste ritual ainda não estão cadastrados.
					</p>
				)}
			</div>
			<RpgInput
				label="Notas da ficha"
				value={notes}
				onChange={setNotes}
				onBlur={() => {
					if (notes !== ritual.entry.notes) onNotesChange(notes);
				}}
				multiline
				disabled={pending}
			/>
			<div className="flex flex-wrap gap-3 border-t border-white/15 pt-4">
				<RpgButton secondary disabled={pending} onClick={onEditDefinition}>
					{definition.source.kind === "official"
						? "Duplicar como homebrew"
						: "Editar homebrew"}
				</RpgButton>
				<RpgButton danger disabled={pending} onClick={onRemove}>
					Remover da ficha
				</RpgButton>
			</div>
		</RpgExpandableCard>
	);
}
