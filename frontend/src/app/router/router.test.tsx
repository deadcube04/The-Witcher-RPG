import { createMemoryHistory, RouterProvider } from "@tanstack/react-router";
import { screen } from "@testing-library/react";
import { afterAll, beforeAll, expect, test } from "vitest";
import { renderFeature, testServer } from "../../test/render";
import { createAppRouter } from "./router";

beforeAll(() => testServer.listen({ onUnhandledRequest: "error" }));
afterAll(() => testServer.close());

test("mantém filtros e permite entrada direta em uma ficha", async () => {
	const router = createAppRouter(
		createMemoryHistory({
			initialEntries: [
				"/characters/e85e3e7c-ab09-479d-924a-e81575526681?systemId=ordem",
			],
		}),
	);
	await router.load();
	expect(router.state.matches.at(-1)?.params).toMatchObject({
		characterId: "e85e3e7c-ab09-479d-924a-e81575526681",
	});
	expect(router.state.location.search).toMatchObject({ systemId: "ordem" });
});
test("parâmetro malformado resulta em página não encontrada", async () => {
	const router = createAppRouter(
		createMemoryHistory({ initialEntries: ["/characters/invalid"] }),
	);
	renderFeature(<RouterProvider router={router} />);
	expect(
		await screen.findByRole("heading", { name: "Página não encontrada" }),
	).toBeInTheDocument();
});
