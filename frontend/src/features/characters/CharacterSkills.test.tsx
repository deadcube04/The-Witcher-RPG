import { fireEvent, render, screen } from "@testing-library/react";
import { useState } from "react";
import { expect, test } from "vitest";
import { CharacterSkills } from "./CharacterSkills";
import { type CharacterSkill, createMockSkills } from "./character-skills";

function SkillsHarness() {
	const [skills, setSkills] = useState<CharacterSkill[]>(createMockSkills);
	return (
		<>
			<CharacterSkills skills={skills} onChange={setSkills} />
			<output aria-label="Atributo atual">
				{skills[0]?.atributoModificador}
			</output>
			<output aria-label="Treino atual">{skills[0]?.treino}</output>
		</>
	);
}

test("edita atributo, nível e outros e recalcula o bônus atual", () => {
	render(<SkillsHarness />);

	fireEvent.mouseDown(
		screen.getByLabelText("Atributo modificador de Investigação"),
	);
	fireEvent.click(screen.getByRole("option", { name: "Vigor" }));
	fireEvent.mouseDown(
		screen.getByLabelText("Nível de treinamento de Investigação"),
	);
	fireEvent.click(screen.getByRole("option", { name: "Veterano" }));
	fireEvent.change(screen.getByLabelText("Outros de Investigação"), {
		target: { value: "-1" },
	});

	expect(
		screen.getByRole("status", { name: "Atributo atual" }),
	).toHaveTextContent("Vigor");
	expect(
		screen.getByRole("cell", { name: "Bônus atual de Investigação" }),
	).toHaveTextContent("+9");
	expect(screen.getByRole("status", { name: "Treino atual" })).toHaveTextContent(
		"10",
	);
});

test("mantém os ícones da coluna de perícia alinhados", () => {
	render(<SkillsHarness />);

	const skillRows = screen.getAllByRole("row").slice(1);

	for (const row of skillRows) {
		const skillCell = row.querySelector("th");
		const skillContent = skillCell?.querySelector("span");

		expect(skillContent).toHaveClass(
			"grid",
			"w-full",
			"max-w-56",
			"mx-auto",
			"grid-cols-[1.25rem_1fr]",
		);
	}
});

test("não exibe a coluna de treino", () => {
	render(<SkillsHarness />);

	expect(screen.queryByRole("columnheader", { name: "Treino" })).not.toBeInTheDocument();
});
