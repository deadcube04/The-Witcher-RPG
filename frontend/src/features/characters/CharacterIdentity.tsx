import { PiUserCircleThin } from "react-icons/pi";
import { RpgInput } from "../../components/primitives/RpgControls";
import type { CharacterInput } from "../../shared/contracts/character-sheet";
import { characterSheetRegistry } from "./registry";

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
			<div className="mx-auto flex aspect-square w-full max-w-56 items-center justify-center rounded-full border border-(--accent)/50 bg-(--surface) shadow-[0_0_70px_color-mix(in_srgb,var(--accent)_12%,transparent)]">
				<PiUserCircleThin
					aria-hidden="true"
					className="size-32 text-(--accent)"
				/>
				<span className="sr-only">Retrato não cadastrado</span>
			</div>
			{View && (
				<View
					value={character.systemData}
					onChange={(systemData) => onChange({ ...character, systemData })}
				/>
			)}
		</section>
	);
}
