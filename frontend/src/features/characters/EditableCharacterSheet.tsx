import { Link } from "@tanstack/react-router";
import { type ReactNode, useState } from "react";
import type {
	CharacterInput,
	CharacterSheet,
} from "../../shared/contracts/character-sheet";
import { AutoSaveIndicator } from "./AutoSaveIndicator";
import { CharacterDeleteAction } from "./CharacterDeleteAction";
import { CharacterIdentity } from "./CharacterIdentity";
import { CharacterPanels } from "./CharacterPanels";
import { type CharacterSkill, createMockSkills } from "./character-skills";
import { useAutoSaveIndicator } from "./useAutoSaveIndicator";

type Props = {
	character: CharacterSheet;
	systemName: string;
	campaignReference: ReactNode;
};

function createDraft(character: CharacterSheet): CharacterInput {
	return {
		name: character.name,
		systemId: character.systemId,
		campaignId: character.campaignId,
		description: character.description,
		appearance: character.appearance,
		personality: character.personality,
		background: character.background,
		objective: character.objective,
		systemData: character.systemData,
	};
}

export function EditableCharacterSheet({
	character,
	systemName,
	campaignReference,
}: Props) {
	const [draft, setDraft] = useState<CharacterInput>(() =>
		createDraft(character),
	);
	const [skills, setSkills] = useState<CharacterSkill[]>(createMockSkills);
	const { status, markChanged } = useAutoSaveIndicator();
	const updateDraft = (next: CharacterInput) => {
		setDraft(next);
		markChanged();
	};
	const updateSkills = (next: CharacterSkill[]) => {
		setSkills(next);
		markChanged();
	};
	return (
		<div className="font-sans">
			<header className="sticky top-0 z-40 mb-4 flex h-15 min-w-0 items-center justify-between gap-2 border-b border-(--edge) bg-(--canvas)">
				<nav
					aria-label="Caminho da ficha"
					className="min-w-0 font-mono text-xs uppercase tracking-[0.24em] text-(--accent)"
				>
					<ol className="flex min-w-0 items-center gap-2">
						<li className="shrink-0">
							<Link
								to="/characters"
								className="inline-flex min-h-11 items-center hover:underline focus-visible:outline-2 focus-visible:outline-(--accent)"
							>
								Fichas
							</Link>
						</li>
						<li aria-hidden="true" className="opacity-50">
							/
						</li>
						<li
							aria-current="page"
							title={draft.name}
							className="truncate font-medium"
						>
							{draft.name || "Sem nome"}
						</li>
					</ol>
				</nav>
				<div className="flex shrink-0 items-center gap-1 sm:gap-2">
					<AutoSaveIndicator status={status} />
					<CharacterDeleteAction character={character} />
				</div>
			</header>
			<div className="grid min-w-0 gap-8 xl:grid-cols-[minmax(240px,300px)_minmax(0,1fr)]">
				<div className="min-w-0 xl:border-r xl:border-(--edge) xl:pr-7">
					<CharacterIdentity
						character={draft}
						systemName={systemName}
						onChange={updateDraft}
					/>
					<p className="mt-6 text-xs leading-6 opacity-70">
						{campaignReference}
					</p>
				</div>
				<div className="relative min-w-0">
					<CharacterPanels
						character={draft}
						skills={skills}
						onCharacterChange={updateDraft}
						onSkillsChange={updateSkills}
					/>
				</div>
			</div>
		</div>
	);
}
