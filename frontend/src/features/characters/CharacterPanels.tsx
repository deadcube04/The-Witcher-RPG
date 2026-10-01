import { RpgSheetTabs } from "@/components/navigation/RpgSheetTabs";
import { RpgButton } from "@/components/primitives/RpgControls";
import type { CharacterInput } from "@/shared/contracts/character-sheet";
import { DiceRoller } from "@/features/dice/DiceRoller";
import { CharacterNarrative } from "@/features/characters/CharacterNarrative";
import { CharacterSkills } from "@/features/characters/CharacterSkills";
import type { CharacterSkill } from "@/shared/contracts/character-skill";
import { AttacksPanel } from "@/features/characters/ordem/content/AttacksPanel";
import { InventoryPanel } from "@/features/characters/ordem/content/InventoryPanel";
import { RitualsPanel } from "@/features/characters/ordem/content/RitualsPanel";
import { PowersPanel } from "@/features/characters/ordem/content/PowersPanel";
import { SupplementReferencePanel } from "@/features/characters/ordem/content/SupplementReferencePanel";

type Props = {
	character: CharacterInput;
	characterId: string;
	skills: CharacterSkill[];
	skillsStatus: "loading" | "error" | "ready";
	onSkillsRetry: () => void;
	onCharacterChange: (character: CharacterInput) => void;
	onSkillsChange: (skills: CharacterSkill[]) => void;
};

export function CharacterPanels({
	character,
	characterId,
	skills,
	skillsStatus,
	onSkillsRetry,
	onCharacterChange,
	onSkillsChange,
}: Props) {
	const ordem = character.systemData.kind === "ordem-paranormal";
	return (
		<section
			aria-label="Conteúdo da ficha"
			className="min-w-0 rounded-[2rem] bg-(--edge)/30 p-1"
		>
			<div className="min-w-0 rounded-[calc(2rem-0.25rem)] bg-(--surface)">
				<RpgSheetTabs
					items={[
						{
							key: "skills",
							label: "Perícias",
							children:
								skillsStatus === "loading" ? (
									<p role="status" className="py-8 text-sm text-(--muted)">
										Carregando perícias…
									</p>
								) : skillsStatus === "error" ? (
									<div role="alert" className="space-y-4 py-8 text-sm">
										<p>Não foi possível carregar as perícias.</p>
										<RpgButton secondary onClick={onSkillsRetry}>
											Tentar novamente
										</RpgButton>
									</div>
								) : (
									<CharacterSkills
										skills={skills}
										attributes={
											character.systemData.kind === "ordem-paranormal"
												? character.systemData.attributes
												: undefined
										}
										onChange={onSkillsChange}
									/>
								),
						},
						{
							key: "actions",
							label: "Ações",
							children: (
								<RpgSheetTabs
									secondary
									items={[
										{ key: "powers", label: "Poderes", children: character.systemData.kind === "ordem-paranormal" ? <PowersPanel characterId={characterId} progression={character.systemData} /> : <UnavailablePanel name="Poderes" /> },
										{
											key: "attacks",
											label: "Ataques",
											children: ordem ? (
												<AttacksPanel characterId={characterId} />
											) : (
												<UnavailablePanel name="Ataques" />
											),
										},
										{
											key: "rituals",
											label: "Rituais",
											children: ordem ? (
												<RitualsPanel characterId={characterId} />
											) : (
												<UnavailablePanel name="Rituais" />
											),
										},
										{ key: "dice", label: "Dados", children: <DiceRoller /> },
									]}
								/>
							),
						},
						{
							key: "inventory",
							label: "Inventário",
							children: ordem ? (
								<InventoryPanel characterId={characterId} />
							) : (
								<UnavailablePanel name="Inventário" />
							),
						},
						{
							key: "supplement-reference",
							label: "Suplemento",
							children: ordem ? <SupplementReferencePanel characterId={characterId} /> : <UnavailablePanel name="Suplemento" />,
						},
						{
							key: "narrative",
							label: "História",
							children: (
								<CharacterNarrative
									character={character}
									onChange={onCharacterChange}
								/>
							),
						},
					]}
				/>
			</div>
		</section>
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
