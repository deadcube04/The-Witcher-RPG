import { useQuery } from "@tanstack/react-query";
import { useState } from "react";
import { PiDiceFiveThin } from "react-icons/pi";
import {
	RpgInlineNumber,
	RpgInlineSelect,
	RpgInput,
} from "@/components/primitives/RpgControls";
import { useRpgRollFeedback } from "@/components/feedback/RpgRollFeedback";
import { rollOrdemTest } from "@/features/dice/roll";
import { queries } from "@/shared/api/queries";
import type { CharacterSkill } from "@/shared/contracts/character-skill";
import type { OrdemData } from "@/shared/contracts/character-sheet";
import { matchesName } from "@/shared/lib/search";

const attributeNames: Record<string, string> = {
	agilidade: "Agilidade",
	forca: "Força",
	intelecto: "Intelecto",
	presenca: "Presença",
	vigor: "Vigor",
};
function rollParameters(
	skill: CharacterSkill,
	attributes?: OrdemData["attributes"],
) {
	if (!attributes)
		return { diceCount: skill.diceCount, keep: skill.keep, bonus: skill.bonus };
	let value: number;
	switch (skill.attributeSlug) {
		case "agilidade":
			value = attributes.agility;
			break;
		case "forca":
			value = attributes.strength;
			break;
		case "intelecto":
			value = attributes.intellect;
			break;
		case "presenca":
			value = attributes.presence;
			break;
		case "vigor":
			value = attributes.vigor;
			break;
		default:
			return {
				diceCount: skill.diceCount,
				keep: skill.keep,
				bonus: skill.bonus,
			};
	}
	return {
		diceCount: value === 0 ? 2 : value,
		keep: value === 0 ? ("lowest" as const) : ("highest" as const),
		bonus: skill.bonus,
	};
}

export function CharacterSkills({
	skills,
	attributes,
	onChange,
}: {
	skills: CharacterSkill[];
	attributes?: OrdemData["attributes"];
	onChange: (skills: CharacterSkill[]) => void;
}) {
	const options = useQuery(queries.characterOptions);
	const feedback = useRpgRollFeedback();
	const [search, setSearch] = useState("");
	const visibleSkills = skills.filter((skill) =>
		matchesName(skill.name, search),
	);
	const update = (id: string, change: Partial<CharacterSkill>) => {
		onChange(
			skills.map((skill) =>
				skill.id === id ? { ...skill, ...change } : skill,
			),
		);
	};
	return (
		<section aria-label="Perícias" className="min-w-0">
			{feedback.holder}
			<div className="mb-4">
				<div className="w-full sm:w-64">
					<RpgInput
						label="Buscar perícia"
						value={search}
						onChange={setSearch}
					/>
				</div>
			</div>
			{options.error && (
				<p role="alert" className="mb-4 text-sm">
					Não foi possível carregar as opções das perícias.
				</p>
			)}
			{visibleSkills.length === 0 ? (
				<div className="rounded-2xl bg-(--panel) px-5 py-10 text-center text-sm text-(--muted)">
					{skills.length === 0
						? "Nenhuma perícia disponível nesta ficha."
						: "Nenhuma perícia corresponde à busca."}
				</div>
			) : (
				<div
					className="min-w-0 overflow-x-auto rounded-2xl ring-1 ring-(--edge)/50"
					role="region"
					aria-label="Tabela de perícias"
					tabIndex={0}
				>
					<table className="w-full min-w-[640px] text-center text-sm">
						<thead className="bg-(--canvas) text-[11px] uppercase tracking-wider text-(--muted)">
							<tr>
								<th scope="col" className="px-3 py-2.5 font-semibold">
									Perícia
								</th>
								<th scope="col" className="px-3 py-2.5 font-semibold">
									Atributo
								</th>
								<th scope="col" className="px-3 py-2.5 font-semibold">
									Treinamento
								</th>
								<th scope="col" className="px-3 py-2.5 font-semibold">
									Bônus
								</th>
								<th scope="col" className="px-3 py-2.5 font-semibold">
									Outros
								</th>
							</tr>
						</thead>
						<tbody className="divide-y divide-(--edge)/35">
							{visibleSkills.map((skill) => (
								<tr key={skill.id} className="bg-(--panel)">
									<th scope="row" className="px-3 py-1.5 font-normal">
										<span className="mx-auto grid w-full max-w-56 grid-cols-[1.25rem_1fr] items-center gap-2 text-left">
											<button
												type="button"
												aria-label={`Rolar ${skill.name}`}
												onClick={() =>
													feedback.show(
														skill.name,
														rollOrdemTest(rollParameters(skill, attributes)),
													)
												}
												className="rounded-sm text-(--accent) focus-visible:outline-2 focus-visible:outline-(--accent)"
											>
												<PiDiceFiveThin aria-hidden="true" className="size-5" />
											</button>
											<span>{skill.name}</span>
										</span>
									</th>
									<td className="px-3 py-1.5">
										<RpgInlineSelect
											label={`Atributo de ${skill.name}`}
											value={skill.attributeId}
											options={(options.data?.attributes ?? []).map(
												(entry) => ({
													value: entry.id,
													label: attributeNames[entry.slug] ?? entry.name,
												}),
											)}
											onChange={(attributeId) => {
												const attribute = options.data?.attributes.find(
													(entry) => entry.id === attributeId,
												);
												if (attribute)
													update(skill.id, {
														attributeId,
														attributeSlug: attribute.slug,
													});
											}}
										/>
									</td>
									<td className="px-3 py-1.5">
										<RpgInlineSelect
											label={`Treinamento de ${skill.name}`}
											value={skill.trainingLevelId ?? ""}
											options={[
												{ value: "", label: "Leigo" },
												...(
													options.data?.trainingLevels.filter(
														(entry) => entry.bonus > 0,
													) ?? []
												).map((entry) => ({
													value: entry.id,
													label: entry.name,
												})),
											]}
											onChange={(trainingLevelId) => {
												const level = options.data?.trainingLevels.find(
													(entry) => entry.id === trainingLevelId,
												);
												const trainingBonus = level?.bonus ?? 0;
												update(skill.id, {
													trainingLevelId: trainingLevelId || null,
													trainingName: level?.name ?? "Leigo",
													trainingBonus,
													bonus: trainingBonus + skill.otherBonus,
												});
											}}
										/>
									</td>
									<td
										aria-label={`Bônus de ${skill.name}`}
										className="px-3 py-1.5 font-mono font-semibold text-(--accent)"
									>
										{skill.bonus >= 0 ? "+" : ""}
										{skill.bonus}
									</td>
									<td className="px-3 py-1.5">
										<RpgInlineNumber
											label={`Outros de ${skill.name}`}
											value={skill.otherBonus}
											min={-99}
											max={99}
											onChange={(otherBonus) =>
												update(skill.id, {
													otherBonus,
													bonus: skill.trainingBonus + otherBonus,
												})
											}
										/>
									</td>
								</tr>
							))}
						</tbody>
					</table>
				</div>
			)}
		</section>
	);
}
