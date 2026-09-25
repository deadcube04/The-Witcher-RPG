import archiveHero from "@/assets/archive/archive-hero.webp";
import fantasyObservatory from "@/assets/archive/fantasy-observatory.webp";
import ordemField from "@/assets/archive/ordem-field.webp";
import witcherField from "@/assets/archive/witcher-field.webp";

const artBySlug = {
	"ordem-paranormal": ordemField,
	dnd: fantasyObservatory,
	witcher: witcherField,
} as const;

export const archiveArt = {
	home: archiveHero,
	ordem: ordemField,
	fantasy: fantasyObservatory,
	witcher: witcherField,
} as const;

export function systemArt(slug?: string): string {
	return slug && slug in artBySlug
		? artBySlug[slug as keyof typeof artBySlug]
		: archiveHero;
}
