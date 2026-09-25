import { useQuery } from "@tanstack/react-query";
import { Link, useNavigate, useParams } from "@tanstack/react-router";
import {
	RpgErrorState,
	RpgSkeleton,
} from "../../components/feedback/RemoteState";
import { PageHeader } from "../../components/navigation/PageHeader";
import { campaignApi } from "../../shared/api/domains";
import { keys, queries, useDomainMutation } from "../../shared/api/queries";
import type { CampaignInput } from "../../shared/contracts/campaign";
import { CampaignForm } from "./CampaignForm";
import { ArchiveEyebrow, ArchivePanel, MediaFrame } from "@/components/layout/ArchiveSurface";
import { systemArt } from "@/shared/lib/system-art";

export function CampaignEditorPage() {
	const { campaignId = "" } = useParams({ strict: false });
	const navigate = useNavigate();
	const systems = useQuery(queries.systems);
	const preferences = useQuery(queries.preferences);
	const campaign = useQuery({
		...queries.campaign(campaignId),
		enabled: !!campaignId,
	});
	const characters = useQuery(queries.characters);
	const mutation = useDomainMutation(
		(input: CampaignInput) =>
			campaignId
				? campaignApi.update(campaignId, input)
				: campaignApi.create(input),
		[keys.campaigns],
	);
	if (
		systems.isPending ||
		preferences.isPending ||
		characters.isPending ||
		(campaignId && campaign.isPending)
	)
		return <RpgSkeleton />;
	const error =
		systems.error ??
		preferences.error ??
		characters.error ??
		(campaignId ? campaign.error : null);
	if (error)
		return (
			<RpgErrorState
				error={error}
				retry={() => {
					void systems.refetch();
					void preferences.refetch();
					void characters.refetch();
					if (campaignId) void campaign.refetch();
				}}
			/>
		);
	if (!systems.data || !preferences.data) return null;
	const initial: CampaignInput = campaign.data
		? {
				name: campaign.data.name,
				systemId: campaign.data.systemId,
				description: campaign.data.description,
				status: campaign.data.status,
			}
		: {
				name: "",
				description: "",
				systemId: preferences.data.activeSystemId,
				status: "active",
			};
	return (
		<>
			<Link
				to={campaignId ? `/campaigns/${campaignId}` : "/campaigns"}
				className="mb-6 inline-block py-2 text-sm underline"
			>
				← Voltar para campanhas
			</Link>
			<PageHeader
				eyebrow="Campanhas / Registro"
				title={campaignId ? "Editar campanha" : "Uma nova história"}
			/>
			<div className="grid gap-6 xl:grid-cols-[minmax(0,1fr)_22rem] xl:items-start">
				<ArchivePanel className="p-5 md:p-8" label="Dados da campanha"><CampaignForm
					initial={initial}
					systems={systems.data}
					pending={mutation.isPending}
					error={mutation.error}
					systemLocked={
						!!characters.data?.some((sheet) => sheet.campaignId === campaignId)
					}
					onSave={async (input) => {
						const saved = await mutation
							.mutateAsync(input)
							.catch(() => undefined);
						if (saved) await navigate({ to: `/campaigns/${saved.id}` });
					}}
				/></ArchivePanel>
				<div className="space-y-4 xl:sticky xl:top-24">
					<MediaFrame src={systemArt(systems.data.find((entry) => entry.id === initial.systemId)?.slug)} alt="Prévia visual do dossier" className="min-h-64"><div className="flex min-h-64 flex-col justify-between p-6"><ArchiveEyebrow>Prévia do dossier</ArchiveEyebrow><p className="font-serif text-3xl leading-none text-white">{initial.name || "Uma história sem título"}</p></div></MediaFrame>
					<p className="px-2 text-xs leading-6 text-(--muted)">A imagem representa o universo selecionado. Nenhum campo de mídia é necessário.</p>
				</div>
			</div>
		</>
	);
}
