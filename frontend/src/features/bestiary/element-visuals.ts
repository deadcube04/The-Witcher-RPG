import sangueArt from "@/assets/bestiary/sangue.jpg";
import morteArt from "@/assets/bestiary/morte.jpg";
import conhecimentoArt from "@/assets/bestiary/conhecimento.jpg";
import energiaArt from "@/assets/bestiary/energia.jpg";
import medoArt from "@/assets/bestiary/medo.jpg";
import type { BestiaryElement } from "@/shared/contracts/bestiary";
import type { ThemeId } from "@/shared/contracts/preferences";

export type BestiaryElementKey =
	| "sangue"
	| "morte"
	| "conhecimento"
	| "energia"
	| "medo";

type ElementVisual = {
	name: string;
	mark: string;
	themeId: ThemeId;
	art: string;
	note: string;
	classes: string;
};

export const elementOrder: BestiaryElementKey[] = [
	"sangue",
	"morte",
	"conhecimento",
	"energia",
	"medo",
];

export const elementVisuals: Record<BestiaryElementKey, ElementVisual> = {
	sangue: {
		name: "Sangue",
		mark: "I / PULSO",
		themeId: "ordem-sangue",
		art: sangueArt,
		note: "Registros em que o impulso deixa marcas antes de qualquer resposta.",
		classes:
			"[--element:#f19a88] [--paper:#f2e7db] [--paper-ink:#301d1d] [--paper-muted:#665253] [--paper-rule:#c8aaa5]",
	},
	morte: {
		name: "Morte",
		mark: "II / VESTÍGIO",
		themeId: "ordem-morte",
		art: morteArt,
		note: "O tempo age sobre cada vestígio. Este capítulo reúne seus rastros.",
		classes:
			"[--element:#d0c9aa] [--paper:#eeeade] [--paper-ink:#272922] [--paper-muted:#5d6257] [--paper-rule:#b3b5a4]",
	},
	conhecimento: {
		name: "Conhecimento",
		mark: "III / ARQUIVO",
		themeId: "ordem-conhecimento",
		art: conhecimentoArt,
		note: "Documentos, sinais e nomes preservados para quem ousar lê-los.",
		classes:
			"[--element:#f0c66c] [--paper:#f3ebd6] [--paper-ink:#302718] [--paper-muted:#70634d] [--paper-rule:#cbb88e]",
	},
	energia: {
		name: "Energia",
		mark: "IV / SINAL",
		themeId: "ordem-energia",
		art: energiaArt,
		note: "Nenhum padrão é estável por muito tempo nestes registros.",
		classes:
			"[--element:#d5a2ff] [--paper:#ece7f0] [--paper-ink:#292334] [--paper-muted:#62596c] [--paper-rule:#b9acc7]",
	},
	medo: {
		name: "Medo",
		mark: "V / AUSÊNCIA",
		themeId: "ordem-medo",
		art: medoArt,
		note: "Há páginas em que a ausência diz mais do que o registro.",
		classes:
			"[--element:#e8e5df] [--paper:#efeeea] [--paper-ink:#27272a] [--paper-muted:#626167] [--paper-rule:#bdbbc0]",
	},
};

export function elementKeyFromName(
	name: string | null | undefined,
): BestiaryElementKey | null {
	const normalized = name
		?.normalize("NFD")
		.replace(/[\u0300-\u036f]/g, "")
		.toLocaleLowerCase("pt-BR");
	return elementOrder.find((key) => key === normalized) ?? null;
}

export function primaryElementKey(
	elements: BestiaryElement[],
): BestiaryElementKey | null {
	const primary = elements.find((element) => element.isPrimary) ?? elements[0];
	return elementKeyFromName(primary?.name);
}
