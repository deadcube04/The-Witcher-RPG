import { createContext, useContext, useEffect } from "react";
import type { BestiaryElementKey } from "@/features/bestiary/element-visuals";

type SetBestiaryElement = (element: BestiaryElementKey | null) => void;

export const BestiaryThemeContext = createContext<SetBestiaryElement | null>(
	null,
);

export function useBestiaryTheme(element: BestiaryElementKey | null) {
	const setElement = useContext(BestiaryThemeContext);
	useEffect(() => {
		setElement?.(element);
		return () => setElement?.(null);
	}, [element, setElement]);
}
