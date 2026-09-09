export async function bootstrap(): Promise<void> {
	if (import.meta.env.DEV) {
		const { worker } = await import("../../mocks/browser");
		await worker.start({ quiet: true, onUnhandledRequest: "bypass" });
	}
}
