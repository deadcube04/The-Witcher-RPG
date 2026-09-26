import { useQuery } from "@tanstack/react-query";
import { Link, useParams } from "@tanstack/react-router";
import { useEffect } from "react";
import { ResourceLinks } from "@/components/data-display/ResourceLinks";
import { RpgErrorState, RpgSkeleton } from "@/components/feedback/RemoteState";
import { queries } from "@/shared/api/queries";
import { rememberAccess } from "@/shared/lib/recent-access";
import { CampaignDeleteAction } from "@/features/campaigns/CampaignDeleteAction";
import { ArchiveEyebrow, MediaFrame } from "@/components/layout/ArchiveSurface";
import { systemArt } from "@/shared/lib/system-art";

export function CampaignDetailPage() {
	const { campaignId = "" } = useParams({ strict: false });
	const campaign = useQuery(queries.campaign(campaignId));
	const characters = useQuery(queries.characters);
	const systems = useQuery(queries.systems);
	useEffect(() => {
		if (campaign.data)
			rememberAccess({
				kind: "campaigns",
				id: campaign.data.id,
				name: campaign.data.name,
			});
	}, [campaign.data]);
	if (campaign.isPending || characters.isPending || systems.isPending)
		return <RpgSkeleton />;
	if (campaign.isError)
		return (
			<RpgErrorState
				error={campaign.error}
				retry={() => void campaign.refetch()}
			/>
		);
	if (characters.isError)
		return (
			<RpgErrorState
				error={characters.error}
				retry={() => void characters.refetch()}
			/>
		);
	if (systems.isError)
		return (
			<RpgErrorState
				error={systems.error}
				retry={() => void systems.refetch()}
			/>
		);
	const item = campaign.data;
	const system = systems.data.find((entry) => entry.id === item.systemId);
	const linkedCharacters = characters.data.filter(
		(sheet) => sheet.campaignId === item.id,
	);
	return (
		<div className="space-y-10">
			<Link
				to="/campaigns"
				className="inline-flex min-h-11 items-center text-sm text-(--muted) underline decoration-(--edge) underline-offset-4 hover:text-(--accent)"
			>
				← Todas as campanhas
			</Link>
			<MediaFrame
				src={systemArt(system?.slug)}
				alt="Ilustração da campanha"
				priority
				className="min-h-[30rem]"
			>
				<div className="flex min-h-[30rem] flex-col justify-between p-6 md:p-10 lg:p-14">
					<ArchiveEyebrow>
						{system?.name ?? "Sistema indisponível"} /{" "}
						{item.status === "active" ? "Em andamento" : "Arquivada"}
					</ArchiveEyebrow>
					<div className="max-w-4xl">
						<h1 className="font-serif text-5xl leading-[0.94] tracking-[-0.045em] text-white md:text-7xl">
							{item.name}
						</h1>
						<div className="mt-7 flex flex-wrap gap-3">
							<Link
								to={`/campaigns/${item.id}/edit`}
								className="inline-flex min-h-11 items-center rounded-full border border-white/30 bg-black/20 px-5 text-sm text-white hover:border-white/60"
							>
								Editar campanha
							</Link>
							<CampaignDeleteAction campaign={item} />
						</div>
					</div>
				</div>
			</MediaFrame>
			<div className="grid gap-10 lg:grid-cols-[minmax(0,0.75fr)_minmax(20rem,1.25fr)]">
				<div>
					<ArchiveEyebrow>Sinopse do registro</ArchiveEyebrow>
					<p className="mt-5 max-w-3xl whitespace-pre-wrap font-serif text-2xl leading-9 text-(--muted)">
						{item.description || "Esta campanha ainda não tem uma descrição."}
					</p>
				</div>
				<section className="rounded-2xl border border-(--edge)/60 bg-(--surface) p-6 md:p-8">
					<div className="mb-4 flex flex-wrap items-center justify-between gap-4">
						<div>
							<ArchiveEyebrow>Elenco vinculado</ArchiveEyebrow>
							<h2 className="mt-2 font-serif text-3xl">
								Personagens da campanha
							</h2>
						</div>
						<Link
							to="/characters/new"
							search={{ campaignId: item.id, systemId: item.systemId }}
							className="inline-flex min-h-11 items-center rounded-full bg-(--accent) px-5 text-sm font-bold text-(--on-accent)"
						>
							Adicionar personagem
						</Link>
					</div>
					<ResourceLinks kind="characters" items={linkedCharacters} />
				</section>
			</div>
		</div>
	);
}
