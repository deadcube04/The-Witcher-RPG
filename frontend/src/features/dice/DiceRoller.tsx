import { useForm } from "@tanstack/react-form";
import { useState } from "react";
import { RpgForm } from "../../components/forms/RpgForm";
import { AnimatedResult } from "../../components/motion/AnimatedPage";
import {
	RpgButton,
	RpgNumber,
	RpgSelect,
} from "../../components/primitives/RpgControls";
import { fieldError } from "../../shared/lib/form-error";
import { diceInputSchema, diceSides, type RollResult, rollDice } from "./roll";

export function DiceRoller() {
	const [result, setResult] = useState<
		(RollResult & { sequence: number }) | null
	>(null);
	const form = useForm({
		defaultValues: { sides: 20, quantity: 1, modifier: 0 },
		validators: { onSubmit: diceInputSchema },
		onSubmit: ({ value }) => {
			const roll = rollDice(value);
			setResult((previous) => ({
				...roll,
				sequence: (previous?.sequence ?? 0) + 1,
			}));
		},
	});
	return (
		<section
			aria-label="Rolagem de dados"
			className="border border-(--edge) bg-(--panel) p-5 md:p-7"
		>
			<h3 className="mb-5 text-2xl">Deixe os dados decidirem</h3>
			<RpgForm onSubmit={() => form.handleSubmit()}>
				<div className="grid gap-4 sm:grid-cols-3">
					<form.Field name="sides">
						{(field) => (
							<RpgSelect
								label="Dado"
								value={String(field.state.value)}
								onChange={(value) => field.handleChange(Number(value))}
								options={diceSides.map((sides) => ({
									value: String(sides),
									label: `D${sides}`,
								}))}
							/>
						)}
					</form.Field>
					<form.Field name="quantity">
						{(field) => (
							<RpgNumber
								label="Quantidade"
								value={field.state.value}
								onChange={field.handleChange}
								min={1}
								max={100}
							/>
						)}
					</form.Field>
					<form.Field name="modifier">
						{(field) => (
							<RpgNumber
								label="Modificador"
								value={field.state.value}
								onChange={field.handleChange}
								min={-999}
								max={999}
							/>
						)}
					</form.Field>
				</div>
				<form.Subscribe selector={(state) => state.errors}>
					{(errors) =>
						errors.length > 0 ? (
							<p role="alert">
								{fieldError(errors) || "Confira a quantidade e o modificador."}
							</p>
						) : null
					}
				</form.Subscribe>
				<RpgButton submit>Rolar dados</RpgButton>
			</RpgForm>
			<div aria-live="polite" aria-atomic="true" className="mt-6">
				{result && (
					<AnimatedResult resultKey={result.sequence}>
						<p className="font-mono text-sm text-(--accent)">
							{result.expression}
						</p>
						<p className="my-3 font-mono text-5xl">
							<span className="mr-3 text-sm">Total</span>
							{result.total}
						</p>
						<p className="break-words text-sm opacity-75">
							Resultados: {result.individual.join(", ")}
						</p>
					</AnimatedResult>
				)}
			</div>
		</section>
	);
}
