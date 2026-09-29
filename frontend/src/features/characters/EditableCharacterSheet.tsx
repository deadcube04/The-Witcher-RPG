import { Link } from "@tanstack/react-router";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { useDebouncer } from "@tanstack/react-pacer";
import { type ReactNode, useEffect, useRef, useState } from "react";
import type {
	CharacterInput,
	CharacterSheet,
} from "@/shared/contracts/character-sheet";
import { AutoSaveIndicator } from "@/features/characters/AutoSaveIndicator";
import { CharacterDeleteAction } from "@/features/characters/CharacterDeleteAction";
import { CharacterIdentity } from "@/features/characters/CharacterIdentity";
import { CharacterPanels } from "@/features/characters/CharacterPanels";
import { characterSheetRegistry } from "@/features/characters/registry";
import type { CharacterSkill } from "@/shared/contracts/character-skill";
import { characterApi } from "@/shared/api/domains";
import { keys, queries } from "@/shared/api/queries";
import { OrdemHeaderStats } from "@/features/characters/ordem/OrdemHeaderStats";
import type { AutoSaveStatus } from "@/features/characters/useAutoSaveIndicator";

type Props = {
	character: CharacterSheet;
	systemName: string;
	campaignReference: ReactNode;
};

function createDraft(character: CharacterSheet): CharacterInput {
	return {
		name: character.name,
		imageUrl: character.imageUrl,
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
	const queryClient = useQueryClient();
	const skillsQuery = useQuery(queries.skills(character.id));
	const [skills, setSkills] = useState<CharacterSkill[]>([]);
	const [status, setStatus] = useState<AutoSaveStatus>("saved");
	const draftRef = useRef(draft);
	const skillsRef = useRef(skills);
	const versionRef = useRef(0);
	const queueRef = useRef<Promise<void>>(Promise.resolve());
	const initializedSkills = useRef(false);
	useEffect(() => {
		if (!initializedSkills.current && skillsQuery.data) {
			setSkills(skillsQuery.data);
			skillsRef.current = skillsQuery.data;
			initializedSkills.current = true;
		}
	}, [skillsQuery.data]);
	const saveDraft = useDebouncer(
		() => {
			const snapshot = draftRef.current;
			const version = versionRef.current;
			queueRef.current = queueRef.current.then(async () => {
				try {
					const saved = await characterApi.update(character.id, snapshot);
					queryClient.setQueryData(keys.character(character.id), saved);
					void queryClient.invalidateQueries({ queryKey: keys.characters });
					void queryClient.invalidateQueries({
						queryKey: keys.skills(character.id),
					});
					void queryClient.invalidateQueries({
						queryKey: keys.attacks(character.id),
					});
					if (version === versionRef.current) setStatus("saved");
				} catch {
					if (version === versionRef.current) setStatus("error");
				}
			});
		},
		{ wait: 700 },
	);
	const saveSkills = useDebouncer(
		() => {
			const snapshot = skillsRef.current;
			const version = versionRef.current;
			queueRef.current = queueRef.current.then(async () => {
				try {
					const saved = await characterApi.updateSkills(
						character.id,
						snapshot.map((skill) => ({
							id: skill.id,
							attributeId: skill.attributeId,
							trainingLevelId: skill.trainingLevelId,
							otherBonus: skill.otherBonus,
						})),
					);
					queryClient.setQueryData(keys.skills(character.id), saved);
					void queryClient.invalidateQueries({
						queryKey: keys.attacks(character.id),
					});
					if (version === versionRef.current) setStatus("saved");
				} catch {
					if (version === versionRef.current) setStatus("error");
				}
			});
		},
		{ wait: 700 },
	);
	const updateDraft = (next: CharacterInput) => {
		setDraft(next);
		draftRef.current = next;
		versionRef.current += 1;
		setStatus("pending");
		saveDraft.maybeExecute();
	};
	const updateSkills = (next: CharacterSkill[]) => {
		setSkills(next);
		skillsRef.current = next;
		versionRef.current += 1;
		setStatus("pending");
		saveSkills.maybeExecute();
	};
	const View = characterSheetRegistry.get(draft.systemData.kind)?.View;
	return (
		<div className="mx-auto max-w-[1480px] space-y-4 font-sans">
			<h1 className="sr-only">
				Ficha de {draft.name || "personagem sem nome"}
			</h1>
			<header className="flex min-w-0 items-center justify-between gap-3">
				<nav
					aria-label="Caminho da ficha"
					className="min-w-0 font-mono text-[11px] uppercase tracking-[0.18em] text-(--accent)"
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
							className="max-w-32 truncate font-medium sm:max-w-56"
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
			<div className="min-w-0 rounded-[2rem] bg-(--edge)/30 p-1">
				<div className="grid min-w-0 gap-5 rounded-[calc(2rem-0.25rem)] bg-(--surface) p-4 sm:p-5 lg:grid-cols-[minmax(0,1fr)_minmax(0,1.15fr)] lg:items-center">
					<CharacterIdentity
						character={draft}
						systemName={systemName}
						campaignReference={campaignReference}
						onChange={updateDraft}
					/>
					{draft.systemData.kind === "ordem-paranormal" && (
						<OrdemHeaderStats
							value={draft.systemData}
							onChange={(systemData) => updateDraft({ ...draft, systemData })}
						/>
					)}
				</div>
			</div>
			{View && (
				<View
					value={draft.systemData}
					onChange={(systemData) => updateDraft({ ...draft, systemData })}
				/>
			)}
			<div className="min-w-0">
				<CharacterPanels
					character={draft}
					characterId={character.id}
					skills={skills.length > 0 ? skills : (skillsQuery.data ?? [])}
					skillsStatus={
						skillsQuery.isPending
							? "loading"
							: skillsQuery.isError
								? "error"
								: "ready"
					}
					onSkillsRetry={() => void skillsQuery.refetch()}
					onCharacterChange={updateDraft}
					onSkillsChange={updateSkills}
				/>
			</div>
		</div>
	);
}
