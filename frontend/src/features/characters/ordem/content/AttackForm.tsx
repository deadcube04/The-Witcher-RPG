import { useForm } from "@tanstack/react-form";
import { useQuery } from "@tanstack/react-query";
import { MutationFeedback } from "@/components/feedback/RemoteState";
import { RpgForm } from "@/components/forms/RpgForm";
import {
	RpgButton,
	RpgInput,
	RpgNumber,
	RpgSelect,
} from "@/components/primitives/RpgControls";
import { queries } from "@/shared/api/queries";
import {
	type OrdemAttackInput,
	ordemAttackInputSchema,
} from "@/shared/contracts/ordem-attack";
import { fieldError } from "@/shared/lib/form-error";

export function AttackForm({
	initial,
	pending,
	error,
	onSave,
	submitLabel = "Salvar homebrew",
}: {
	initial: OrdemAttackInput;
	pending: boolean;
	error: Error | null;
	onSave: (input: OrdemAttackInput) => Promise<void>;
	submitLabel?: string;
}) {
	const options = useQuery(queries.characterOptions);
	const form = useForm({
		defaultValues: initial,
		validators: { onSubmit: ordemAttackInputSchema },
		onSubmit: ({ value }) => onSave(value),
	});
	return (
		<RpgForm onSubmit={() => form.handleSubmit()}>
			<div className="grid gap-5 sm:grid-cols-2">
				<form.Field name="name">
					{(field) => (
						<RpgInput
							label="Nome"
							value={field.state.value}
							onChange={field.handleChange}
							disabled={pending}
							error={fieldError(field.state.meta.errors)}
						/>
					)}
				</form.Field>
				<form.Field name="skillId">
					{(field) => (
						<RpgSelect
							label="Perícia"
							value={field.state.value ?? ""}
							onChange={(skillId) => { const skill = options.data?.skills.find((entry) => entry.id === skillId); field.handleChange(skillId || null); form.setFieldValue("skillName", skill?.name ?? ""); }}
							options={[{ value: "", label: "Selecione uma perícia" }, ...(options.data?.skills ?? []).map((entry) => ({ value: entry.id, label: entry.name }))]}
							disabled={pending || options.isPending || !!options.error}
						/>
					)}
				</form.Field>
				<form.Field name="testExpression">
					{(field) => (
						<RpgInput
							label="Teste"
							value={field.state.value}
							onChange={field.handleChange}
							disabled={pending}
							hint="Formato: XdY, com bônus opcional."
						/>
					)}
				</form.Field>
				<form.Field name="damageExpression">
					{(field) => (
						<RpgInput
							label="Dano"
							value={field.state.value}
							onChange={field.handleChange}
							disabled={pending}
							hint="Formato: XdY, com bônus opcional."
						/>
					)}
				</form.Field>
				<form.Field name="damageType">
					{(field) => (
						<RpgInput
							label="Tipo de dano"
							value={field.state.value}
							onChange={field.handleChange}
							disabled={pending}
						/>
					)}
				</form.Field>
				<form.Field name="rangeText">
					{(field) => (
						<RpgInput
							label="Alcance"
							value={field.state.value}
							onChange={field.handleChange}
							disabled={pending}
						/>
					)}
				</form.Field>
				<form.Field name="criticalThreshold">
					{(field) => (
						<RpgNumber
							label="Margem crítica"
							value={field.state.value}
							onChange={field.handleChange}
							min={2}
							max={20}
							disabled={pending}
						/>
					)}
				</form.Field>
				<form.Field name="criticalMultiplier">
					{(field) => (
						<RpgNumber
							label="Multiplicador crítico"
							value={field.state.value}
							onChange={field.handleChange}
							min={2}
							max={10}
							disabled={pending}
						/>
					)}
				</form.Field>
			</div>
			<form.Field name="description">
				{(field) => (
					<RpgInput
						label="Descrição"
						value={field.state.value}
						onChange={field.handleChange}
						multiline
						disabled={pending}
					/>
				)}
			</form.Field>
			<form.Field name="special">
				{(field) => (
					<RpgInput
						label="Especial"
						value={field.state.value}
						onChange={field.handleChange}
						multiline
						disabled={pending}
					/>
				)}
			</form.Field>
			<form.Subscribe selector={(state) => state.errors}>
				{(errors) =>
					errors.length > 0 ? <p role="alert">{fieldError(errors)}</p> : null
				}
			</form.Subscribe>
			<MutationFeedback error={error} success={false} />
			<RpgButton submit loading={pending}>
				{submitLabel}
			</RpgButton>
		</RpgForm>
	);
}
