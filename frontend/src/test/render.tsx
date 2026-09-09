import { QueryClientProvider } from "@tanstack/react-query";
import { render } from "@testing-library/react";
import { setupServer } from "msw/node";
import type { ReactNode } from "react";
import { createQueryClient } from "../app/providers/query-client";
import { MockRepository } from "../mocks/database/repository";
import { createHandlers } from "../mocks/handlers";

export const testServer = setupServer(
	...createHandlers(new MockRepository(localStorage)),
);
export function renderFeature(children: ReactNode) {
	const client = createQueryClient();
	client.setDefaultOptions({ queries: { retry: false } });
	return {
		...render(
			<QueryClientProvider client={client}>{children}</QueryClientProvider>,
		),
		client,
	};
}
