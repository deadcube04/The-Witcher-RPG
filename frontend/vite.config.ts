import { readFileSync } from "node:fs";
import { createRequire } from "node:module";
import tailwindcss from "@tailwindcss/vite";
import react from "@vitejs/plugin-react";
import { defineConfig } from "vite";
import { fileURLToPath, URL } from "node:url";

const require = createRequire(import.meta.url);
const workerSource = () =>
	readFileSync(require.resolve("msw/mockServiceWorker.js"), "utf8");

// https://vite.dev/config/
export default defineConfig({
	resolve: {
		alias: { "@": fileURLToPath(new URL("./src", import.meta.url)) },
	},
	plugins: [
		react(),
		tailwindcss(),
		{
			name: "local-msw-worker",
			configureServer(server) {
				server.middlewares.use(
					"/mockServiceWorker.js",
					(_request, response) => {
						response.setHeader("Content-Type", "text/javascript");
						response.end(workerSource());
					},
				);
			},
		},
	],
});
