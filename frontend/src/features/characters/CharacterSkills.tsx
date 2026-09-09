import { GiDiceTwentyFacesTwenty } from "react-icons/gi";
import {
	RpgInlineNumber,
	RpgInlineSelect,
} from "../../components/primitives/RpgControls";
import { type CharacterSkill, modifierOptions } from "./character-skills";

export function CharacterSkills({
	skills,
	onChange,
}: {
	skills: CharacterSkill[];
	onChange: (skills: CharacterSkill[]) => void;
}) {
	const update = (
		id: string,
		change: Partial<Omit<CharacterSkill, "id" | "name">>,
	) => {
		onChange(
			skills.map((skill) =>
				skill.id === id ? { ...skill, ...change } : skill,
			),
		);
	};
	return (
		<section
			aria-label="Perícias"
			className="min-h-[560px] rounded-3xl border border-(--edge) bg-(--panel) p-5 md:p-7"
		>
			<h3 className="mb-5 border-b border-(--edge) pb-4 text-xl font-semibold">
				Perícias
			</h3>
			<div className="overflow-x-auto rounded-xl border border-(--edge)">
				<table className="w-full min-w-[680px] text-center text-sm">
					<thead className="border-b border-(--edge) bg-(--canvas) text-xs uppercase tracking-wider opacity-75">
						<tr>
							<th scope="col" className="px-4 py-3 font-semibold">
								Perícia
							</th>
							<th scope="col" className="px-4 py-3 font-semibold">
								Atributo modificador
							</th>
							<th scope="col" className="px-4 py-3 font-semibold">
								Bônus atual
							</th>
							<th scope="col" className="px-4 py-3 font-semibold">
								Treino
							</th>
							<th scope="col" className="px-4 py-3 font-semibold">
								Outros
							</th>
						</tr>
					</thead>
					<tbody className="divide-y divide-(--edge)">
						{skills.map((skill) => {
							const bonusAtual = skill.treino + skill.outros;
							return (
								<tr key={skill.id} className="bg-(--panel)">
									<th scope="row" className="px-4 py-3 font-normal">
										<span className="inline-flex items-center justify-center gap-3">
											<GiDiceTwentyFacesTwenty
												aria-hidden="true"
												className="size-5 shrink-0 text-(--accent)"
											/>
											{skill.name}
										</span>
									</th>
									<td className="px-4 py-3">
										<RpgInlineSelect
											label={`Atributo modificador de ${skill.name}`}
											value={skill.atributoModificador}
											onChange={(value) => {
												if (
													value === "Agilidade" ||
													value === "Força" ||
													value === "Intelecto" ||
													value === "Presença" ||
													value === "Vigor"
												)
													update(skill.id, { atributoModificador: value });
											}}
											options={modifierOptions}
										/>
									</td>
									<td
										aria-label={`Bônus atual de ${skill.name}`}
										className="px-4 py-3 font-mono font-semibold text-(--accent)"
									>
										{bonusAtual >= 0 ? "+" : ""}
										{bonusAtual}
									</td>
									<td className="px-4 py-3">
										<RpgInlineNumber
											label={`Treino de ${skill.name}`}
											value={skill.treino}
											onChange={(treino) => update(skill.id, { treino })}
											min={0}
											max={99}
										/>
									</td>
									<td className="px-4 py-3">
										<RpgInlineNumber
											label={`Outros de ${skill.name}`}
											value={skill.outros}
											onChange={(outros) => update(skill.id, { outros })}
											min={-99}
											max={99}
										/>
									</td>
								</tr>
							);
						})}
					</tbody>
				</table>
			</div>
		</section>
	);
}
