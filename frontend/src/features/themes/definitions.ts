import type { ThemeId } from "../../shared/contracts/preferences";

export type ThemeDefinition = {
	id: ThemeId;
	name: string;
	description: string;
	classes: string;
	decoration: string;
	mark: string;
	duration: number;
	offset: number;
	palette: {
		accent: string;
		background: string;
		panel: string;
		ink: string;
		edge: string;
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
		"[--accent:#9fe87b] [--canvas:#0b1217] [--panel:#14212a] [--ink:#e1f2f6] [--edge:#335967] [scrollbar-color:var(--edge)_var(--canvas)] [scrollbar-width:thin] [&::-webkit-scrollbar]:w-3 [&::-webkit-scrollbar-track]:bg-(--canvas) [&::-webkit-scrollbar-thumb]:bg-(--edge) [&::-webkit-scrollbar-thumb:hover]:bg-(--accent) font-mono",
	decoration:
		"border border-dashed border-(--accent) shadow-[6px_6px_0_#335967] bg-[linear-gradient(#33596733_1px,transparent_1px),linear-gradient(90deg,#33596733_1px,transparent_1px)] bg-size-[24px_24px]",
	mark: "00 / LOCAL",
	duration: 0.2,
	offset: 6,
	palette: {
		accent: "#9fe87b",
		background: "#0b1217",
		panel: "#14212a",
		ink: "#e1f2f6",
		edge: "#335967",
	},
} satisfies ResolvedTheme;
export const themes: ThemeDefinition[] = [
	{
		id: "ordem-sangue",
		name: "Sangue",
		description: "O impulso precede a razão. Cortes, contraste e matéria viva.",
		classes:
			"[--accent:#ff8676] [--canvas:#160d0e] [--panel:#241214] [--ink:#ffe9e3] [--edge:#603236] [scrollbar-color:var(--edge)_var(--canvas)] [scrollbar-width:thin] [&::-webkit-scrollbar]:w-3 [&::-webkit-scrollbar-track]:bg-(--canvas) [&::-webkit-scrollbar-thumb]:bg-(--edge) [&::-webkit-scrollbar-thumb:hover]:bg-(--accent) font-sans",
		decoration:
			"border-l-[12px] border-l-(--accent) rounded-tr-[5rem] bg-[radial-gradient(ellipse_at_top_right,#661c2e,transparent_65%)]",
		mark: "I / PULSO",
		duration: 0.16,
		offset: 14,
		palette: {
			accent: "#ff8676",
			background: "#160d0e",
			panel: "#241214",
			ink: "#ffe9e3",
			edge: "#603236",
		},
	},
	{
		id: "ordem-morte",
		name: "Morte",
		description: "O tempo consome tudo. Camadas, vestígios e espirais.",
		classes:
			"[--accent:#c7c0a3] [--canvas:#10120f] [--panel:#1d201a] [--ink:#edeedf] [--edge:#4e5343] [scrollbar-color:var(--edge)_var(--canvas)] [scrollbar-width:thin] [&::-webkit-scrollbar]:w-3 [&::-webkit-scrollbar-track]:bg-(--canvas) [&::-webkit-scrollbar-thumb]:bg-(--edge) [&::-webkit-scrollbar-thumb:hover]:bg-(--accent) font-serif",
		decoration:
			"border-double border-4 border-(--edge) rounded-tl-[4rem] bg-[repeating-radial-gradient(circle_at_90%_50%,transparent_0px,transparent_20px,#4e534322_21px,#4e534322_23px)]",
		mark: "II / VESTÍGIO",
		duration: 0.55,
		offset: 3,
		palette: {
			accent: "#c7c0a3",
			background: "#10120f",
			panel: "#1d201a",
			ink: "#edeedf",
			edge: "#4e5343",
		},
	},
	{
		id: "ordem-conhecimento",
		name: "Conhecimento",
		description:
			"Todo registro guarda um segredo. Documentos, margens e sinais.",
		classes:
			"[--accent:#f0c66c] [--canvas:#17150f] [--panel:#252116] [--ink:#f5edda] [--edge:#655431] [scrollbar-color:var(--edge)_var(--canvas)] [scrollbar-width:thin] [&::-webkit-scrollbar]:w-3 [&::-webkit-scrollbar-track]:bg-(--canvas) [&::-webkit-scrollbar-thumb]:bg-(--edge) [&::-webkit-scrollbar-thumb:hover]:bg-(--accent) font-serif",
		decoration:
			"border-y-4 border-double border-(--accent) bg-[repeating-linear-gradient(0deg,transparent_0px,transparent_31px,#65543144_32px)]",
		mark: "III / ARQUIVO",
		duration: 0.24,
		offset: 0,
		palette: {
			accent: "#f0c66c",
			background: "#17150f",
			panel: "#252116",
			ink: "#f5edda",
			edge: "#655431",
		},
	},
	{
		id: "ordem-energia",
		name: "Energia",
		description:
			"Nada permanece estável. Sinais digitais e deslocamentos precisos.",
		classes:
			"[--accent:#c77dff] [--canvas:#100817] [--panel:#20102b] [--ink:#f5e9ff] [--edge:#70418c] [scrollbar-color:var(--edge)_var(--canvas)] [scrollbar-width:thin] [&::-webkit-scrollbar]:w-3 [&::-webkit-scrollbar-track]:bg-(--canvas) [&::-webkit-scrollbar-thumb]:bg-(--edge) [&::-webkit-scrollbar-thumb:hover]:bg-(--accent) font-mono",
		decoration:
			"border border-dashed border-(--accent) shadow-[6px_6px_0_#70418c] bg-[linear-gradient(#70418c33_1px,transparent_1px),linear-gradient(90deg,#70418c33_1px,transparent_1px)] bg-size-[24px_24px]",
		mark: "IV / SINAL",
		duration: 0.12,
		offset: 6,
		palette: {
			accent: "#c77dff",
			background: "#100817",
			panel: "#20102b",
			ink: "#f5e9ff",
			edge: "#70418c",
		},
	},
	{
		id: "ordem-medo",
		name: "Medo",
		description: "O que você não vê também está aqui. Silêncio e espaço.",
		classes:
			"[--accent:#e0dfda] [--canvas:#101012] [--panel:#19191d] [--ink:#f1f0ed] [--edge:#45454e] [scrollbar-color:var(--edge)_var(--canvas)] [scrollbar-width:thin] [&::-webkit-scrollbar]:w-3 [&::-webkit-scrollbar-track]:bg-(--canvas) [&::-webkit-scrollbar-thumb]:bg-(--edge) [&::-webkit-scrollbar-thumb:hover]:bg-(--accent) font-sans",
		decoration:
			"border-t border-(--ink) bg-[radial-gradient(ellipse_at_bottom,#ffffff0a,transparent_70%)]",
		mark: "V / AUSÊNCIA",
		duration: 0.7,
		offset: 0,
		palette: {
			accent: "#e0dfda",
			background: "#101012",
			panel: "#19191d",
			ink: "#f1f0ed",
			edge: "#45454e",
		},
	},
];
export function resolveTheme(id: ThemeId | null): ResolvedTheme {
	if (id === null) return defaultTheme;
	const theme = themes.find((entry) => entry.id === id);
	if (!theme) throw new Error("Tema padrão indisponível");
	return theme;
}
