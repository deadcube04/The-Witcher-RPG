import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { RpgButton } from "@/components/primitives/RpgControls";
import { MutationFeedback, RpgErrorState, RpgSkeleton } from "@/components/feedback/RemoteState";
import { campaignApi } from "@/shared/api/domains";
import { keys, queries, useDomainMutation } from "@/shared/api/queries";
import type { Campaign, CampaignSelection } from "@/shared/contracts/campaign";
import { AllowedOptions } from "@/features/campaigns/CampaignSettingsStep";
import { SupplementSettingsPanel } from "@/features/campaigns/SupplementSettingsPanel";

export function CampaignRulesEditor({ campaign }: { campaign: Campaign }) {
	const [editing, setEditing] = useState(false);
	const [settings, setSettings] = useState(campaign.settings);
	const options = useQuery({ ...queries.characterOptions, enabled: editing });
	const supplements = useQuery({ ...queries.supplements, enabled: editing });
	const mutation = useDomainMutation((input: Campaign["settings"]) => campaignApi.updateSettings(campaign.id, input), [keys.campaign(campaign.id), keys.campaigns, keys.characters]);
	if (!editing) return <section className="rounded-[2rem] bg-(--edge)/35 p-1.5"><div className="flex flex-wrap items-center justify-between gap-4 rounded-[calc(2rem-0.375rem)] bg-(--surface) p-6 md:p-8"><div><h2 className="font-serif text-3xl">Regras da campanha</h2><p className="mt-2 text-sm text-(--muted)">{campaign.settings.supplement ? "Sobrevivendo ao Horror ativo" : "Suplemento desligado"}</p></div><RpgButton secondary onClick={() => { setSettings(campaign.settings); setEditing(true); }}>Editar escolhas</RpgButton></div></section>;
	if (options.isPending || supplements.isPending) return <RpgSkeleton />;
	if (options.error || supplements.error) return <RpgErrorState error={options.error ?? supplements.error ?? new Error("Não foi possível carregar as regras.")} retry={() => { void options.refetch(); void supplements.refetch(); }} />;
	const updateSelection = (key: "classes" | "origins", value: CampaignSelection) => setSettings({ ...settings, [key]: value });
	return <section aria-label="Editar regras da campanha" className="space-y-6">
		<div className="flex flex-wrap items-center justify-between gap-3"><div><h2 className="font-serif text-3xl">Regras da campanha</h2><p className="mt-1 text-sm text-(--muted)">As fichas existentes precisam continuar compatíveis com as escolhas.</p></div><RpgButton secondary onClick={() => setEditing(false)}>Cancelar</RpgButton></div>
		<AllowedOptions title="Classes disponíveis" options={options.data.classes} selection={settings.classes} onChange={(value) => updateSelection("classes", value)} />
		<AllowedOptions title="Origens disponíveis" options={options.data.origins.filter((option) => !option.supplementId || option.supplementId === settings.supplement?.id)} selection={settings.origins} onChange={(value) => updateSelection("origins", value)} />
		<SupplementSettingsPanel supplements={supplements.data} systemId={campaign.systemId} value={settings.supplement} onChange={(supplement) => setSettings({ ...settings, supplement, origins: settings.origins.mode === "selected" ? { ...settings.origins, allowedIds: settings.origins.allowedIds.filter((id) => options.data.origins.some((option) => option.id === id && (!option.supplementId || option.supplementId === supplement?.id))) } : settings.origins })} />
		<MutationFeedback error={mutation.error} success={mutation.isSuccess} />
		<RpgButton loading={mutation.isPending} onClick={() => { void mutation.mutateAsync(settings).then(() => setEditing(false)).catch(() => undefined); }}>Salvar regras</RpgButton>
	</section>;
}
