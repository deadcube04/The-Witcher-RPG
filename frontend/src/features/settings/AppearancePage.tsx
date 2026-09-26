import { useQuery } from "@tanstack/react-query";
import {
	MutationFeedback,
	RpgErrorState,
	RpgSkeleton,
} from "@/components/feedback/RemoteState";
import { PageHeader } from "@/components/navigation/PageHeader";
import { RpgSelect } from "@/components/primitives/RpgControls";
import { preferencesApi } from "@/shared/api/domains";
import { keys, queries, useDomainMutation } from "@/shared/api/queries";
import { AppearanceThemes } from "@/features/settings/AppearanceThemes";
import { useThemeMutation } from "@/features/themes/useThemeMutation";
import { ArchivePanel } from "@/components/layout/ArchiveSurface";

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
	const pending = mutation.isPending || sidebarMutation.isPending;
	return (
		<>
			<PageHeader
				eyebrow="Configurações / Aparência"
				title="A atmosfera da sua história"
				description="Escolha a aparência do NEXUS e mantenha suas histórias por perto."
			/>
			<ArchivePanel className="mb-8 max-w-2xl space-y-4 p-5 md:p-7">
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
					disabled={pending}
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
			</ArchivePanel>
			<AppearanceThemes
				preferences={preferences.data}
				available={available}
				pending={pending}
				onSelect={(patch) => mutation.mutate(patch)}
			/>
			<div className="mt-6">
				<MutationFeedback error={mutation.error} success={mutation.isSuccess} />
			</div>
		</>
	);
}
