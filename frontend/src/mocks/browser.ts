import { setupWorker } from "msw/browser";
import { MockRepository } from "./database/repository";
import { createHandlers } from "./handlers";

export const worker = setupWorker(
	...createHandlers(new MockRepository(localStorage)),
);
