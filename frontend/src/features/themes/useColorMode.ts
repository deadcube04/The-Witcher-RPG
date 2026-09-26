import { useSyncExternalStore } from "react";
import type { ColorMode } from "@/shared/contracts/preferences";

const query = "(prefers-color-scheme: dark)";
function subscribe(callback: () => void): () => void {
	const media = window.matchMedia(query);
	media.addEventListener("change", callback);
	return () => media.removeEventListener("change", callback);
}
function getSnapshot(): boolean {
	return window.matchMedia(query).matches;
}
export function useColorMode(mode: ColorMode): "light" | "dark" {
	const dark = useSyncExternalStore(subscribe, getSnapshot);
	return mode === "system" ? (dark ? "dark" : "light") : mode;
}
