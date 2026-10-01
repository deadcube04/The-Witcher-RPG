import { useQuery } from "@tanstack/react-query";
import { Link, useNavigate } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { RpgErrorState, RpgSkeleton } from "@/components/feedback/RemoteState";
import { PageHeader } from "@/components/navigation/PageHeader";
import { RpgButton } from "@/components/primitives/RpgControls";
import { campaignApi } from "@/shared/api/domains";
import { uploadImage } from "@/shared/api/media";
import { keys, queries, useDomainMutation } from "@/shared/api/queries";
import { campaignInputSchema, type CampaignInput } from "@/shared/contracts/campaign";
import type { RpgSystem } from "@/shared/contracts/rpg-system";
import { CampaignForm } from "@/features/campaigns/CampaignForm";
import { CampaignSettingsStep } from "@/features/campaigns/CampaignSettingsStep";
import {
	clearCampaignDraft, newCampaignDraft, readCampaignDraft, readDraftCover,
	saveCampaignDraft, saveDraftCover, type CampaignDraft,
} from "@/features/campaigns/campaign-draft";

export function CampaignEditorPage() {
	const systems = useQuery(queries.systems);
	const preferences = useQuery(queries.preferences);
	if (systems.isPending || preferences.isPending) return <RpgSkeleton />;
	const remoteError = systems.error ?? preferences.error;
	if (remoteError) return <RpgErrorState error={remoteError} retry={() => { void systems.refetch(); void preferences.refetch(); }} />;
	if (!systems.data || !preferences.data) return <RpgSkeleton />;
	const selected = systems.data.find((item) => item.id === preferences.data.activeSystemId && item.status === "available") ?? systems.data.find((item) => item.status === "available");
	if (!selected) return <RpgErrorState error={new Error("Nenhum sistema permite criar campanhas atualmente.")} />;
	return <CampaignCreation systems={systems.data} initialSystemId={selected.id} />;
}

function CampaignCreation({ systems, initialSystemId }: { systems: RpgSystem[]; initialSystemId: string }) {
	const navigate = useNavigate();
	const [draft, setDraft] = useState<CampaignDraft>(() => readCampaignDraft() ?? newCampaignDraft(initialSystemId));
	const [cover, setCover] = useState<Blob | null>(null);
	const [coverReady, setCoverReady] = useState(false);
	const [coverUrl, setCoverUrl] = useState("");
	const [submitting, setSubmitting] = useState(false);
	const [submissionError, setSubmissionError] = useState<Error | null>(null);
	const options = useQuery({ ...queries.characterOptions, enabled: draft.step === "settings" });
	const supplements = useQuery({ ...queries.supplements, enabled: draft.step === "settings" });
	const mutation = useDomainMutation((input: CampaignInput) => campaignApi.create(input), [keys.campaigns]);
	useEffect(() => { saveCampaignDraft(draft); }, [draft]);
	useEffect(() => {
		let active = true;
		void readDraftCover(draft.id).then((blob) => {
			if (!active) return;
			setCover(blob);
			setCoverUrl(blob ? URL.createObjectURL(blob) : "");
			setCoverReady(true);
		}).catch(() => { if (active) setCoverReady(true); });
		return () => { active = false; };
	}, [draft.id]);
	useEffect(() => () => { if (coverUrl) URL.revokeObjectURL(coverUrl); }, [coverUrl]);
	const updateDraft = (next: CampaignDraft) => { saveCampaignDraft(next); setDraft(next); };
	const updateCover = async (blob: Blob | null) => {
		await saveDraftCover(draft.id, blob);
		setCover(blob);
		setCoverUrl(blob ? URL.createObjectURL(blob) : "");
		updateDraft({ ...draft, uploadedCoverUrl: "" });
	};
	const discard = async () => {
		await saveDraftCover(draft.id, null).catch(() => undefined);
		clearCampaignDraft();
		await navigate({ to: "/campaigns" });
	};
	const create = async (sheetMode: "guided" | "free") => {
		setSubmitting(true);
		setSubmissionError(null);
		try {
			let coverImageUrl = draft.uploadedCoverUrl;
			if (cover && !coverImageUrl) {
				coverImageUrl = await uploadImage(cover, "campaign");
				updateDraft({ ...draft, sheetMode, uploadedCoverUrl: coverImageUrl });
			}
			const input = campaignInputSchema.parse({
				systemId: draft.systemId, name: draft.name, description: draft.description,
				coverImageUrl, sheetMode,
				settings: { kind: "ordem-paranormal", classes: draft.classes, origins: draft.origins, supplement: draft.supplement },
			});
			const created = await mutation.mutateAsync(input);
			clearCampaignDraft();
			await saveDraftCover(draft.id, null).catch(() => undefined);
			await navigate({ to: `/campaigns/${created.id}` });
		} catch (reason: unknown) {
			setSubmissionError(reason instanceof Error ? reason : new Error("Não foi possível criar a campanha."));
		} finally { setSubmitting(false); }
	};
	if (!coverReady) return <RpgSkeleton />;
	const system = systems.find((item) => item.id === draft.systemId && item.status === "available");
	if (!system) return <RpgErrorState error={new Error("O sistema deste rascunho não está disponível.")} retry={() => { void discard(); }} />;
	if (system.slug !== "ordem-paranormal") return <RpgErrorState error={new Error("A configuração de campanhas deste sistema ainda não está disponível.")} />;
	if (draft.step === "settings" && options.isPending) return <RpgSkeleton />;
	if (draft.step === "settings" && options.isError) return <RpgErrorState error={options.error} retry={() => void options.refetch()} />;
	if (draft.step === "settings" && supplements.isPending) return <RpgSkeleton />;
	if (draft.step === "settings" && supplements.isError) return <RpgErrorState error={supplements.error} retry={() => void supplements.refetch()} />;
	return <div className="space-y-6">
		<div className="flex flex-wrap items-center justify-between gap-3">
			<Link to="/campaigns" className="text-sm underline">← Todas as campanhas</Link>
			<RpgButton secondary disabled={submitting} onClick={() => { void discard(); }}>Descartar rascunho</RpgButton>
		</div>
		<PageHeader eyebrow="Campanhas / Novo registro" title={draft.step === "core" ? "Uma nova história" : "Defina os detalhes"} description={draft.step === "core" ? "Comece pelos dados da campanha. A prévia acompanha o que você escrever." : "Escolha o que os jogadores poderão usar em Ordem Paranormal."} />
		{draft.step === "core" ? <CampaignForm draft={draft} systems={systems} coverUrl={coverUrl || draft.uploadedCoverUrl} hasCover={!!cover || !!draft.uploadedCoverUrl} onDraft={updateDraft} onCover={updateCover} onNext={() => updateDraft({ ...draft, step: "settings" })} /> : options.data && supplements.data && <CampaignSettingsStep draft={draft} system={system} options={options.data} supplements={supplements.data} coverUrl={coverUrl || draft.uploadedCoverUrl} pending={submitting} error={submissionError} onDraft={updateDraft} onBack={() => updateDraft({ ...draft, step: "core" })} onCreate={create} />}
	</div>;
}
