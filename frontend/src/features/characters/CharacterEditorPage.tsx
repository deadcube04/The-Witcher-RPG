import { useQuery } from "@tanstack/react-query";
import { Link, useNavigate, useParams } from "@tanstack/react-router";
import {
	RpgErrorState,
	RpgSkeleton,
} from "../../components/feedback/RemoteState";
import { PageHeader } from "../../components/navigation/PageHeader";
import { ApiError } from "../../shared/api/client";
import { characterApi } from "../../shared/api/domains";
import { keys, queries, useDomainMutation } from "../../shared/api/queries";
import type { CharacterInput } from "../../shared/contracts/character-sheet";
import { createCharacterInput } from "../../shared/contracts/defaults";
import { useListFilters } from "../../shared/hooks/useListFilters";
import { CharacterForm } from "./CharacterForm";
import { characterSheetRegistry } from "./registry";

export function CharacterEditorPage() {
	const { characterId = "" } = useParams({ strict: false });
	const { filters } = useListFilters();
	const navigate = useNavigate();
	const systems = useQuery(queries.systems);
	const campaigns = useQuery(queries.campaigns);
	const preferences = useQuery(queries.preferences);
	const character = useQuery({
		...queries.character(characterId),
		enabled: !!characterId,
	});
	const mutation = useDomainMutation(
		(input: CharacterInput) =>
			characterId
				? characterApi.update(characterId, input)
				: characterApi.create(input),
		[keys.characters, keys.campaigns],
	);
	if (
		systems.isPending ||
		campaigns.isPending ||
		preferences.isPending ||
		(characterId && character.isPending)
	)
		return <RpgSkeleton />;
	const error =
		systems.error ??
		campaigns.error ??
		preferences.error ??
		(characterId ? character.error : null);
	if (error)
		return (
			<RpgErrorState
				error={error}
				retry={() => {
					void systems.refetch();
					void campaigns.refetch();
					void preferences.refetch();
					if (characterId) void character.refetch();
				}}
			/>
		);
	if (!systems.data || !campaigns.data || !preferences.data) return null;
	const campaign = campaigns.data.find(
		(entry) => entry.id === filters.campaignId,
	);
	if (!characterId && filters.campaignId && !campaign)
		return <RpgErrorState error={new ApiError("CAMPAIGN_NOT_FOUND")} />;
	if (
		!characterId &&
		campaign &&
		filters.systemId &&
		campaign.systemId !== filters.systemId
	)
		return <RpgErrorState error={new ApiError("SYSTEM_MISMATCH")} />;
	const systemId =
		character.data?.systemId ??
		campaign?.systemId ??
		(filters.systemId || preferences.data.activeSystemId);
	const system = systems.data.find((entry) => entry.id === systemId);
	const definition = system && characterSheetRegistry.get(system.slug);
	if (!definition)
		return <RpgErrorState error={new ApiError("RPG_SYSTEM_NOT_FOUND")} />;
	const initial = character.data
		? characterInput(character.data)
		: createCharacterInput(
				systemId,
				campaign?.id ?? null,
				definition.createData(),
			);
	return (
		<>
			<Link
				to={
					characterId
						? `/characters/${characterId}`
						: campaign
							? `/campaigns/${campaign.id}`
							: "/characters"
				}
				className="mb-6 inline-block py-2 text-sm underline"
			>
				← Voltar
			</Link>
			<PageHeader
				eyebrow="Fichas / Registro"
				title={characterId ? "Editar personagem" : "Dê vida a um personagem"}
			/>
			<CharacterForm
				initial={initial}
				campaigns={campaigns.data}
				systems={systems.data}
				pending={mutation.isPending}
				error={mutation.error}
				systemLocked={!!characterId || !!campaign}
				onSave={async (input) => {
					const saved = await mutation
						.mutateAsync(input)
						.catch(() => undefined);
					if (saved) await navigate({ to: `/characters/${saved.id}` });
				}}
			/>
		</>
	);
}
function characterInput(value: CharacterInput): CharacterInput {
	return {
		name: value.name,
		systemId: value.systemId,
		campaignId: value.campaignId,
		description: value.description,
		appearance: value.appearance,
		personality: value.personality,
		background: value.background,
		objective: value.objective,
		systemData: value.systemData,
	};
}
