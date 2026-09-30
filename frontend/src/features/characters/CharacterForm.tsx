import { useState } from "react";
import { PhotoField } from "@/features/media/PhotoField";
import { useForm } from "@tanstack/react-form";
import { MutationFeedback } from "@/components/feedback/RemoteState";
import { RpgForm } from "@/components/forms/RpgForm";
import { RpgButton, RpgInput } from "@/components/primitives/RpgControls";
import type { Campaign } from "@/shared/contracts/campaign";
import {
	type CharacterInput,
	characterInputSchema,
} from "@/shared/contracts/character-sheet";
import type { RpgSystem } from "@/shared/contracts/rpg-system";
import { fieldError } from "@/shared/lib/form-error";
import { CharacterAssociation } from "@/features/characters/CharacterAssociation";
import { characterSheetRegistry } from "@/features/characters/registry";

const narrativeFields = [
	{ name: "description", label: "Descrição" },
	{ name: "appearance", label: "Aparência" },
	{ name: "personality", label: "Personalidade" },
	{ name: "background", label: "Histórico" },
	{ name: "objective", label: "Objetivo" },
] as const;
export function CharacterForm({
	initial,
	systems,
	campaigns,
	pending,
	error,
	onSave,
	systemLocked = false,
}: {
	initial: CharacterInput;
	systems: RpgSystem[];
	campaigns: Campaign[];
	pending: boolean;
	error: Error | null;
	onSave: (input: CharacterInput) => Promise<void>;
	systemLocked?: boolean;
}) {
	const [photoBusy, setPhotoBusy] = useState(false);
	const schema = characterInputSchema.refine(
		(input) =>
			input.campaignId === null ||
			campaigns.some(
				(campaign) =>
					campaign.id === input.campaignId &&
					campaign.systemId === input.systemId,
			),
		{ message: "Escolha uma campanha do mesmo sistema.", path: ["campaignId"] },
	).refine(
		(input) => input.systemData.kind !== "ordem-paranormal" || input.systemData.classId !== null,
		{ message: "Escolha uma classe.", path: ["systemData", "classId"] },
	);
	const form = useForm({
		defaultValues: initial,
		validators: { onSubmit: schema },
		onSubmit: async ({ value }) => onSave(value),
	});
	return (
		<RpgForm onSubmit={() => form.handleSubmit()}>
			<section className="space-y-6 rounded-2xl border border-(--edge)/60 bg-(--canvas)/35 p-5 md:p-6">
				<h3 className="border-b border-(--edge) pb-3 text-xl">
					01 / Identidade
				</h3>
				<form.Field name="imageUrl">{(field) => <PhotoField purpose="character" value={field.state.value} onChange={field.handleChange} disabled={pending} onBusyChange={setPhotoBusy} />}</form.Field>
				<form.Field name="name">
					{(field) => (
						<RpgInput
							label="Nome do personagem"
							value={field.state.value}
							onChange={field.handleChange}
							onBlur={field.handleBlur}
							disabled={pending}
							error={fieldError(field.state.meta.errors)}
						/>
					)}
				</form.Field>
				<form.Subscribe selector={(state) => state.values}>
					{(values) => (
						<CharacterAssociation
							systemId={values.systemId}
							campaignId={values.campaignId}
							systems={systems}
							campaigns={campaigns}
							disabled={pending}
							systemLocked={systemLocked}
							onCampaignChange={(id) => {
								form.setFieldValue("campaignId", id);
								const campaign = campaigns.find((entry) => entry.id === id);
								const data = form.state.values.systemData;
								if (!campaign || data.kind !== "ordem-paranormal") return;
								const classAllowed = campaign.settings.classes.mode === "all" || (data.classId !== null && campaign.settings.classes.allowedIds.includes(data.classId));
								const originAllowed = campaign.settings.origins.mode === "all" || data.originId === null || campaign.settings.origins.allowedIds.includes(data.originId);
								if (!classAllowed || !originAllowed) form.setFieldValue("systemData", { ...data, classId: classAllowed ? data.classId : null, originId: originAllowed ? data.originId : null });
							}}
							onSystemChange={(id) => {
								const system = systems.find((entry) => entry.id === id);
								const definition =
									system && characterSheetRegistry.get(system.slug);
								if (!definition) return;
								form.setFieldValue("systemId", id);
								form.setFieldValue("campaignId", null);
								form.setFieldValue("systemData", definition.createData());
							}}
						/>
					)}
				</form.Subscribe>
				<form.Field name="campaignId">
					{(field) =>
						field.state.meta.errors.length ? (
							<p role="alert">{fieldError(field.state.meta.errors)}</p>
						) : null
					}
				</form.Field>
			</section>
			<form.Field name="systemData">
				{(field) => {
					const definition = characterSheetRegistry.get(field.state.value.kind);
					const Editor = definition?.Editor;
					return (
						<>
							<section>
								{Editor ? (
									<form.Subscribe selector={(state) => state.values.campaignId}>
										{(campaignId) => <Editor
											value={field.state.value}
											onChange={field.handleChange}
											disabled={pending}
											campaign={campaigns.find((entry) => entry.id === campaignId)}
										/>}
									</form.Subscribe>
								) : (
									<p className="border border-(--edge) p-5 text-sm">
										Cadastro narrativo disponível. As regras específicas deste
										sistema serão adicionadas em uma próxima edição.
									</p>
								)}
							</section>
							{field.state.meta.errors.length > 0 && (
								<p role="alert">{fieldError(field.state.meta.errors)}</p>
							)}
						</>
					);
				}}
			</form.Field>
			<section className="space-y-5 rounded-2xl border border-(--edge)/60 bg-(--canvas)/35 p-5 md:p-6">
				<h3 className="border-b border-(--edge) pb-3 text-xl">
					História do personagem
				</h3>
				<div className="grid gap-5 md:grid-cols-2">
					{narrativeFields.map(({ name, label }) => (
						<form.Field key={name} name={name}>
							{(field) => (
								<RpgInput
									label={label}
									multiline
									value={field.state.value}
									onChange={field.handleChange}
									onBlur={field.handleBlur}
									disabled={pending}
									error={fieldError(field.state.meta.errors)}
								/>
							)}
						</form.Field>
					))}
				</div>
			</section>
			<MutationFeedback error={error} success={false} />
			<RpgButton submit disabled={photoBusy} loading={pending}>
				Salvar ficha
			</RpgButton>
		</RpgForm>
	);
}
