import { useNavigate } from "@tanstack/react-router";
import { RpgDeleteAction } from "../../components/overlay/RpgDeleteAction";
import { campaignApi } from "../../shared/api/domains";
import { keys, useDomainMutation } from "../../shared/api/queries";
import type { Campaign } from "../../shared/contracts/campaign";

export function CampaignDeleteAction({ campaign }: { campaign: Campaign }) {
	const navigate = useNavigate();
	const mutation = useDomainMutation(campaignApi.remove, [
		keys.campaigns,
		keys.characters,
	]);
	return (
		<RpgDeleteAction
			name={campaign.name}
			description="A campanha será excluída. Suas fichas serão preservadas como standalone."
			onDelete={async () => {
				await mutation.mutateAsync(campaign.id);
				await navigate({ to: "/campaigns" });
			}}
		/>
	);
}
