import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { useState } from "react";
import { expect, test } from "vitest";
import { RpgResourceBar } from "../data-display/RpgResourceBar";
import { RpgButton, RpgInput, RpgSelect } from "./RpgControls";

function Harness() {
	const [value, setValue] = useState("");
	return (
		<>
			<RpgInput label="Nome" value={value} onChange={setValue} />
			<RpgButton disabled={!value}>Salvar</RpgButton>
		</>
	);
}
test("campo acessível por label habilita a ação ao editar", async () => {
	render(<Harness />);
	expect(screen.getByRole("button", { name: "Salvar" })).toBeDisabled();
	await userEvent.type(screen.getByLabelText("Nome"), "Agente");
	expect(screen.getByRole("button", { name: "Salvar" })).toBeEnabled();
});

test("select aplica a scrollbar temática no dropdown aberto", async () => {
	render(
		<RpgSelect
			label="Tema"
			value="arquivo"
			onChange={() => {}}
			options={[
				{ value: "arquivo", label: "Arquivo" },
				{ value: "sangue", label: "Sangue" },
			]}
		/>,
	);

	await userEvent.click(screen.getByRole("combobox"));

	const dropdown = document.querySelector(".ant-select-dropdown");
	expect(dropdown).toHaveClass("[scrollbar-width:thin]");
	expect(dropdown).toHaveClass("[&::-webkit-scrollbar]:w-3");
	expect(dropdown).toHaveClass("ant-select-dropdown-placement-bottomLeft");
});

function ResourceHarness({ tone }: { tone: "health" | "effort" | "sanity" }) {
	const [value, setValue] = useState({ current: 6, maximum: 10 });
	return (
		<RpgResourceBar
			label="Recurso"
			tone={tone}
			{...value}
			onChange={setValue}
			editable
		/>
	);
}

test.each(["health", "effort", "sanity"] as const)(
	"barra %s funciona por teclado e limita os passos aos extremos",
	async (tone) => {
		render(<ResourceHarness tone={tone} />);
		const user = userEvent.setup();
		await user.tab();
		await user.keyboard("{Enter}");
		expect(screen.getByLabelText("Recurso atual")).toHaveDisplayValue("1");
		await user.click(
			screen.getByRole("button", { name: "Recurso: diminuir 5" }),
		);
		expect(screen.getByLabelText("Recurso atual")).toHaveDisplayValue("0");
		expect(
			screen.getByRole("button", { name: "Recurso: diminuir 1" }),
		).toBeDisabled();
		await user.click(
			screen.getByRole("button", { name: "Recurso: aumentar 5" }),
		);
		await user.click(
			screen.getByRole("button", { name: "Recurso: aumentar 5" }),
		);
		expect(screen.getByRole("progressbar")).toHaveAttribute(
			"aria-valuenow",
			"10",
		);
		expect(
			screen.getByRole("button", { name: "Recurso: aumentar 1" }),
		).toBeDisabled();
	},
);

test("barra sem edição mantém valores visíveis e controles desabilitados", () => {
	render(<RpgResourceBar label="Vida" tone="health" current={0} maximum={0} />);
	expect(screen.getByText("0 / 0")).toBeInTheDocument();
	expect(screen.queryByRole("spinbutton")).not.toBeInTheDocument();
	for (const button of screen.getAllByRole("button"))
		expect(button).toBeDisabled();
});
