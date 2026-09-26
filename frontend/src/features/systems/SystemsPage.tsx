import { useQuery } from "@tanstack/react-query";
import {
	ArchiveEyebrow,
	ArchivePanel,
	MediaFrame,
} from "@/components/layout/ArchiveSurface";
import {
	MutationFeedback,
	RpgErrorState,
	RpgSkeleton,
} from "@/components/feedback/RemoteState";
import { PageHeader } from "@/components/navigation/PageHeader";
import { RpgButton } from "@/components/primitives/RpgControls";
import { preferencesApi } from "@/shared/api/domains";
import { keys, queries, useDomainMutation } from "@/shared/api/queries";
import { systemArt } from "@/shared/lib/system-art";

export function SystemsPage() {
	const systems = useQuery(queries.systems);
	const preferences = useQuery(queries.preferences);
	const mutation = useDomainMutation(preferencesApi.update, [keys.preferences]);
	if (systems.isPending || preferences.isPending) return <RpgSkeleton />;
	if (systems.isError)
		return (
			<RpgErrorState
				error={systems.error}
				retry={() => void systems.refetch()}
			/>
		);
	if (preferences.isError)
		return (
			<RpgErrorState
				error={preferences.error}
				retry={() => void preferences.refetch()}
			/>
		);
	const active =
		systems.data.find(
			(system) => system.id === preferences.data.activeSystemId,
		) ?? systems.data[0];
	const remaining = systems.data.filter((system) => system.id !== active?.id);
	return (
		<>
			<PageHeader
				eyebrow="04 / Universos"
				title="Escolha sua próxima história"
				description="O universo ativo define o contexto de novos registros. Histórias existentes mantêm sua própria origem."
			/>
			{active && (
				<MediaFrame
					src={systemArt(active.slug)}
					alt={`Ilustração de ${active.name}`}
					priority
					className="min-h-[30rem]"
				>
					<div className="flex min-h-[30rem] max-w-3xl flex-col justify-between p-7 md:p-12">
						<ArchiveEyebrow>Universo ativo / Ficha completa</ArchiveEyebrow>
						<div>
							<h2 className="font-serif text-5xl leading-none text-white md:text-7xl">
								{active.name}
							</h2>
							<p className="mt-5 max-w-xl text-base leading-7 text-white/70">
								{active.description}
							</p>
							<div className="mt-7 inline-flex rounded-full border border-white/20 bg-black/20 px-4 py-2 font-mono text-[10px] uppercase tracking-wider text-white">
								Sistema selecionado
							</div>
						</div>
					</div>
				</MediaFrame>
			)}
			<div className="mt-6 grid gap-5 md:grid-cols-2">
				{remaining.map((system, index) => (
					<ArchivePanel key={system.id} className="overflow-hidden">
						<div className="relative h-44 overflow-hidden">
							<img
								src={systemArt(system.slug)}
								alt=""
								loading="lazy"
								className="size-full object-cover opacity-65"
							/>
							<div className="absolute inset-0 bg-gradient-to-t from-(--surface) to-transparent" />
						</div>
						<div className="-mt-4 relative p-6">
							<ArchiveEyebrow>
								Universo / {String(index + 2).padStart(2, "0")}
							</ArchiveEyebrow>
							<h3 className="mt-3 font-serif text-3xl">{system.name}</h3>
							<p className="mt-3 min-h-12 text-sm leading-6 text-(--muted)">
								{system.description}
							</p>
							<p className="my-5 text-xs text-(--muted)">
								{system.status === "available"
									? "Ficha completa disponível"
									: "Cadastro básico · ficha específica em breve"}
							</p>
							<RpgButton
								secondary
								disabled={mutation.isPending}
								onClick={() => {
									const currentTheme = preferences.data.activeThemeId;
									const activeThemeId =
										currentTheme === null ||
										system.availableThemes.includes(currentTheme)
											? currentTheme
											: "nexus";
									mutation.mutate({ activeSystemId: system.id, activeThemeId });
								}}
							>
								Selecionar {system.name}
							</RpgButton>
						</div>
					</ArchivePanel>
				))}
			</div>
			<div className="mt-5">
				<MutationFeedback error={mutation.error} success={mutation.isSuccess} />
			</div>
		</>
	);
}
