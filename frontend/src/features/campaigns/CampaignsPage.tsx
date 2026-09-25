import { useQuery } from "@tanstack/react-query";
import { Link } from "@tanstack/react-router";
import {
	RpgErrorState,
	RpgSkeleton,
} from "../../components/feedback/RemoteState";
import { PageHeader } from "../../components/navigation/PageHeader";
import { queries } from "../../shared/api/queries";
import { useListFilters } from "../../shared/hooks/useListFilters";
import { matchesName } from "../../shared/lib/search";
import { CampaignFilters } from "./CampaignFilters";
import { CampaignList } from "./CampaignList";

export function CampaignsPage() {
	const campaigns = useQuery(queries.campaigns);
	const systems = useQuery(queries.systems);
	const { filters, update } = useListFilters();
	if (campaigns.isPending || systems.isPending) return <RpgSkeleton />;
	if (campaigns.isError)
		return (
			<RpgErrorState
				error={campaigns.error}
				retry={() => void campaigns.refetch()}
			/>
		);
	if (systems.isError)
		return (
			<RpgErrorState
				error={systems.error}
				retry={() => void systems.refetch()}
			/>
		);
	const filtered = campaigns.data.filter(
		(campaign) =>
			matchesName(campaign.name, filters.q) &&
			(!filters.systemId || campaign.systemId === filters.systemId),
	);
	return (
		<>
			<PageHeader
				eyebrow="02 / Campanhas"
				title="Dossiers em curso"
				description="Histórias abertas, ocorrências arquivadas e os rastros que ainda precisam ser seguidos."
				actions={
					<Link
						to="/campaigns/new"
						className="inline-flex min-h-12 items-center rounded-full bg-(--accent) px-6 text-sm font-bold text-(--canvas) active:scale-[0.98]"
					>
						Nova campanha
					</Link>
				}
			/>
			<CampaignFilters
				filters={filters}
				systems={systems.data}
				onChange={update}
			/>
			<CampaignList campaigns={filtered} systems={systems.data} />
		</>
	);
}
