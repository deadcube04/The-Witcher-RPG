export async function bootstrap(): Promise<void> {
	if (import.meta.env.VITE_API_MODE === "mock") {
		const { worker } = await import("../../mocks/browser");
		await worker.start({ quiet: true, onUnhandledRequest: "bypass" });
	}
}
