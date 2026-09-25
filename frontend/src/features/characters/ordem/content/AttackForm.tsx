import { useForm } from "@tanstack/react-form";
import { MutationFeedback } from "@/components/feedback/RemoteState";
import { RpgForm } from "@/components/forms/RpgForm";
import {
	RpgButton,
	RpgInput,
	RpgNumber,
} from "@/components/primitives/RpgControls";
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
				<form.Field name="skillName">
					{(field) => (
						<RpgInput
							label="Perícia"
							value={field.state.value}
							onChange={field.handleChange}
							disabled={pending}
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
