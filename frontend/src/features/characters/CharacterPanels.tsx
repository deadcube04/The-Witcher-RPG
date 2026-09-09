import {
	GiBackpack,
	GiCrossedSwords,
	GiDiceTwentyFacesTwenty,
	GiSpellBook,
} from "react-icons/gi";
import { RpgSheetDrawers } from "../../components/navigation/RpgSheetDrawers";
import type { CharacterInput } from "../../shared/contracts/character-sheet";
import { DiceRoller } from "../dice/DiceRoller";
import { CharacterNarrative } from "./CharacterNarrative";
import { CharacterSkills } from "./CharacterSkills";
import type { CharacterSkill } from "./character-skills";

export function CharacterPanels({
	character,
	skills,
	onCharacterChange,
	onSkillsChange,
}: {
	character: CharacterInput;
	skills: CharacterSkill[];
	onCharacterChange: (character: CharacterInput) => void;
	onSkillsChange: (skills: CharacterSkill[]) => void;
}) {
	return (
		<div className="space-y-8">
			<div className="relative min-h-[560px]">
				<div className="pr-[calc(clamp(72px,7vw,112px)+1rem)]">
					<CharacterSkills skills={skills} onChange={onSkillsChange} />
				</div>
				<RpgSheetDrawers
					items={[
						{
							key: "inventory",
							label: "Inventário",
							icon: <GiBackpack aria-hidden="true" />,
							children: <UnavailablePanel name="Inventário" />,
						},
						{
							key: "rituals",
							label: "Rituais",
							icon: <GiSpellBook aria-hidden="true" />,
							children: <UnavailablePanel name="Rituais" />,
						},
						{
							key: "attacks",
							label: "Ataques",
							icon: <GiCrossedSwords aria-hidden="true" />,
							children: <UnavailablePanel name="Ataques" />,
						},
						{
							key: "dice",
							label: "Dados",
							icon: <GiDiceTwentyFacesTwenty aria-hidden="true" />,
							children: <DiceRoller />,
						},
					]}
				/>
			</div>
			<CharacterNarrative character={character} onChange={onCharacterChange} />
		</div>
	);
}
function UnavailablePanel({ name }: { name: string }) {
	return (
		<div className="rounded-xl border border-dashed border-(--edge) bg-(--canvas) p-6 text-sm leading-7 text-(--ink)">
			<p className="font-semibold">{name} ainda não disponível</p>
			<p className="mt-2 opacity-65">
				Esta seção ainda não faz parte dos dados da ficha nesta versão.
			</p>
		</div>
	);
}
