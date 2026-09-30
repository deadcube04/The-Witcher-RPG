import { useForm } from "@tanstack/react-form";
import { z } from "zod";
import { RpgForm } from "@/components/forms/RpgForm";
import { RpgButton, RpgInput, RpgSelect } from "@/components/primitives/RpgControls";
import type { RpgSystem } from "@/shared/contracts/rpg-system";
import { fieldError } from "@/shared/lib/form-error";
import type { CampaignDraft } from "@/features/campaigns/campaign-draft";
import { CampaignCoverPicker } from "@/features/campaigns/CampaignCoverPicker";
import { CampaignPreview } from "@/features/campaigns/CampaignPreview";

const coreSchema = z.strictObject({
	name: z.string().trim().min(1, "Informe um nome.").max(160),
	description: z.string().max(10000),
	systemId: z.uuid(),
});

export function CampaignForm({
	draft, systems, coverUrl, hasCover, onDraft, onCover, onNext,
}: {
	draft: CampaignDraft;
	systems: RpgSystem[];
	coverUrl: string;
	hasCover: boolean;
	onDraft: (draft: CampaignDraft) => void;
	onCover: (cover: Blob | null) => Promise<void>;
	onNext: () => void;
}) {
	const form = useForm({
		defaultValues: { name: draft.name, description: draft.description, systemId: draft.systemId },
		validators: { onSubmit: coreSchema },
		onSubmit: () => onNext(),
	});
	return <div className="grid gap-6 xl:grid-cols-[minmax(0,1fr)_22rem] xl:items-start">
		<RpgForm onSubmit={() => form.handleSubmit()}>
			<div className="space-y-5 rounded-2xl border border-(--edge)/70 bg-(--surface) p-5 md:p-8">
				<p className="font-mono text-[10px] uppercase tracking-[0.22em] text-(--accent)">01 / Identificação da campanha</p>
				<form.Field name="name">{(field) => <RpgInput label="Nome da campanha" value={field.state.value} onChange={(name) => { field.handleChange(name); onDraft({ ...draft, name }); }} onBlur={field.handleBlur} error={fieldError(field.state.meta.errors)} />}</form.Field>
				<form.Field name="systemId">{(field) => <RpgSelect label="Sistema da campanha" value={field.state.value} onChange={(systemId) => { field.handleChange(systemId); onDraft({ ...draft, systemId, classes: { mode: "all", allowedIds: [] }, origins: { mode: "all", allowedIds: [] } }); }} options={systems.map((system) => ({ value: system.id, label: system.status === "available" ? system.name : `${system.name} (em prévia)`, disabled: system.status !== "available" }))} />}</form.Field>
				<form.Field name="description">{(field) => <RpgInput label="Descrição" multiline value={field.state.value} onChange={(description) => { field.handleChange(description); onDraft({ ...draft, description }); }} onBlur={field.handleBlur} error={fieldError(field.state.meta.errors)} />}</form.Field>
				<CampaignCoverPicker hasCover={hasCover} onChange={onCover} />
				<RpgButton submit>Continuar para detalhes</RpgButton>
			</div>
		</RpgForm>
		<aside className="xl:sticky xl:top-24">
			<form.Subscribe selector={(state) => state.values}>{(values) => <CampaignPreview name={values.name} description={values.description} system={systems.find((entry) => entry.id === values.systemId)} coverUrl={coverUrl} />}</form.Subscribe>
			<p className="mt-3 px-2 text-xs leading-6 text-(--muted)">Esta prévia acompanha as alterações. A campanha será salva somente ao concluir a próxima tela.</p>
		</aside>
	</div>;
}
