import { RpgButton } from "@/components/primitives/RpgControls";
import { RpgVisualProvider } from "@/components/primitives/RpgVisualProvider";
import type { ResolvedTheme } from "@/features/themes/definitions";

type Props = {
	theme: ResolvedTheme;
	active: boolean;
	pending: boolean;
	unavailable?: boolean;
	onSelect: () => void;
};
export function ThemeChoiceCard({
	theme,
	active,
	pending,
	unavailable = false,
	onSelect,
}: Props) {
	return (
		<section
			aria-label={theme.name}
			className={
				theme.classes +
				" flex flex-col overflow-hidden rounded-3xl border border-(--edge)/70 bg-(--canvas) p-2 text-(--ink) shadow-[0_22px_70px_var(--shadow)]"
			}
		>
			<div
				aria-hidden="true"
				className={
					"relative mb-2 flex min-h-40 items-center justify-between overflow-hidden p-6 " +
					theme.decoration
				}
			>
				<div>
					<span className="font-mono text-[10px] tracking-widest">
						{theme.mark}
					</span>
					<p className="mt-3 font-serif text-3xl">{theme.name}</p>
				</div>
				{theme.id === "nexus" ? (
					<img src="/brand/nexus-symbol.svg" alt="" className="size-24" />
				) : (
					<div className="grid w-20 gap-2">
						<span className="h-2 rounded bg-(--accent)" />
						<span className="h-2 w-14 rounded bg-(--muted)" />
						<span className="h-2 w-10 rounded bg-(--edge)" />
					</div>
				)}
			</div>
			<div className="flex grow flex-col p-4">
				<p className="text-xs font-semibold text-(--accent)">
					{active
						? "Tema ativo"
						: theme.id.startsWith("ordem-")
							? "Exclusivo de Ordem Paranormal"
							: "Disponível em todos os sistemas"}
				</p>
				<h3 className="mt-2 font-serif text-2xl">{theme.name}</h3>
				<p className="my-4 grow text-sm leading-6 text-(--muted)">
					{theme.description}
				</p>
				{unavailable && (
					<p className="mb-4 text-xs leading-5 text-(--muted)">
						Selecione Ordem Paranormal em Sistemas para aplicar este tema.
					</p>
				)}
				<RpgVisualProvider theme={theme}>
					<RpgButton
						disabled={pending || active || unavailable}
						onClick={onSelect}
					>
						{active ? "Selecionado" : "Aplicar " + theme.name}
					</RpgButton>
				</RpgVisualProvider>
			</div>
		</section>
	);
}
