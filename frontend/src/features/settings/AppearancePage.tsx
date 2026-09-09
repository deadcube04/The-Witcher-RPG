import { useQuery } from "@tanstack/react-query";
import {
	MutationFeedback,
	RpgEmptyState,
	RpgErrorState,
	RpgSkeleton,
} from "../../components/feedback/RemoteState";
import { PageHeader } from "../../components/navigation/PageHeader";
import { RpgButton, RpgSelect } from "../../components/primitives/RpgControls";
import { RpgVisualProvider } from "../../components/primitives/RpgVisualProvider";
import { preferencesApi } from "../../shared/api/domains";
import { keys, queries, useDomainMutation } from "../../shared/api/queries";
import { defaultTheme, themes } from "../themes/definitions";
import { useThemeMutation } from "../themes/useThemeMutation";

export function AppearancePage() {
	const preferences = useQuery(queries.preferences);
	const systems = useQuery(queries.systems);
	const mutation = useThemeMutation();
	const sidebarMutation = useDomainMutation(preferencesApi.update, [
		keys.preferences,
	]);
	if (preferences.isPending || systems.isPending) return <RpgSkeleton />;
	if (preferences.isError)
		return (
			<RpgErrorState
				error={preferences.error}
				retry={() => void preferences.refetch()}
			/>
		);
	if (systems.isError)
		return (
			<RpgErrorState
				error={systems.error}
				retry={() => void systems.refetch()}
			/>
		);
	const available =
		systems.data.find((system) => system.id === preferences.data.activeSystemId)
			?.availableThemes ?? [];
	const themeChoices = [
		defaultTheme,
		...themes.filter((theme) => available.includes(theme.id)),
	];
	return (
		<>
			<PageHeader
				eyebrow="Configurações / Aparência"
				title="A atmosfera da sua história"
				description="Escolha um elemento. Cada tema transforma a linguagem do seu arquivo."
			/>
			<section className="mb-6 max-w-xl space-y-4 border border-(--edge) bg-(--panel) p-5">
				<div>
					<h2 className="text-xl font-semibold">Sidebar</h2>
					<p className="mt-2 text-sm opacity-75">
						Escolha se o menu lateral permanece aberto ou expande apenas durante
						a interação.
					</p>
				</div>
				<RpgSelect
					label="Modo da sidebar"
					value={preferences.data.sidebarMode}
					onChange={(value) => {
						if (
							value === "collapsed" ||
							value === "expanded" ||
							value === "always-collapsed"
						)
							sidebarMutation.mutate({ sidebarMode: value });
					}}
					disabled={sidebarMutation.isPending}
					options={[
						{
							value: "collapsed",
							label: "Retraída (expande ao passar o mouse)",
						},
						{ value: "expanded", label: "Expandida" },
						{ value: "always-collapsed", label: "Sempre retraída" },
					]}
				/>
				<MutationFeedback
					error={sidebarMutation.error}
					success={sidebarMutation.isSuccess}
				/>
			</section>
			<div className="grid gap-6 md:grid-cols-2 xl:grid-cols-3">
				{themeChoices.map((theme) => {
					const activeThemeId = theme.id === "neutral" ? null : theme.id;
					const active = preferences.data.activeThemeId === activeThemeId;
					return (
						<section
							key={theme.id}
							className={`${theme.classes} flex flex-col bg-(--canvas) p-5 text-(--ink)`}
						>
							<div
								aria-hidden="true"
								className={
									theme.decoration +
									" mb-6 flex min-h-40 flex-col justify-between p-5"
								}
							>
								<span className="font-mono text-[10px] tracking-widest">
									{theme.mark}
								</span>
								<span className="text-3xl">O outro lado.</span>
							</div>
							<h3 className="text-2xl">{theme.name}</h3>
							<p className="my-4 grow text-sm leading-6 opacity-80">
								{theme.description}
							</p>
							<RpgVisualProvider theme={theme}>
								<RpgButton
									disabled={mutation.isPending || active}
									onClick={() => mutation.mutate(activeThemeId)}
								>
									{active ? `${theme.name} ativo` : `Aplicar ${theme.name}`}
								</RpgButton>
							</RpgVisualProvider>
						</section>
					);
				})}
			</div>
			{available.length === 0 && (
				<div className="mt-6">
					<RpgEmptyState title="Sem temas específicos para este sistema">
						<p>
							Selecione Ordem Paranormal em Sistemas para explorar os cinco
							elementos.
						</p>
					</RpgEmptyState>
				</div>
			)}
			<div className="mt-6">
				<MutationFeedback error={mutation.error} success={mutation.isSuccess} />
			</div>
		</>
	);
}
