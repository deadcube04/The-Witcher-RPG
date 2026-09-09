import { useDebouncer } from "@tanstack/react-pacer";
import { useState } from "react";

export type AutoSaveStatus = "saved" | "pending";

export function useAutoSaveIndicator() {
	const [status, setStatus] = useState<AutoSaveStatus>("saved");
	const debouncer = useDebouncer(() => setStatus("saved"), { wait: 1000 });
	const markChanged = () => {
		setStatus("pending");
		debouncer.maybeExecute();
	};
	return { status, markChanged };
}
