import type { MockDatabase } from "@/mocks/database/repository";
import type { ContentSource } from "@/shared/contracts/content-source";
import { fail } from "@/mocks/handlers/common";

export function routeId(value: string | readonly string[] | undefined): string {
	return typeof value === "string" ? value : fail("INVALID_REQUEST");
}

export function ownedCharacter(state: MockDatabase, id: string) {
	return (
		state.characters.find(
			(character) => character.id === id && character.ownerId === state.user.id,
		) ?? fail("CHARACTER_NOT_FOUND")
	);
}

export function visibleSource(source: ContentSource, ownerId: string): boolean {
	return source.kind === "official" || source.ownerId === ownerId;
}

export function ordemSystemId(state: MockDatabase): string {
	return (
		state.systems.find((system) => system.slug === "ordem-paranormal")?.id ??
		fail("RPG_SYSTEM_NOT_FOUND")
	);
}

export function normalized(value: string): string {
	return value
		.normalize("NFD")
		.replace(/[\u0300-\u036f]/g, "")
		.toLocaleLowerCase("pt-BR");
}
