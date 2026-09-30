import { useQuery } from "@tanstack/react-query";
import { Link, useParams } from "@tanstack/react-router";
import { useEffect } from "react";
import {
	RpgErrorState,
	RpgSkeleton,
} from "../../components/feedback/RemoteState";
import { queries } from "../../shared/api/queries";
import { rememberAccess } from "../../shared/lib/recent-access";
import { EditableCharacterSheet } from "./EditableCharacterSheet";

export function CharacterDetailPage() {
	const { characterId = "" } = useParams({ strict: false });
	const character = useQuery(queries.character(characterId));
	const campaigns = useQuery(queries.campaigns);
	useEffect(() => {
		if (character.data)
			rememberAccess({
				kind: "characters",
				id: character.data.id,
				name: character.data.name,
			});
	}, [character.data]);
	if (character.isPending || campaigns.isPending) return <RpgSkeleton />;
	if (character.isError)
		return (
			<RpgErrorState
				error={character.error}
				retry={() => void character.refetch()}
			/>
		);
	if (campaigns.isError)
		return (
			<RpgErrorState
				error={campaigns.error}
				retry={() => void campaigns.refetch()}
			/>
		);
	const item = character.data;
	const campaign = campaigns.data.find((entry) => entry.id === item.campaignId);
	const campaignReference = campaign ? (
		<Link
			to={`/campaigns/${campaign.id}`}
			className="text-(--accent) underline"
		>
			{campaign.name}
		</Link>
	) : null;
	return (
		<EditableCharacterSheet
			key={item.id}
			character={item}
			campaignReference={campaignReference}
		/>
	);
}
