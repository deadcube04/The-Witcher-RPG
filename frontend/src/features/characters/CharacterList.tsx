import { Link } from "@tanstack/react-router";
import { RpgCard } from "../../components/data-display/RpgCard";
import { RpgEmptyState } from "../../components/feedback/RemoteState";
import type { CharacterSheet } from "../../shared/contracts/character-sheet";
import type { RpgSystem } from "../../shared/contracts/rpg-system";
import { CharacterDeleteAction } from "./CharacterDeleteAction";

export function CharacterList({
	characters,
	systems,
}: {
	characters: CharacterSheet[];
	systems: RpgSystem[];
}) {
	if (!characters.length)
		return (
			<RpgEmptyState title="Nenhuma ficha encontrada">
				<p>Ajuste os filtros ou dê vida a um novo personagem.</p>
				<Link to="/characters/new" className="underline">
					Criar ficha
				</Link>
			</RpgEmptyState>
		);
	return (
		<div className="grid gap-5 md:grid-cols-2">
			{characters.map((sheet) => (
				<RpgCard key={sheet.id}>
					<p className="mb-5 font-mono text-xs text-(--accent)">
						{systems.find((item) => item.id === sheet.systemId)?.name} /{" "}
						{sheet.campaignId ? "Em campanha" : "Standalone"}
					</p>
					<h3 className="text-2xl">
						<Link to={`/characters/${sheet.id}`}>{sheet.name}</Link>
					</h3>
					<p className="my-5 line-clamp-2 min-h-12 text-sm opacity-75">
						{sheet.description ||
							sheet.background ||
							"Toda história precisa de alguém para vivê-la."}
					</p>
					<div className="flex flex-wrap gap-5">
						<Link
							to={`/characters/${sheet.id}`}
							className="py-3 text-sm text-(--accent) underline"
						>
							Abrir ficha
						</Link>
						<Link
							to={`/characters/${sheet.id}/edit`}
							className="py-3 text-sm underline"
						>
							Editar
						</Link>
						<CharacterDeleteAction character={sheet} />
					</div>
				</RpgCard>
			))}
		</div>
	);
}
