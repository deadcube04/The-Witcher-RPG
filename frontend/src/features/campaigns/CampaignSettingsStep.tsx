import { useForm } from "@tanstack/react-form";
import { z } from "zod";
import { RpgForm } from "@/components/forms/RpgForm";
import { RpgButton, RpgCheckbox, RpgSelect } from "@/components/primitives/RpgControls";
import { MutationFeedback } from "@/components/feedback/RemoteState";
import type { CharacterOptions } from "@/shared/contracts/character-options";
import type { CampaignSelection } from "@/shared/contracts/campaign";
import { CampaignPreview } from "@/features/campaigns/CampaignPreview";
import { SupplementSettingsPanel } from "@/features/campaigns/SupplementSettingsPanel";
import type { Supplement } from "@/shared/contracts/supplement";
import type { CampaignDraft } from "@/features/campaigns/campaign-draft";
import type { RpgSystem } from "@/shared/contracts/rpg-system";

const modeSchema = z.strictObject({ sheetMode: z.enum(["guided", "free"]) });
type Option = CharacterOptions["classes"][number];

function toggleOption(selection: CampaignSelection, options: Option[], id: string): CampaignSelection {
	const selected = selection.mode === "all" ? options.map((option) => option.id) : selection.allowedIds;
	const next = selected.includes(id) ? selected.filter((item) => item !== id) : [...selected, id];
	return next.length === options.length ? { mode: "all", allowedIds: [] } : { mode: "selected", allowedIds: next };
}

export function AllowedOptions({ title, options, selection, onChange }: {
	title: string; options: Option[]; selection: CampaignSelection;
	onChange: (selection: CampaignSelection) => void;
}) {
	const count = selection.mode === "all" ? options.length : selection.allowedIds.length;
	return <section className="space-y-4 rounded-2xl border border-(--edge)/70 bg-(--surface) p-5 md:p-6">
		<div className="flex items-center justify-between gap-3">
			<h3 className="font-serif text-2xl">{title}</h3>
			<span className="font-mono text-xs text-(--muted)">{count} de {options.length}</span>
		</div>
		<p className="text-sm text-(--muted)">Desmarque as opções que não estarão disponíveis nesta campanha.</p>
		<div className="grid gap-3 sm:grid-cols-2">
			{options.map((option) => <RpgCheckbox key={option.id} label={option.name} checked={selection.mode === "all" || selection.allowedIds.includes(option.id)} onChange={() => onChange(toggleOption(selection, options, option.id))} />)}
		</div>
	</section>;
}

export function CampaignSettingsStep({
	draft, system, options, supplements, coverUrl, pending, error, onDraft, onBack, onCreate,
}: {
	draft: CampaignDraft; system: RpgSystem; options: CharacterOptions; supplements: Supplement[]; coverUrl: string;
	pending: boolean; error: Error | null;
	onDraft: (draft: CampaignDraft) => void;
	onBack: () => void;
	onCreate: (mode: "guided" | "free") => Promise<void>;
}) {
	const form = useForm({
		defaultValues: { sheetMode: draft.sheetMode },
		validators: { onSubmit: modeSchema },
		onSubmit: async ({ value }) => {
			if (value.sheetMode === "guided" || value.sheetMode === "free") await onCreate(value.sheetMode);
		},
	});
	const classCount = draft.classes.mode === "all" ? options.classes.length : draft.classes.allowedIds.length;
	const visibleOrigins = options.origins.filter((option) => !option.supplementId || option.supplementId === draft.supplement?.id);
	const originCount = draft.origins.mode === "all" ? visibleOrigins.length : draft.origins.allowedIds.length;
	return <div className="grid gap-6 xl:grid-cols-[minmax(0,1fr)_22rem] xl:items-start">
		<RpgForm onSubmit={() => form.handleSubmit()}>
			<div className="space-y-6">
				<p className="font-mono text-[10px] uppercase tracking-[0.22em] text-(--accent)">02 / Detalhes de {system.name}</p>
				<AllowedOptions title="Classes disponíveis" options={options.classes} selection={draft.classes} onChange={(classes) => onDraft({ ...draft, classes })} />
				<AllowedOptions title="Origens disponíveis" options={visibleOrigins} selection={draft.origins} onChange={(origins) => onDraft({ ...draft, origins })} />
				<SupplementSettingsPanel supplements={supplements} systemId={system.id} value={draft.supplement} onChange={(supplement) => onDraft({ ...draft, supplement, origins: draft.origins.mode === "selected" ? { ...draft.origins, allowedIds: draft.origins.allowedIds.filter((id) => options.origins.some((option) => option.id === id && (!option.supplementId || option.supplementId === supplement?.id))) } : draft.origins })} />
				<section className="space-y-4 rounded-2xl border border-(--edge)/70 bg-(--surface) p-5 md:p-6">
					<h3 className="font-serif text-2xl">Modo da ficha</h3>
					<p className="text-sm text-(--muted)">Defina como os jogadores preencherão as fichas desta campanha.</p>
					<form.Field name="sheetMode">{(field) => <RpgSelect label="Como será a ficha do jogador?" value={field.state.value} onChange={(value) => { if (value === "guided" || value === "free") { field.handleChange(value); onDraft({ ...draft, sheetMode: value }); } }} options={[{ value: "", label: "Selecione um modo", disabled: true }, { value: "guided", label: "Guiada" }, { value: "free", label: "Livre" }]} />}</form.Field>
					<form.Subscribe selector={(state) => state.errors}>{(errors) => errors.length > 0 ? <p role="alert" className="text-sm text-(--danger)">Escolha o modo da ficha.</p> : null}</form.Subscribe>
				</section>
				{classCount === 0 && <p role="status" className="rounded-xl border border-(--danger) p-4 text-sm text-(--danger)">Nenhuma classe está liberada. Novas fichas precisarão usar o modo sobrevivente ou aguardar a liberação de uma classe na campanha.</p>}
				<MutationFeedback error={error} success={false} />
				<div className="flex flex-wrap gap-3"><RpgButton secondary disabled={pending} onClick={onBack}>Voltar aos dados básicos</RpgButton><RpgButton submit loading={pending}>Criar campanha</RpgButton></div>
			</div>
		</RpgForm>
		<aside className="space-y-4 xl:sticky xl:top-24">
			<CampaignPreview name={draft.name} description={draft.description} system={system} coverUrl={coverUrl} />
			<div className="rounded-2xl border border-(--edge)/70 bg-(--surface) p-5 text-sm">
				<h3 className="font-serif text-xl">Resumo da campanha</h3>
				<p className="mt-3">Classes: {draft.classes.mode === "all" ? "todas, incluindo futuras" : `${classCount} selecionadas`}</p>
				<p className="mt-1">Origens: {draft.origins.mode === "all" ? "todas, incluindo futuras" : `${originCount} selecionadas`}</p>
				<p className="mt-1">Ficha: {draft.sheetMode === "guided" ? "guiada" : draft.sheetMode === "free" ? "livre" : "não escolhida"}</p>
					<p className="mt-1">Suplemento: {draft.supplement ? "ativo" : "desligado"}</p>
			</div>
		</aside>
	</div>;
}
