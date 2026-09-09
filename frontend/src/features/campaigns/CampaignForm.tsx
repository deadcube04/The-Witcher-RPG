import { useForm } from "@tanstack/react-form";
import { MutationFeedback } from "../../components/feedback/RemoteState";
import { RpgForm } from "../../components/forms/RpgForm";
import {
	RpgButton,
	RpgInput,
	RpgSelect,
} from "../../components/primitives/RpgControls";
import {
	type CampaignInput,
	campaignInputSchema,
} from "../../shared/contracts/campaign";
import type { RpgSystem } from "../../shared/contracts/rpg-system";
import { fieldError } from "../../shared/lib/form-error";

export function CampaignForm({
	initial,
	systems,
	pending,
	error,
	onSave,
	systemLocked = false,
}: {
	initial: CampaignInput;
	systems: RpgSystem[];
	pending: boolean;
	error: Error | null;
	onSave: (input: CampaignInput) => Promise<void>;
	systemLocked?: boolean;
}) {
	const form = useForm({
		defaultValues: initial,
		validators: { onSubmit: campaignInputSchema },
		onSubmit: async ({ value }) => onSave(value),
	});
	return (
		<RpgForm onSubmit={() => form.handleSubmit()}>
			<form.Field name="name">
				{(field) => (
					<RpgInput
						label="Nome da campanha"
						value={field.state.value}
						onChange={field.handleChange}
						onBlur={field.handleBlur}
						disabled={pending}
						error={fieldError(field.state.meta.errors)}
					/>
				)}
			</form.Field>
			<div className="grid gap-5 md:grid-cols-2">
				<form.Field name="systemId">
					{(field) => (
						<RpgSelect
							label="Sistema da campanha"
							value={field.state.value}
							onChange={field.handleChange}
							disabled={pending || systemLocked}
							options={systems.map((system) => ({
								value: system.id,
								label: system.name,
							}))}
						/>
					)}
				</form.Field>
				<form.Field name="status">
					{(field) => (
						<RpgSelect
							label="Status"
							value={field.state.value}
							onChange={(value) => {
								if (value === "active" || value === "archived")
									field.handleChange(value);
							}}
							disabled={pending}
							options={[
								{ value: "active", label: "Em andamento" },
								{ value: "archived", label: "Arquivada" },
							]}
						/>
					)}
				</form.Field>
			</div>
			{systemLocked && (
				<p className="text-sm opacity-75">
					O sistema está vinculado às fichas desta campanha.
				</p>
			)}
			<form.Field name="description">
				{(field) => (
					<RpgInput
						label="Descrição"
						multiline
						value={field.state.value}
						onChange={field.handleChange}
						onBlur={field.handleBlur}
						disabled={pending}
						error={fieldError(field.state.meta.errors)}
					/>
				)}
			</form.Field>
			<MutationFeedback error={error} success={false} />
			<RpgButton submit loading={pending}>
				Salvar campanha
			</RpgButton>
		</RpgForm>
	);
}
