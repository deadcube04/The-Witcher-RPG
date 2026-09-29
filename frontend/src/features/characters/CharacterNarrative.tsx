import { RpgInput } from "@/components/primitives/RpgControls";
import type { CharacterInput } from "@/shared/contracts/character-sheet";

const fields = [
	{ key: "description", label: "Descrição" },
	{ key: "appearance", label: "Aparência" },
	{ key: "personality", label: "Personalidade" },
	{ key: "background", label: "Histórico" },
	{ key: "objective", label: "Objetivo" },
] as const;

export function CharacterNarrative({
	character,
	onChange,
}: {
	character: CharacterInput;
	onChange: (character: CharacterInput) => void;
}) {
	return (
		<section className="space-y-4">
			<h2 className="text-xl font-semibold">História do personagem</h2>
			<div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
				{fields.map((field) => (
					<RpgInput
						key={field.key}
						label={field.label}
						multiline
						value={character[field.key]}
						onChange={(value) => onChange({ ...character, [field.key]: value })}
					/>
				))}
			</div>
		</section>
	);
}
