import { createMemoryHistory, RouterProvider } from "@tanstack/react-router";
import { act, fireEvent, screen } from "@testing-library/react";
import {
	afterAll,
	afterEach,
	beforeAll,
	beforeEach,
	expect,
	test,
	vi,
} from "vitest";
import { createAppRouter } from "../../app/router/router";
import { characterApi } from "../../shared/api/domains";
import { renderFeature, testServer } from "../../test/render";

const characterId = "e85e3e7c-ab09-479d-924a-e81575526681";

beforeAll(() => testServer.listen({ onUnhandledRequest: "error" }));
afterAll(() => testServer.close());
beforeEach(() => localStorage.clear());
afterEach(() => vi.useRealTimers());

test("edita a ficha localmente e atualiza o indicador após o debounce", async () => {
	const router = createAppRouter(
		createMemoryHistory({ initialEntries: [`/characters/${characterId}`] }),
	);
	renderFeature(<RouterProvider router={router} />);

	const name = await screen.findByLabelText("Nome do personagem");
	const breadcrumb = screen.getByRole("navigation", {
		name: "Caminho da ficha",
	});
	expect(breadcrumb).toHaveTextContent("Helena Vasconcelos");
	expect(breadcrumb).toHaveClass(
		"font-mono",
		"text-xs",
		"uppercase",
		"tracking-[0.24em]",
		"text-(--accent)",
	);
	expect(breadcrumb.closest("header")).toHaveClass("z-40");
	for (const link of screen.getAllByRole("link", { name: "Fichas" }))
		expect(link).toHaveAttribute("href", "/characters");
	expect(screen.getByRole("status")).toHaveTextContent("Salvo");
	const strength = screen.getByLabelText("Força");
	expect(
		screen.queryByRole("link", { name: "Editar ficha" }),
	).not.toBeInTheDocument();
	expect(screen.queryByLabelText("NEX (%)")).not.toBeInTheDocument();
	expect(strength).toHaveDisplayValue("1");
	expect(screen.getByLabelText("Vida atual")).toBeInTheDocument();
	expect(screen.getByLabelText("Vida máxima")).toBeInTheDocument();
	expect(screen.getByLabelText("Sanidade atual")).toBeInTheDocument();
	expect(screen.getByLabelText("Sanidade máxima")).toBeInTheDocument();
	expect(screen.getByLabelText("Esforço atual")).toBeInTheDocument();
	expect(screen.getByLabelText("Esforço máxima")).toBeInTheDocument();
	expect(screen.getByRole("region", { name: "Recursos" })).toBeInTheDocument();
	expect(screen.getAllByRole("progressbar")).toHaveLength(3);
	expect(
		screen.getByRole("heading", { name: "Atributos" }),
	).toBeInTheDocument();
	expect(screen.getByLabelText("Histórico")).toBeInTheDocument();
	expect(screen.queryByLabelText("Sistema da ficha")).not.toBeInTheDocument();
	expect(screen.queryByLabelText("Campanha")).not.toBeInTheDocument();

	vi.useFakeTimers();
	fireEvent.change(screen.getByLabelText("Vida máxima"), {
		target: { value: "45" },
	});
	fireEvent.change(screen.getByLabelText("Vida atual"), {
		target: { value: "28" },
	});
	fireEvent.click(screen.getByRole("button", { name: "Vida: diminuir 5" }));
	expect(screen.getByLabelText("Vida atual")).toHaveDisplayValue("23");
	fireEvent.click(screen.getByRole("button", { name: "Vida: aumentar 1" }));
	expect(screen.getByLabelText("Vida atual")).toHaveDisplayValue("24");
	fireEvent.change(screen.getByLabelText("Vida máxima"), {
		target: { value: "20" },
	});
	expect(screen.getByLabelText("Vida atual")).toHaveDisplayValue("20");
	expect(screen.getByRole("progressbar", { name: "Vida" })).toHaveAttribute(
		"aria-valuenow",
		"20",
	);
	expect(
		screen.getByRole("button", { name: "Vida: aumentar 5" }),
	).toBeDisabled();
	fireEvent.change(screen.getByLabelText("Vida atual"), {
		target: { value: "0" },
	});
	expect(
		screen.getByRole("button", { name: "Vida: diminuir 1" }),
	).toBeDisabled();
	fireEvent.change(screen.getByLabelText("Sanidade máxima"), {
		target: { value: "30" },
	});
	fireEvent.change(screen.getByLabelText("Sanidade atual"), {
		target: { value: "24" },
	});
	fireEvent.change(screen.getByLabelText("Esforço máxima"), {
		target: { value: "18" },
	});
	fireEvent.change(screen.getByLabelText("Esforço atual"), {
		target: { value: "12" },
	});
	for (const [label, value] of [
		["Agilidade", "2"],
		["Força", "3"],
		["Intelecto", "4"],
		["Presença", "5"],
		["Vigor", "2"],
	] as const) {
		fireEvent.change(screen.getByLabelText(label), { target: { value } });
		expect(screen.getByLabelText(label)).toHaveDisplayValue(value);
	}
	fireEvent.change(strength, { target: { value: "3" } });
	expect(strength).toHaveDisplayValue("3");
	expect(
		screen.getByRole("status", { name: "Atualizando alterações locais" }),
	).toBeInTheDocument();
	fireEvent.change(name, { target: { value: "Helena editada" } });
	expect(
		screen.getByRole("navigation", { name: "Caminho da ficha" }),
	).toHaveTextContent("Helena editada");
	expect(
		screen.getByRole("status", { name: "Atualizando alterações locais" }),
	).toBeInTheDocument();
	act(() => vi.advanceTimersByTime(999));
	expect(
		screen.getByRole("status", { name: "Atualizando alterações locais" }),
	).toBeInTheDocument();
	act(() => vi.advanceTimersByTime(1));
	expect(
		screen.getByRole("status", { name: "Alterações locais atualizadas" }),
	).toBeInTheDocument();
	vi.useRealTimers();
	expect((await characterApi.get(characterId)).name).toBe("Helena Vasconcelos");
}, 15_000);

test("abre a exclusão pelo menu e permite cancelar sem remover a ficha", async () => {
	const router = createAppRouter(
		createMemoryHistory({ initialEntries: [`/characters/${characterId}`] }),
	);
	renderFeature(<RouterProvider router={router} />);
	await screen.findByLabelText("Nome do personagem");
	expect(
		screen.queryByRole("button", { name: "Excluir" }),
	).not.toBeInTheDocument();
	fireEvent.click(screen.getByRole("button", { name: "Mais ações da ficha" }));
	fireEvent.click(await screen.findByRole("menuitem", { name: "Excluir" }));
	expect(await screen.findByRole("dialog")).toHaveTextContent(
		"Excluir Helena Vasconcelos?",
	);
	fireEvent.click(screen.getByRole("button", { name: "Cancelar" }));
	expect((await characterApi.get(characterId)).name).toBe("Helena Vasconcelos");
}, 15_000);
