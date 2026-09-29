import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import "./index.css";
import App from "./App.tsx";

async function start(): Promise<void> {
	if ("serviceWorker" in navigator) {
		try {
			const registrations = await navigator.serviceWorker.getRegistrations();
			const previousWorkers = registrations.filter((registration) =>
				[registration.active, registration.waiting, registration.installing].some(
					(worker) => worker?.scriptURL.endsWith("/mockServiceWorker.js"),
				),
			);
			await Promise.all(previousWorkers.map((registration) => registration.unregister()));
			if (
				previousWorkers.length > 0 &&
				navigator.serviceWorker.controller?.scriptURL.endsWith(
					"/mockServiceWorker.js",
				)
			) {
				window.location.reload();
				return;
			}
		} catch {
			// O app continua usando a API mesmo se o navegador bloquear a limpeza.
		}
	}
	const root = document.getElementById("root");
	if (!root) throw new Error("Elemento raiz não encontrado");
	createRoot(root).render(
		<StrictMode>
			<App />
		</StrictMode>,
	);
}

void start();
