import { fireEvent, render, screen, within } from "@testing-library/react";
import { expect, test } from "vitest";
import { createOrdemData } from "../../../shared/contracts/defaults";
import { OrdemHeaderStats } from "./OrdemHeaderStats";

test("exibe os dados resumidos na ordem do cabeçalho", () => {
	const value = {
		...createOrdemData(),
		nex: 35,
		classId: "d2222c7e-59c7-4b37-83da-b65ab68e594b",
		originId: "2e972664-8ec6-4cd2-9fa7-c74cf278d7fd",
		creditLimit: "ALTO" as const,
	};

	render(<OrdemHeaderStats value={value} />);

	const stats = screen.getByRole("region", { name: "Resumo da ficha" });
	expect(
		within(stats)
			.getAllByRole("term")
			.map((term) => term.textContent),
	).toEqual(["NEX", "Classe", "Origem", "Crédito", "Deslocamento"]);
	expect(stats).toHaveTextContent("35%");
	expect(stats).toHaveTextContent("Combatente");
	expect(stats).toHaveTextContent("Acadêmico");
	expect(stats).toHaveTextContent("ALTO");
	expect(stats).toHaveTextContent("9m / 6q");
});

test("permite editar o NEX pelas opções disponíveis", () => {
	const value = createOrdemData();
	let nextValue = value;

	render(
		<OrdemHeaderStats
			value={value}
			onChange={(next) => {
				nextValue = next;
			}}
		/>,
	);

	fireEvent.mouseDown(screen.getByLabelText("NEX"));
	fireEvent.click(screen.getByRole("option", { name: "35%" }));

	expect(nextValue.nex).toBe(35);
});

test("permite editar o crédito pelas opções disponíveis", () => {
	const value = createOrdemData();
	let nextValue = value;

	render(
		<OrdemHeaderStats
			value={value}
			onChange={(next) => {
				nextValue = next;
			}}
		/>,
	);

	fireEvent.mouseDown(screen.getByLabelText("Crédito"));
	fireEvent.click(screen.getByRole("option", { name: "Alto" }));

	expect(nextValue.creditLimit).toBe("ALTO");
});
