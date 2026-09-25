import { useQuery } from "@tanstack/react-query";
import { Link } from "@tanstack/react-router";
import { useState } from "react";
import { PiArrowRightThin, PiPlusThin, PiSparkleThin } from "react-icons/pi";
import { RpgErrorState, RpgSkeleton } from "@/components/feedback/RemoteState";
import { ArchiveEyebrow, ArchivePanel, MediaFrame } from "@/components/layout/ArchiveSurface";
import { RecentCampaigns, RecentCharacters } from "@/features/home/HomeRecentSections";
import { queries } from "@/shared/api/queries";
import { readRecentAccess } from "@/shared/lib/recent-access";
import { archiveArt } from "@/shared/lib/system-art";

export function HomePage() {
	const campaigns = useQuery(queries.campaigns);
	const characters = useQuery(queries.characters);
	const preferences = useQuery(queries.preferences);
	const systems = useQuery(queries.systems);
	const [recent] = useState(readRecentAccess);
	if (campaigns.isPending || characters.isPending || preferences.isPending || systems.isPending) return <RpgSkeleton />;
	const error = campaigns.error ?? characters.error ?? preferences.error ?? systems.error;
	if (error) return <RpgErrorState error={error} retry={() => { void campaigns.refetch(); void characters.refetch(); void preferences.refetch(); void systems.refetch(); }} />;
	const active = systems.data?.find((system) => system.id === preferences.data?.activeSystemId);
	const latestCampaigns = [...(campaigns.data ?? [])].sort((a, b) => b.updatedAt.localeCompare(a.updatedAt)).slice(0, 3);
	const latestCharacters = [...(characters.data ?? [])].sort((a, b) => b.updatedAt.localeCompare(a.updatedAt)).slice(0, 4);
	const resumable = recent && (recent.kind === "campaigns" ? campaigns.data : characters.data)?.some((item) => item.id === recent.id);
	const destination = resumable && recent ? `/${recent.kind}/${recent.id}` : "/campaigns/new";

	return (
		<div className="space-y-12 lg:space-y-16">
			<header className="flex flex-wrap items-end justify-between gap-5">
				<div><ArchiveEyebrow>{active?.name ?? "Sistema não selecionado"}</ArchiveEyebrow><h1 className="mt-3 font-serif text-4xl leading-none tracking-[-0.04em] md:text-6xl">O arquivo está aberto.</h1></div>
				<p className="max-w-sm text-sm leading-6 text-(--muted)">Retome a última ocorrência ou abra um novo registro sem interromper a mesa.</p>
			</header>

			<div className="grid gap-5 xl:grid-cols-[minmax(0,1fr)_20rem]">
				<MediaFrame src={archiveArt.home} alt="Sala de arquivo escura com documentos de investigação" priority className="min-h-[32rem]">
					<div className="flex min-h-[32rem] max-w-3xl flex-col justify-between p-6 md:p-10 lg:p-14">
						<div className="flex items-center gap-3"><span className="size-2 rounded-full bg-(--accent) shadow-[0_0_24px_var(--accent)]" /><ArchiveEyebrow>{resumable ? "Último acesso" : "Primeiro registro"}</ArchiveEyebrow></div>
						<div>
							<h2 className="max-w-2xl font-serif text-4xl leading-[0.98] tracking-[-0.04em] text-white md:text-6xl">{resumable && recent ? recent.name : "Toda história deixa vestígios."}</h2>
							<p className="mt-5 max-w-xl text-sm leading-7 text-white/70">{resumable ? "Seu último documento permanece exatamente onde foi deixado." : "Crie uma campanha para começar a organizar personagens, ocorrências e recursos."}</p>
							<Link to={destination} className="group mt-8 inline-flex min-h-13 items-center gap-5 rounded-full bg-(--accent) px-6 font-semibold text-(--canvas) transition-transform duration-500 ease-[cubic-bezier(0.32,0.72,0,1)] active:scale-[0.98] focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-(--accent)">
								{resumable ? "Retomar sessão" : "Criar campanha"}<span className="grid size-8 place-items-center rounded-full bg-black/10"><PiArrowRightThin aria-hidden="true" /></span>
							</Link>
						</div>
					</div>
				</MediaFrame>
				<ArchivePanel className="flex flex-col p-6 md:p-7" label="Ações rápidas">
					<div className="flex items-center gap-3 text-(--accent)"><PiSparkleThin aria-hidden="true" className="size-5" /><ArchiveEyebrow>Ações rápidas</ArchiveEyebrow></div>
					<div className="mt-8 flex-1 divide-y divide-(--edge)/60">
						{[["/campaigns/new", "Nova campanha"], ["/characters/new", "Novo personagem"]].map(([to, label]) => <Link key={to} to={to} className="group flex min-h-20 items-center justify-between gap-4 py-4 text-lg hover:text-(--accent) focus-visible:outline-2"><span>{label}</span><PiPlusThin aria-hidden="true" className="size-5 transition-transform duration-500 group-hover:rotate-90" /></Link>)}
					</div>
					<Link to="/systems" className="mt-6 text-sm text-(--muted) underline decoration-(--edge) underline-offset-4 hover:text-(--accent)">Trocar universo ativo</Link>
				</ArchivePanel>
			</div>
			<div className="grid gap-10 xl:grid-cols-[minmax(0,1.3fr)_minmax(20rem,0.7fr)]"><RecentCampaigns items={latestCampaigns} /><RecentCharacters items={latestCharacters} /></div>
		</div>
	);
}
