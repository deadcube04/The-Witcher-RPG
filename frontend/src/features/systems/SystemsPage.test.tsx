import { screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { afterAll, beforeAll, beforeEach, expect, test } from "vitest";
import { dndId } from "../../mocks/seed/seed";
import { preferencesApi } from "../../shared/api/domains";
import { renderFeature, testServer } from "../../test/render";
import { SystemsPage } from "./SystemsPage";

beforeAll(() => testServer.listen({ onUnhandledRequest: "error" }));
afterAll(() => testServer.close());
beforeEach(() => localStorage.clear());
test("seleciona sistema e persiste o novo contexto", async () => {
	renderFeature(<SystemsPage />);
	await userEvent.click(
		await screen.findByRole("button", {
			name: "Selecionar Dungeons & Dragons",
		}),
	);
	await screen.findByText("Alterações salvas.");
	expect((await preferencesApi.get()).activeSystemId).toBe(dndId);
});
