import { useForm } from "@tanstack/react-form";
import { z } from "zod";
import { RpgForm } from "@/components/forms/RpgForm";
import { RpgButton, RpgCheckbox, RpgSelect } from "@/components/primitives/RpgControls";
import { MutationFeedback } from "@/components/feedback/RemoteState";
import type { CharacterOptions } from "@/shared/contracts/character-options";
import type { CampaignSelection } from "@/shared/contracts/campaign";
import { CampaignPreview } from "@/features/campaigns/CampaignPreview";
import type { CampaignDraft } from "@/features/campaigns/campaign-draft";
import type { RpgSystem } from "@/shared/contracts/rpg-system";

const modeSchema = z.strictObject({ sheetMode: z.enum(["guided", "free"]) });
type Option = CharacterOptions["classes"][number];

function toggleOption(selection: CampaignSelection, options: Option[], id: string): CampaignSelection {
	const selected = selection.mode === "all" ? options.map((option) => option.id) : selection.allowedIds;
	const next = selected.includes(id) ? selected.filter((item) => item !== id) : [...selected, id];
	return next.length === options.length ? { mode: "all", allowedIds: [] } : { mode: "selected", allowedIds: next };
}

function AllowedOptions({ title, options, selection, onChange }: {
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
	draft, system, options, coverUrl, pending, error, onDraft, onBack, onCreate,
}: {
	draft: CampaignDraft; system: RpgSystem; options: CharacterOptions; coverUrl: string;
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
	const originCount = draft.origins.mode === "all" ? options.origins.length : draft.origins.allowedIds.length;
	return <div className="grid gap-6 xl:grid-cols-[minmax(0,1fr)_22rem] xl:items-start">
		<RpgForm onSubmit={() => form.handleSubmit()}>
			<div className="space-y-6">
				<p className="font-mono text-[10px] uppercase tracking-[0.22em] text-(--accent)">02 / Detalhes de {system.name}</p>
				<AllowedOptions title="Classes disponíveis" options={options.classes} selection={draft.classes} onChange={(classes) => onDraft({ ...draft, classes })} />
				<AllowedOptions title="Origens disponíveis" options={options.origins} selection={draft.origins} onChange={(origins) => onDraft({ ...draft, origins })} />
				<section className="space-y-4 rounded-2xl border border-(--edge)/70 bg-(--surface) p-5 md:p-6">
					<h3 className="font-serif text-2xl">Modo da ficha</h3>
					<p className="text-sm text-(--muted)">Esta escolha será guardada para o editor de fichas futuro. O editor atual continua livre.</p>
					<form.Field name="sheetMode">{(field) => <RpgSelect label="Como será a ficha do jogador?" value={field.state.value} onChange={(value) => { if (value === "guided" || value === "free") { field.handleChange(value); onDraft({ ...draft, sheetMode: value }); } }} options={[{ value: "", label: "Selecione um modo", disabled: true }, { value: "guided", label: "Guiada" }, { value: "free", label: "Livre" }]} />}</form.Field>
					<form.Subscribe selector={(state) => state.errors}>{(errors) => errors.length > 0 ? <p role="alert" className="text-sm text-(--danger)">Escolha o modo da ficha.</p> : null}</form.Subscribe>
				</section>
				<div className="grid gap-3 sm:grid-cols-2">
					<section aria-disabled="true" className="rounded-2xl border border-dashed border-(--edge) bg-(--surface)/50 p-5 opacity-70"><h3 className="font-serif text-xl">Regras opcionais</h3><p className="mt-2 text-sm">Configuração disponível em uma próxima entrega.</p></section>
					<section aria-disabled="true" className="rounded-2xl border border-dashed border-(--edge) bg-(--surface)/50 p-5 opacity-70"><h3 className="font-serif text-xl">Suplementos</h3><p className="mt-2 text-sm">Expansões deste sistema poderão ser escolhidas futuramente.</p></section>
				</div>
				{classCount === 0 && <p role="status" className="rounded-xl border border-(--danger) p-4 text-sm text-(--danger)">Nenhuma classe está liberada. Esta campanha não poderá receber novas fichas até existir edição de campanhas.</p>}
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
			</div>
		</aside>
	</div>;
}
