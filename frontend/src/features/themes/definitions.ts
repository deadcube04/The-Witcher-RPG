import type { ThemeId } from "@/shared/contracts/preferences";

export type ThemeDefinition = {
	id: ThemeId;
	name: string;
	description: string;
	mode?: "light" | "dark";
	classes: string;
	decoration: string;
	mark: string;
	duration: number;
	offset: number;
	palette: {
		accent: string;
		canvas: string;
		surface: string;
		surfaceRaised: string;
		ink: string;
		muted: string;
		edge: string;
		danger: string;
		success: string;
	};
};
export type ResolvedTheme = Omit<ThemeDefinition, "id"> & {
	id: ThemeId | "neutral";
};
export const defaultTheme = {
	id: "neutral",
	name: "Arquivo",
	description: "Uma base digital para qualquer história.",
	classes:
		"[--accent:#a8f58b] [--media-accent:#a8f58b] [--canvas:#080d10] [--panel:#111a1f] [--surface:#111a1f] [--surface-raised:#18252b] [--ink:#edf6f3] [--muted:#9bada9] [--edge:#294149] [--danger:#ff8178] [--success:#a8f58b] [--shadow:#02050699] [--scrim:#071014] [scrollbar-color:var(--edge)_var(--canvas)] [scrollbar-width:thin] [&::-webkit-scrollbar]:w-3 [&::-webkit-scrollbar-track]:bg-(--canvas) [&::-webkit-scrollbar-thumb]:bg-(--edge) [&::-webkit-scrollbar-thumb:hover]:bg-(--accent) [--on-accent:var(--canvas)] font-sans",
	decoration:
		"border border-dashed border-(--accent) shadow-[6px_6px_0_#335967] bg-[linear-gradient(#33596733_1px,transparent_1px),linear-gradient(90deg,#33596733_1px,transparent_1px)] bg-size-[24px_24px]",
	mark: "00 / LOCAL",
	duration: 0.2,
	offset: 6,
	palette: {
		accent: "#a8f58b",
		canvas: "#080d10",
		surface: "#111a1f",
		surfaceRaised: "#18252b",
		ink: "#edf6f3",
		muted: "#9bada9",
		edge: "#294149",
		danger: "#ff8178",
		success: "#a8f58b",
	},
} satisfies ResolvedTheme;
export const themes: ThemeDefinition[] = [
	{
		id: "ordem-sangue",
		name: "Sangue",
		description: "O impulso precede a razão. Cortes, contraste e matéria viva.",
		classes:
			"[--accent:#ff8676] [--media-accent:#ff8676] [--canvas:#160d0e] [--panel:#241214] [--surface:#241214] [--surface-raised:#32191c] [--ink:#ffe9e3] [--muted:#c6aaa6] [--edge:#603236] [--danger:#ff8676] [--success:#b6df9d] [--shadow:#08030499] [--scrim:#120708] [scrollbar-color:var(--edge)_var(--canvas)] [scrollbar-width:thin] [&::-webkit-scrollbar]:w-3 [&::-webkit-scrollbar-track]:bg-(--canvas) [&::-webkit-scrollbar-thumb]:bg-(--edge) [&::-webkit-scrollbar-thumb:hover]:bg-(--accent) [--on-accent:var(--canvas)] font-sans",
		decoration:
			"border-l-[12px] border-l-(--accent) rounded-tr-[5rem] bg-[radial-gradient(ellipse_at_top_right,#661c2e,transparent_65%)]",
		mark: "I / PULSO",
		duration: 0.16,
		offset: 14,
		palette: {
			accent: "#ff8676",
			canvas: "#160d0e",
			surface: "#241214",
			surfaceRaised: "#32191c",
			ink: "#ffe9e3",
			muted: "#c6aaa6",
			edge: "#603236",
			danger: "#ff8676",
			success: "#b6df9d",
		},
	},
	{
		id: "ordem-morte",
		name: "Morte",
		description: "O tempo consome tudo. Camadas, vestígios e espirais.",
		classes:
			"[--accent:#c7c0a3] [--media-accent:#c7c0a3] [--canvas:#10120f] [--panel:#1d201a] [--surface:#1d201a] [--surface-raised:#292d24] [--ink:#edeedf] [--muted:#afb0a2] [--edge:#4e5343] [--danger:#e27d72] [--success:#b8cf9b] [--shadow:#05060499] [--scrim:#0b0d0a] [scrollbar-color:var(--edge)_var(--canvas)] [scrollbar-width:thin] [&::-webkit-scrollbar]:w-3 [&::-webkit-scrollbar-track]:bg-(--canvas) [&::-webkit-scrollbar-thumb]:bg-(--edge) [&::-webkit-scrollbar-thumb:hover]:bg-(--accent) [--on-accent:var(--canvas)] font-sans",
		decoration:
			"border-double border-4 border-(--edge) rounded-tl-[4rem] bg-[repeating-radial-gradient(circle_at_90%_50%,transparent_0px,transparent_20px,#4e534322_21px,#4e534322_23px)]",
		mark: "II / VESTÍGIO",
		duration: 0.55,
		offset: 3,
		palette: {
			accent: "#c7c0a3",
			canvas: "#10120f",
			surface: "#1d201a",
			surfaceRaised: "#292d24",
			ink: "#edeedf",
			muted: "#afb0a2",
			edge: "#4e5343",
			danger: "#e27d72",
			success: "#b8cf9b",
		},
	},
	{
		id: "ordem-conhecimento",
		name: "Conhecimento",
		description:
			"Todo registro guarda um segredo. Documentos, margens e sinais.",
		classes:
			"[--accent:#f0c66c] [--media-accent:#f0c66c] [--canvas:#17150f] [--panel:#252116] [--surface:#252116] [--surface-raised:#332c1d] [--ink:#f5edda] [--muted:#bcb09a] [--edge:#655431] [--danger:#e98274] [--success:#bed795] [--shadow:#08070399] [--scrim:#121008] [scrollbar-color:var(--edge)_var(--canvas)] [scrollbar-width:thin] [&::-webkit-scrollbar]:w-3 [&::-webkit-scrollbar-track]:bg-(--canvas) [&::-webkit-scrollbar-thumb]:bg-(--edge) [&::-webkit-scrollbar-thumb:hover]:bg-(--accent) [--on-accent:var(--canvas)] font-sans",
		decoration:
			"border-y-4 border-double border-(--accent) bg-[repeating-linear-gradient(0deg,transparent_0px,transparent_31px,#65543144_32px)]",
		mark: "III / ARQUIVO",
		duration: 0.24,
		offset: 0,
		palette: {
			accent: "#f0c66c",
			canvas: "#17150f",
			surface: "#252116",
			surfaceRaised: "#332c1d",
			ink: "#f5edda",
			muted: "#bcb09a",
			edge: "#655431",
			danger: "#e98274",
			success: "#bed795",
		},
	},
	{
		id: "ordem-energia",
		name: "Energia",
		description:
			"Nada permanece estável. Sinais digitais e deslocamentos precisos.",
		classes:
			"[--accent:#c77dff] [--media-accent:#c77dff] [--canvas:#100817] [--panel:#20102b] [--surface:#20102b] [--surface-raised:#2d173c] [--ink:#f5e9ff] [--muted:#b9a4c6] [--edge:#70418c] [--danger:#ff7b8d] [--success:#a9da9b] [--shadow:#05020899] [--scrim:#0b0510] [scrollbar-color:var(--edge)_var(--canvas)] [scrollbar-width:thin] [&::-webkit-scrollbar]:w-3 [&::-webkit-scrollbar-track]:bg-(--canvas) [&::-webkit-scrollbar-thumb]:bg-(--edge) [&::-webkit-scrollbar-thumb:hover]:bg-(--accent) [--on-accent:var(--canvas)] font-sans",
		decoration:
			"border border-dashed border-(--accent) shadow-[6px_6px_0_#70418c] bg-[linear-gradient(#70418c33_1px,transparent_1px),linear-gradient(90deg,#70418c33_1px,transparent_1px)] bg-size-[24px_24px]",
		mark: "IV / SINAL",
		duration: 0.12,
		offset: 6,
		palette: {
			accent: "#c77dff",
			canvas: "#100817",
			surface: "#20102b",
			surfaceRaised: "#2d173c",
			ink: "#f5e9ff",
			muted: "#b9a4c6",
			edge: "#70418c",
			danger: "#ff7b8d",
			success: "#a9da9b",
		},
	},
	{
		id: "ordem-medo",
		name: "Medo",
		description: "O que você não vê também está aqui. Silêncio e espaço.",
		classes:
			"[--accent:#e0dfda] [--media-accent:#e0dfda] [--canvas:#101012] [--panel:#19191d] [--surface:#19191d] [--surface-raised:#232329] [--ink:#f1f0ed] [--muted:#aaa9a6] [--edge:#45454e] [--danger:#e6827b] [--success:#b3d29f] [--shadow:#04040599] [--scrim:#0b0b0d] [scrollbar-color:var(--edge)_var(--canvas)] [scrollbar-width:thin] [&::-webkit-scrollbar]:w-3 [&::-webkit-scrollbar-track]:bg-(--canvas) [&::-webkit-scrollbar-thumb]:bg-(--edge) [&::-webkit-scrollbar-thumb:hover]:bg-(--accent) [--on-accent:var(--canvas)] font-sans",
		decoration:
			"border-t border-(--ink) bg-[radial-gradient(ellipse_at_bottom,#ffffff0a,transparent_70%)]",
		mark: "V / AUSÊNCIA",
		duration: 0.7,
		offset: 0,
		palette: {
			accent: "#e0dfda",
			canvas: "#101012",
			surface: "#19191d",
			surfaceRaised: "#232329",
			ink: "#f1f0ed",
			muted: "#aaa9a6",
			edge: "#45454e",
			danger: "#e6827b",
			success: "#b3d29f",
		},
	},
];
export const nexusDark = {
	id: "nexus",
	name: "NEXUS Escuro",
	mode: "dark",
	description:
		"Grafite e prata, com azul elétrico para conectar suas histórias.",
	classes:
		"[--accent:#78a9ff] [--media-accent:#78a9ff] [--canvas:#0f1117] [--panel:#181c26] [--surface:#181c26] [--surface-raised:#222838] [--ink:#f0f2f8] [--muted:#b1b8c9] [--edge:#59647b] [--danger:#ff9a9f] [--success:#83d7ad] [--shadow:#090b1226] [--scrim:#0f1117] [--on-accent:#0f1117] [color-scheme:dark] [scrollbar-color:var(--edge)_var(--canvas)] [scrollbar-width:thin] font-sans",
	decoration:
		"border border-(--edge)/50 rounded-2xl bg-[radial-gradient(ellipse_at_top_right,#8b5cf614,transparent_65%)]",
	mark: "NEXUS",
	duration: 0.2,
	offset: 6,
	palette: {
		accent: "#78a9ff",
		canvas: "#0f1117",
		surface: "#181c26",
		surfaceRaised: "#222838",
		ink: "#f0f2f8",
		muted: "#b1b8c9",
		edge: "#59647b",
		danger: "#ff9a9f",
		success: "#83d7ad",
	},
} satisfies ResolvedTheme;
export const nexusLight = {
	...nexusDark,
	name: "NEXUS Claro",
	mode: "light",
	description:
		"Superfícies claras, prata e detalhes celestiais para suas histórias.",
	classes:
		"[--accent:#245bc0] [--media-accent:#78a9ff] [--canvas:#f5f6fa] [--panel:#fcfcfe] [--surface:#fcfcfe] [--surface-raised:#e9edf5] [--ink:#0f1117] [--muted:#535e73] [--edge:#818a9e] [--danger:#b32940] [--success:#216841] [--shadow:#2533500d] [--scrim:#0f1117] [--on-accent:#fcfcfe] [color-scheme:light] [scrollbar-color:var(--edge)_var(--canvas)] [scrollbar-width:thin] font-sans",
	palette: {
		accent: "#245bc0",
		canvas: "#f5f6fa",
		surface: "#fcfcfe",
		surfaceRaised: "#e9edf5",
		ink: "#0f1117",
		muted: "#535e73",
		edge: "#818a9e",
		danger: "#b32940",
		success: "#216841",
	},
} satisfies ResolvedTheme;

export function resolveTheme(
	id: ThemeId | null,
	mode: "light" | "dark" = "dark",
): ResolvedTheme {
	if (id === "nexus") return mode === "light" ? nexusLight : nexusDark;
	if (id === null) return defaultTheme;
	const theme = themes.find((entry) => entry.id === id);
	if (!theme) throw new Error("Tema padrão indisponível");
	return theme;
}
