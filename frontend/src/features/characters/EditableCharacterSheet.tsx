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
	const saveDraft = useDebouncer(() => {
		const snapshot = draftRef.current;
		const version = versionRef.current;
		queueRef.current = queueRef.current.then(async () => {
			try {
				const saved = await characterApi.update(character.id, snapshot);
				queryClient.setQueryData(keys.character(character.id), saved);
				void queryClient.invalidateQueries({ queryKey: keys.characters });
				void queryClient.invalidateQueries({ queryKey: keys.skills(character.id) });
				void queryClient.invalidateQueries({ queryKey: keys.attacks(character.id) });
				if (version === versionRef.current) setStatus("saved");
			} catch {
				if (version === versionRef.current) setStatus("error");
			}
		});
	}, { wait: 700 });
	const saveSkills = useDebouncer(() => {
		const snapshot = skillsRef.current;
		const version = versionRef.current;
		queueRef.current = queueRef.current.then(async () => {
			try {
				const saved = await characterApi.updateSkills(character.id, snapshot.map((skill) => ({ id: skill.id, attributeId: skill.attributeId, trainingLevelId: skill.trainingLevelId, otherBonus: skill.otherBonus })));
				queryClient.setQueryData(keys.skills(character.id), saved);
				void queryClient.invalidateQueries({ queryKey: keys.attacks(character.id) });
				if (version === versionRef.current) setStatus("saved");
			} catch {
				if (version === versionRef.current) setStatus("error");
			}
		});
	}, { wait: 700 });
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
	return (
		<div className="font-sans">
			<header className="sticky top-0 z-40 mb-4 min-w-0 bg-(--canvas)">
				<div className="flex min-h-15 min-w-0 items-center justify-between gap-2 rounded-b-2xl border-b border-(--edge)/60 bg-(--canvas)/95 px-2 shadow-[0_16px_40px_var(--shadow)]">
					<nav
						aria-label="Caminho da ficha"
						className="min-w-0 shrink-0 font-mono text-xs uppercase tracking-[0.24em] text-(--accent)"
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
				</div>
			</header>
			<div className="grid min-w-0 gap-8 xl:grid-cols-[minmax(240px,300px)_minmax(0,1fr)]">
				<div className="min-w-0 rounded-3xl border border-(--edge)/60 bg-(--surface)/55 p-5 xl:sticky xl:top-20 xl:h-fit xl:p-6">
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
					{draft.systemData.kind === "ordem-paranormal" && (
						<OrdemHeaderStats
							value={draft.systemData}
							onChange={(systemData) => updateDraft({ ...draft, systemData })}
						/>
					)}
						{skillsQuery.isPending && <p role="status">Carregando perícias…</p>}
						{skillsQuery.isError && <p role="alert">Não foi possível carregar as perícias.</p>}
						<CharacterPanels
						character={draft}
						characterId={character.id}
						skills={skills}
						onCharacterChange={updateDraft}
						onSkillsChange={updateSkills}
					/>
				</div>
			</div>
		</div>
	);
}
