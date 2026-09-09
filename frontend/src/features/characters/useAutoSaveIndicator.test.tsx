import { act, fireEvent, render, screen } from "@testing-library/react";
import { afterEach, expect, test, vi } from "vitest";
import { useAutoSaveIndicator } from "./useAutoSaveIndicator";

function Harness() {
	const { status, markChanged } = useAutoSaveIndicator();
	return (
		<>
			<button type="button" onClick={markChanged}>
				Editar
			</button>
			<span>{status}</span>
		</>
	);
}

afterEach(() => vi.useRealTimers());

test("marca alteração como pendente e conclui após um segundo sem edição", async () => {
	vi.useFakeTimers();
	render(<Harness />);

	fireEvent.click(screen.getByRole("button", { name: "Editar" }));
	expect(screen.getByText("pending")).toBeInTheDocument();
	act(() => vi.advanceTimersByTime(999));
	expect(screen.getByText("pending")).toBeInTheDocument();
	fireEvent.click(screen.getByRole("button", { name: "Editar" }));
	act(() => vi.advanceTimersByTime(1));
	expect(screen.getByText("pending")).toBeInTheDocument();
	act(() => vi.advanceTimersByTime(999));
	expect(screen.getByText("saved")).toBeInTheDocument();
});
