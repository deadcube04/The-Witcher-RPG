import { useQuery } from "@tanstack/react-query";
import { Link, useParams } from "@tanstack/react-router";
import { useEffect } from "react";
import { ResourceLinks } from "../../components/data-display/ResourceLinks";
import {
	RpgErrorState,
	RpgSkeleton,
} from "../../components/feedback/RemoteState";
import { PageHeader } from "../../components/navigation/PageHeader";
import { queries } from "../../shared/api/queries";
import { rememberAccess } from "../../shared/lib/recent-access";
import { CampaignDeleteAction } from "./CampaignDeleteAction";

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
	return (
		<>
			<Link
				to="/campaigns"
				className="mb-6 inline-block py-2 text-sm underline"
			>
				← Todas as campanhas
			</Link>
			<PageHeader
				eyebrow={
					(systems.data.find((system) => system.id === item.systemId)?.name ??
						"") +
					" / " +
					(item.status === "active" ? "Em andamento" : "Arquivada")
				}
				title={item.name}
				actions={
					<>
						<Link
							to={`/campaigns/${item.id}/edit`}
							className="border border-(--edge) px-5 py-3 text-sm"
						>
							Editar campanha
						</Link>
						<CampaignDeleteAction campaign={item} />
					</>
				}
			/>
			<p className="mb-10 max-w-3xl whitespace-pre-wrap leading-7 opacity-80">
				{item.description || "Esta campanha ainda não tem uma descrição."}
			</p>
			<section>
				<div className="mb-4 flex flex-wrap items-center justify-between gap-4">
					<h3 className="text-2xl">Personagens da campanha</h3>
					<Link
						to="/characters/new"
						search={{ campaignId: item.id, systemId: item.systemId }}
						className="bg-(--accent) px-5 py-3 text-sm font-bold text-(--canvas)"
					>
						Adicionar personagem
					</Link>
				</div>
				<ResourceLinks
					kind="characters"
					items={characters.data.filter(
						(sheet) => sheet.campaignId === item.id,
					)}
				/>
			</section>
		</>
	);
}
