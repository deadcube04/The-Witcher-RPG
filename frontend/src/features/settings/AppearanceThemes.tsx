import { RpgCheckbox } from "@/components/primitives/RpgControls";
import {
	defaultTheme,
	nexusDark,
	nexusLight,
	themes,
} from "@/features/themes/definitions";
import { ThemeChoiceCard } from "@/features/themes/ThemeChoiceCard";
import type {
	PreferencesPatch,
	ThemeId,
	UserPreferences,
} from "@/shared/contracts/preferences";

type Props = {
	preferences: UserPreferences;
	available: ThemeId[];
	pending: boolean;
	onSelect: (patch: PreferencesPatch) => void;
};
export function AppearanceThemes({
	preferences,
	available,
	pending,
	onSelect,
}: Props) {
	const automatic =
		preferences.activeThemeId === "nexus" && preferences.colorMode === "system";
	return (
		<div className="space-y-10">
			<section aria-labelledby="nexus-themes">
				<h2 id="nexus-themes" className="font-serif text-3xl">
					NEXUS
				</h2>
				<p className="mt-2 text-sm text-(--muted)">
					Uma identidade para todas as suas histórias.
				</p>
				<div className="my-5">
					<RpgCheckbox
						label="Seguir o sistema"
						checked={automatic}
						disabled={pending}
						onChange={(checked) =>
							onSelect({
								activeThemeId: "nexus",
								colorMode: checked
									? "system"
									: window.matchMedia("(prefers-color-scheme: dark)").matches
										? "dark"
										: "light",
							})
						}
					/>
					<p className="mt-2 text-xs text-(--muted)">
						Alterna entre claro e escuro conforme a preferência do dispositivo.
						Escolher uma opção abaixo desativa o automático.
					</p>
				</div>
				<div className="grid gap-6 md:grid-cols-2">
					{[nexusLight, nexusDark].map((theme) => (
						<ThemeChoiceCard
							key={theme.mode}
							theme={theme}
							active={
								preferences.activeThemeId === "nexus" &&
								preferences.colorMode === theme.mode
							}
							pending={pending}
							onSelect={() =>
								onSelect({ activeThemeId: "nexus", colorMode: theme.mode })
							}
						/>
					))}
				</div>
			</section>
			<section aria-labelledby="ordem-themes">
				<h2 id="ordem-themes" className="font-serif text-3xl">
					Ordem
				</h2>
				<p className="mb-5 mt-2 text-sm text-(--muted)">
					Arquivo e os cinco elementos. Todos mantêm sua aparência escura;
					Arquivo pode ser usado em qualquer sistema.
				</p>
				<div className="grid gap-6 md:grid-cols-2 xl:grid-cols-3">
					{[defaultTheme, ...themes].map((theme) => {
						const id = theme.id === "neutral" ? null : theme.id;
						return (
							<ThemeChoiceCard
								key={theme.id}
								theme={theme}
								active={preferences.activeThemeId === id}
								pending={pending}
								unavailable={id !== null && !available.includes(id)}
								onSelect={() => onSelect({ activeThemeId: id })}
							/>
						);
					})}
				</div>
			</section>
		</div>
	);
}
