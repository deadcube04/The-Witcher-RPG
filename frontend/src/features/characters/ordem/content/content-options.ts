import type { InventoryKind } from "@/shared/contracts/ordem-inventory";
import type { RitualElement } from "@/shared/contracts/ordem-ritual";

const inventoryKindLabels: Record<InventoryKind, string> = {
	weapon: "Arma",
	protection: "Proteção",
	ammunition: "Munição",
	accessory: "Acessório",
	equipment: "Equipamento",
	paranormal: "Paranormal",
	other: "Outro",
};

export const inventoryKindOptions = [
	{ value: "all", label: "Todos os tipos" },
	...Object.entries(inventoryKindLabels).map(([value, label]) => ({
		value,
		label,
	})),
];

export function inventoryKindLabel(kind: InventoryKind): string {
	return inventoryKindLabels[kind];
}

const ritualElementLabels: Record<RitualElement, string> = {
	blood: "Sangue",
	death: "Morte",
	knowledge: "Conhecimento",
	energy: "Energia",
	fear: "Medo",
};

export const ritualElementOptions = [
	{ value: "all", label: "Todos os elementos" },
	...Object.entries(ritualElementLabels).map(([value, label]) => ({
		value,
		label,
	})),
];

export function ritualElementLabel(element: RitualElement): string {
	return ritualElementLabels[element];
}
