import type { ReactNode } from "react";
import { PhotoField } from "@/features/media/PhotoField";
import { RpgInput } from "@/components/primitives/RpgControls";
import type { CharacterInput } from "@/shared/contracts/character-sheet";

export function CharacterIdentity({
	character,
	systemName,
	campaignReference,
	onChange,
}: {
	character: CharacterInput;
	systemName: string;
	campaignReference: ReactNode;
	onChange: (character: CharacterInput) => void;
}) {
	return (
		<section
			aria-label="Identidade do personagem"
			className="grid min-w-0 gap-4 sm:grid-cols-[auto_minmax(0,1fr)] sm:items-center"
		>
			<PhotoField
				compact
				purpose="character"
				value={character.imageUrl}
				onChange={(imageUrl) => onChange({ ...character, imageUrl })}
			/>
			<div className="min-w-0 space-y-2">
				<p className="font-mono text-[11px] uppercase tracking-[0.2em] text-(--accent)">
					{systemName}
				</p>
				<div className="max-w-xs">
					<RpgInput
						label="Nome do personagem"
						value={character.name}
						onChange={(name) => onChange({ ...character, name })}
					/>
				</div>
				<p className="truncate text-xs text-(--muted)">{campaignReference}</p>
			</div>
		</section>
	);
}
