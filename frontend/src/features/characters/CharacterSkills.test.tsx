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
		</>
	);
}

test("edita atributo, treino e outros e recalcula o bônus atual", () => {
	render(<SkillsHarness />);

	fireEvent.mouseDown(
		screen.getByLabelText("Atributo modificador de Investigação"),
	);
	fireEvent.click(screen.getByRole("option", { name: "Vigor" }));
	fireEvent.change(screen.getByLabelText("Treino de Investigação"), {
		target: { value: "5" },
	});
	fireEvent.change(screen.getByLabelText("Outros de Investigação"), {
		target: { value: "-1" },
	});

	expect(
		screen.getByRole("status", { name: "Atributo atual" }),
	).toHaveTextContent("Vigor");
	expect(
		screen.getByRole("cell", { name: "Bônus atual de Investigação" }),
	).toHaveTextContent("+4");
});
