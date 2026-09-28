import { PhotoField } from "@/features/media/PhotoField";
import { RpgInput } from "@/components/primitives/RpgControls";
import type { CharacterInput } from "@/shared/contracts/character-sheet";
import { characterSheetRegistry } from "@/features/characters/registry";

export function CharacterIdentity({
	character,
	systemName,
	onChange,
}: {
	character: CharacterInput;
	systemName: string;
	onChange: (character: CharacterInput) => void;
}) {
	const View = characterSheetRegistry.get(character.systemData.kind)?.View;
	return (
		<section
			aria-label="Identidade do personagem"
			className="min-w-0 space-y-6"
		>
			<header className="space-y-4 border-b border-(--edge)/60 pb-5">
				<p className="text-xs font-semibold uppercase tracking-[0.16em] text-(--accent)">
					{systemName}
				</p>
				<RpgInput
					label="Nome do personagem"
					value={character.name}
					onChange={(name) => onChange({ ...character, name })}
				/>
			</header>
			<PhotoField purpose="character" value={character.imageUrl} onChange={(imageUrl) => onChange({ ...character, imageUrl })} />
			{View && (
				<View
					value={character.systemData}
					onChange={(systemData) => onChange({ ...character, systemData })}
				/>
			)}
		</section>
	);
}
