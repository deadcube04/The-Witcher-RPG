import { useState } from "react";
import type { IconType } from "react-icons";
import {
	PiBackpackThin,
	PiCubeThin,
	PiDiamondThin,
	PiShieldThin,
	PiSwordThin,
	PiToolboxThin,
	PiTargetThin,
} from "react-icons/pi";
import { RpgExpandableCard } from "@/components/data-display/RpgExpandableCard";
import { RpgStatChip } from "@/components/data-display/RpgStatChip";
import {
	RpgButton,
	RpgCheckbox,
	RpgInput,
} from "@/components/primitives/RpgControls";
import type {
	CharacterInventoryItem,
	InventoryEntryPatch,
	InventoryKind,
} from "@/shared/contracts/ordem-inventory";
import { parseDiceExpression } from "@/features/dice/roll";

const kindDetails: Record<InventoryKind, { label: string; icon: IconType }> = {
	weapon: { label: "Arma", icon: PiSwordThin },
	protection: { label: "Proteção", icon: PiShieldThin },
	ammunition: { label: "Munição", icon: PiTargetThin },
	accessory: { label: "Acessório", icon: PiToolboxThin },
	equipment: { label: "Equipamento", icon: PiBackpackThin },
	paranormal: { label: "Paranormal", icon: PiDiamondThin },
	other: { label: "Outro", icon: PiCubeThin },
};

export function InventoryCard({
	item,
	expanded,
	pending,
	onToggle,
	onUpdate,
	onRemove,
	onCreateAttack,
	onEditDefinition,
	onRoll,
}: {
	item: CharacterInventoryItem;
	expanded: boolean;
	pending: boolean;
	onToggle: () => void;
	onUpdate: (input: InventoryEntryPatch) => void;
	onRemove: () => void;
	onCreateAttack: () => void;
	onEditDefinition: () => void;
	onRoll: (label: string, expression: string) => void;
}) {
	const [notes, setNotes] = useState(item.entry.notes);
	const definition = item.definition;
	const details = kindDetails[definition.kind];
	const Icon = details.icon;
	const category =
		definition.category === null ? "—" : String(definition.category);
	return (
		<RpgExpandableCard
			id={`inventory-${item.entry.id}`}
			expanded={expanded}
			onToggle={onToggle}
			leading={<Icon aria-hidden="true" />}
			title={definition.name}
			subtitle={`${details.label} · ${definition.source.kind === "official" ? "Oficial" : "Homebrew"}`}
			summary={
				<div className="grid grid-cols-3 gap-2 sm:grid-cols-4">
					<RpgStatChip label="Categoria" value={category} />
					<RpgStatChip label="Quantidade" value={String(item.entry.quantity)} />
					<RpgStatChip
						label="Espaços"
						value={String(definition.spaces * item.entry.quantity)}
					/>
					<div className="hidden sm:block">
						<RpgStatChip
							label="Estado"
							value={item.entry.equipped ? "Equipado" : "Guardado"}
						/>
					</div>
				</div>
			}
		>
			<p className="text-sm leading-6 opacity-75">
				{definition.description || "Sem descrição."}
			</p>
			{definition.kind === "weapon" ? (
				<div className="grid grid-cols-2 gap-2 sm:grid-cols-4">
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
					<RpgStatChip label="Alcance" value={definition.rangeText || "—"} />
					<RpgStatChip label="Tipo" value={definition.damageType || "—"} />
				</div>
			) : null}
			<div className="flex flex-wrap items-center gap-3">
				<RpgButton
					secondary
					disabled={pending || item.entry.quantity <= 1}
					onClick={() => onUpdate({ quantity: item.entry.quantity - 1 })}
				>
					−
				</RpgButton>
				<span className="min-w-8 text-center font-mono">
					{item.entry.quantity}
				</span>
				<RpgButton
					secondary
					disabled={pending || item.entry.quantity >= 999}
					onClick={() => onUpdate({ quantity: item.entry.quantity + 1 })}
				>
					+
				</RpgButton>
				<RpgCheckbox
					label="Equipado"
					checked={item.entry.equipped}
					onChange={(equipped) => onUpdate({ equipped })}
					disabled={pending}
				/>
			</div>
			<RpgInput
				label="Notas da ficha"
				value={notes}
				onChange={setNotes}
				onBlur={() => {
					if (notes !== item.entry.notes) onUpdate({ notes });
				}}
				multiline
				disabled={pending}
			/>
			<div className="flex flex-wrap gap-3 border-t border-(--edge) pt-4">
				{definition.kind === "weapon" ? (
					<RpgButton
						secondary
						disabled={pending || item.linkedAttackCount > 0}
						onClick={onCreateAttack}
					>
						{item.linkedAttackCount > 0 ? "Ataque vinculado" : "Criar ataque"}
					</RpgButton>
				) : null}
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
