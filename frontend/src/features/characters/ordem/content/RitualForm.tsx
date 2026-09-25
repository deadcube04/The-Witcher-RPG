import { useForm } from "@tanstack/react-form";
import { MutationFeedback } from "@/components/feedback/RemoteState";
import { RpgForm } from "@/components/forms/RpgForm";
import {
	RpgButton,
	RpgInput,
	RpgNumber,
	RpgSelect,
} from "@/components/primitives/RpgControls";
import {
	type OrdemRitualInput,
	ordemRitualInputSchema,
	type RitualTier,
} from "@/shared/contracts/ordem-ritual";
import { fieldError } from "@/shared/lib/form-error";

function TierEditor({
	label,
	value,
	onChange,
	disabled,
}: {
	label: string;
	value: RitualTier;
	onChange: (value: RitualTier) => void;
	disabled: boolean;
}) {
	return (
		<section className="space-y-4 rounded-xl border border-(--edge) bg-(--canvas) p-4">
			<h4 className="font-semibold text-(--accent)">{label}</h4>
			<RpgNumber
				label="Custo de PE"
				value={value.peCost}
				onChange={(peCost) => onChange({ ...value, peCost })}
				min={0}
				max={99}
				disabled={disabled}
			/>
			<RpgInput
				label="Efeito"
				value={value.effect}
				onChange={(effect) => onChange({ ...value, effect })}
				multiline
				disabled={disabled}
			/>
			{value.rolls.map((roll, index) => (
				<div
					key={index}
					className="grid gap-4 rounded-lg border border-(--edge) p-3 sm:grid-cols-2"
				>
					<RpgInput
						label="Nome da rolagem"
						value={roll.label}
						onChange={(rollLabel) =>
							onChange({
								...value,
								rolls: value.rolls.map((item, itemIndex) =>
									itemIndex === index ? { ...item, label: rollLabel } : item,
								),
							})
						}
						disabled={disabled}
					/>
					<RpgInput
						label="Expressão"
						value={roll.expression}
						onChange={(expression) =>
							onChange({
								...value,
								rolls: value.rolls.map((item, itemIndex) =>
									itemIndex === index ? { ...item, expression } : item,
								),
							})
						}
						hint="Formato: XdY, com bônus opcional."
						disabled={disabled}
					/>
					<RpgButton
						secondary
						disabled={disabled}
						onClick={() =>
							onChange({
								...value,
								rolls: value.rolls.filter(
									(_, itemIndex) => itemIndex !== index,
								),
							})
						}
					>
						Remover rolagem
					</RpgButton>
				</div>
			))}
			<RpgButton
				secondary
				disabled={disabled || value.rolls.length >= 8}
				onClick={() =>
					onChange({
						...value,
						rolls: [
							...value.rolls,
							{ label: "Intensidade", expression: "1d6" },
						],
					})
				}
			>
				Adicionar rolagem
			</RpgButton>
		</section>
	);
}

export function RitualForm({
	initial,
	pending,
	error,
	onSave,
	submitLabel = "Salvar homebrew",
}: {
	initial: OrdemRitualInput;
	pending: boolean;
	error: Error | null;
	onSave: (input: OrdemRitualInput) => Promise<void>;
	submitLabel?: string;
}) {
	const form = useForm({
		defaultValues: initial,
		validators: { onSubmit: ordemRitualInputSchema },
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
				<form.Field name="element">
					{(field) => (
						<RpgSelect
							label="Elemento"
							value={field.state.value}
							onChange={(value) => {
								if (
									value === "blood" ||
									value === "death" ||
									value === "knowledge" ||
									value === "energy" ||
									value === "fear"
								)
									field.handleChange(value);
							}}
							options={[
								{ value: "blood", label: "Sangue" },
								{ value: "death", label: "Morte" },
								{ value: "knowledge", label: "Conhecimento" },
								{ value: "energy", label: "Energia" },
								{ value: "fear", label: "Medo" },
							]}
							disabled={pending}
						/>
					)}
				</form.Field>
				<form.Field name="circle">
					{(field) => (
						<RpgNumber
							label="Círculo"
							value={field.state.value}
							onChange={field.handleChange}
							min={1}
							max={4}
							disabled={pending}
						/>
					)}
				</form.Field>
				<form.Field name="execution">
					{(field) => (
						<RpgInput
							label="Execução"
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
				<form.Field name="targetText">
					{(field) => (
						<RpgInput
							label="Alvo"
							value={field.state.value}
							onChange={field.handleChange}
							disabled={pending}
						/>
					)}
				</form.Field>
				<form.Field name="areaText">
					{(field) => (
						<RpgInput
							label="Área"
							value={field.state.value}
							onChange={field.handleChange}
							disabled={pending}
						/>
					)}
				</form.Field>
				<form.Field name="durationText">
					{(field) => (
						<RpgInput
							label="Duração"
							value={field.state.value}
							onChange={field.handleChange}
							disabled={pending}
						/>
					)}
				</form.Field>
			</div>
			<form.Field name="resistanceText">
				{(field) => (
					<RpgInput
						label="Resistência"
						value={field.state.value}
						onChange={field.handleChange}
						disabled={pending}
					/>
				)}
			</form.Field>
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
			<div className="grid gap-4 lg:grid-cols-3">
				<form.Field name="tiers.normal">
					{(field) => (
						<TierEditor
							label="Normal"
							value={field.state.value}
							onChange={field.handleChange}
							disabled={pending}
						/>
					)}
				</form.Field>
				<form.Field name="tiers.discente">
					{(field) => (
						<TierEditor
							label="Discente"
							value={field.state.value}
							onChange={field.handleChange}
							disabled={pending}
						/>
					)}
				</form.Field>
				<form.Field name="tiers.verdadeiro">
					{(field) => (
						<TierEditor
							label="Verdadeiro"
							value={field.state.value}
							onChange={field.handleChange}
							disabled={pending}
						/>
					)}
				</form.Field>
			</div>
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
