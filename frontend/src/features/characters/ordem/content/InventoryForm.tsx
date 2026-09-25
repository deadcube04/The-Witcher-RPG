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
	type OrdemInventoryInput,
	type InventoryKind,
	ordemInventoryInputSchema,
} from "@/shared/contracts/ordem-inventory";
import { fieldError } from "@/shared/lib/form-error";

const kindOptions = [
	{ value: "weapon", label: "Arma" },
	{ value: "protection", label: "Proteção" },
	{ value: "ammunition", label: "Munição" },
	{ value: "accessory", label: "Acessório" },
	{ value: "equipment", label: "Equipamento" },
	{ value: "paranormal", label: "Paranormal" },
	{ value: "other", label: "Outro" },
];

function isNonWeaponKind(
	value: string,
): value is Exclude<InventoryKind, "weapon"> {
	return (
		value === "protection" ||
		value === "ammunition" ||
		value === "accessory" ||
		value === "equipment" ||
		value === "paranormal" ||
		value === "other"
	);
}

export function InventoryForm({
	initial,
	pending,
	error,
	onSave,
	submitLabel = "Salvar homebrew",
}: {
	initial: OrdemInventoryInput;
	pending: boolean;
	error: Error | null;
	onSave: (input: OrdemInventoryInput) => Promise<void>;
	submitLabel?: string;
}) {
	const form = useForm({
		defaultValues: initial,
		validators: { onSubmit: ordemInventoryInputSchema },
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
							onBlur={field.handleBlur}
							disabled={pending}
							error={fieldError(field.state.meta.errors)}
						/>
					)}
				</form.Field>
				<form.Field name="kind">
					{(field) => (
						<RpgSelect
							label="Tipo"
							value={field.state.value}
							onChange={(value) => {
								if (value === "weapon") {
									form.reset({
										...form.state.values,
										kind: "weapon",
										damageExpression: "1d6",
										criticalThreshold: 20,
										criticalMultiplier: 2,
										rangeText: "Corpo a corpo",
										damageType: "",
									});
									return;
								}
								if (isNonWeaponKind(value)) {
									const current = form.state.values;
									form.reset({
										kind: value,
										name: current.name,
										description: current.description,
										category: current.category,
										spaces: current.spaces,
									});
								}
							}}
							options={kindOptions}
							disabled={pending}
						/>
					)}
				</form.Field>
				<form.Field name="category">
					{(field) => (
						<RpgSelect
							label="Categoria"
							value={
								field.state.value === null ? "none" : String(field.state.value)
							}
							onChange={(value) =>
								field.handleChange(value === "none" ? null : Number(value))
							}
							options={[
								{ value: "none", label: "Sem categoria" },
								...Array.from({ length: 5 }, (_, category) => ({
									value: String(category),
									label: `Categoria ${category}`,
								})),
							]}
							disabled={pending}
						/>
					)}
				</form.Field>
				<form.Field name="spaces">
					{(field) => (
						<RpgNumber
							label="Espaços"
							value={field.state.value}
							onChange={field.handleChange}
							min={0}
							max={99}
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
			<form.Subscribe selector={(state) => state.values}>
				{(values) =>
					values.kind === "weapon" ? (
						<div className="grid gap-5 rounded-xl border border-(--edge) p-4 sm:grid-cols-2">
							<form.Field name="damageExpression">
								{(field) => (
									<RpgInput
										label="Dano"
										value={field.state.value}
										onChange={field.handleChange}
										disabled={pending}
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
						</div>
					) : null
				}
			</form.Subscribe>
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
