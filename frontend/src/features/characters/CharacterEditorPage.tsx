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
import { ArchiveEyebrow, ArchivePanel } from "@/components/layout/ArchiveSurface";
import { PiUserCircleThin } from "react-icons/pi";

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
	if (!characterId && system?.status === "preview") return <div className="space-y-4 p-6"><h1 className="text-2xl">Sistema em prévia</h1><p>A criação de fichas está disponível em Ordem Paranormal 1.1.</p><Link to="/characters" className="underline">Voltar para fichas</Link></div>;
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
			<div className="grid gap-6 xl:grid-cols-[minmax(0,1fr)_20rem] xl:items-start">
			<ArchivePanel className="p-5 md:p-8" label="Dados do personagem"><CharacterForm
				initial={initial}
				campaigns={campaigns.data}
				systems={systems.data.filter((entry) => entry.status === "available")}
				pending={mutation.isPending}
				error={mutation.error}
				systemLocked={!!characterId || !!campaign}
				onSave={async (input) => {
					const saved = await mutation
						.mutateAsync(input)
						.catch(() => undefined);
					if (saved) await navigate({ to: `/characters/${saved.id}` });
				}}
			/></ArchivePanel>
			<aside className="rounded-3xl border border-(--edge)/60 bg-(--surface) p-6 xl:sticky xl:top-24"><ArchiveEyebrow>Resumo da ficha</ArchiveEyebrow><div className="my-8 grid place-items-center"><div className="grid size-36 place-items-center rounded-full border border-(--accent)/40 bg-(--canvas)"><PiUserCircleThin aria-hidden="true" className="size-20 text-(--accent)" /></div></div><p className="font-serif text-3xl leading-none">{initial.name || "Personagem sem nome"}</p><p className="mt-3 text-sm text-(--muted)">{system.name}</p><p className="mt-6 border-t border-(--edge)/60 pt-5 text-xs leading-6 text-(--muted)">Identidade, regras e narrativa permanecem em uma única página contínua.</p></aside>
			</div>
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
