import { useState } from "react";
import { PiSwordThin } from "react-icons/pi";
import { RpgExpandableCard } from "@/components/data-display/RpgExpandableCard";
import { RpgStatChip } from "@/components/data-display/RpgStatChip";
import { RpgButton, RpgInput } from "@/components/primitives/RpgControls";
import type { CharacterAttack } from "@/shared/contracts/ordem-attack";
import { parseDiceExpression } from "@/features/dice/roll";

export function AttackCard({
	attack,
	expanded,
	pending,
	onToggle,
	onRoll,
	onNotesChange,
	onEditDefinition,
	onRemove,
}: {
	attack: CharacterAttack;
	expanded: boolean;
	pending: boolean;
	onToggle: () => void;
	onRoll: (label: string, expression: string) => void;
	onNotesChange: (notes: string) => void;
	onEditDefinition: () => void;
	onRemove: () => void;
}) {
	const [notes, setNotes] = useState(attack.entry.notes);
	const definition = attack.definition;
	return (
		<RpgExpandableCard
			id={`attack-${attack.entry.id}`}
			expanded={expanded}
			onToggle={onToggle}
			leading={<PiSwordThin aria-hidden="true" />}
			title={definition.name}
			subtitle={`${attack.sourceInventory?.name ?? "Ataque independente"} · ${definition.source.kind === "official" ? "Oficial" : "Homebrew"}`}
			summary={
				<div className="grid grid-cols-3 gap-2">
					<RpgStatChip
						label="Ataque"
						value={definition.testExpression}
						onActivate={
							parseDiceExpression(definition.testExpression)
								? () =>
										onRoll(
											`Ataque · ${definition.name}`,
											definition.testExpression,
										)
								: undefined
						}
					/>
					<RpgStatChip
						label="Dano"
						value={definition.damageExpression}
						onActivate={
							parseDiceExpression(definition.damageExpression)
								? () =>
										onRoll(
											`Dano · ${definition.name}`,
											definition.damageExpression,
										)
								: undefined
						}
					/>
					<RpgStatChip
						label="Crítico"
						value={`${definition.criticalThreshold}/x${definition.criticalMultiplier}`}
					/>
				</div>
			}
		>
			<p className="text-sm leading-6 opacity-75">
				{definition.description || "Sem descrição."}
			</p>
			<dl className="grid gap-3 text-sm sm:grid-cols-2">
				<div>
					<dt className="text-xs uppercase opacity-55">Perícia</dt>
					<dd>{definition.skillName}</dd>
				</div>
				<div>
					<dt className="text-xs uppercase opacity-55">Tipo de dano</dt>
					<dd>{definition.damageType || "—"}</dd>
				</div>
				<div>
					<dt className="text-xs uppercase opacity-55">Alcance</dt>
					<dd>{definition.rangeText || "—"}</dd>
				</div>
				<div>
					<dt className="text-xs uppercase opacity-55">Arma vinculada</dt>
					<dd>{attack.sourceInventory?.name ?? "Nenhuma"}</dd>
				</div>
			</dl>
			{definition.special ? (
				<p className="border-l-2 border-(--accent) pl-3 text-sm">
					{definition.special}
				</p>
			) : null}
			<RpgInput
				label="Notas da ficha"
				value={notes}
				onChange={setNotes}
				onBlur={() => {
					if (notes !== attack.entry.notes) onNotesChange(notes);
				}}
				multiline
				disabled={pending}
			/>
			<div className="flex flex-wrap gap-3 border-t border-(--edge) pt-4">
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
