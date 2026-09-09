import { z } from "zod";
export const diceSides = [4, 6, 8, 10, 12, 20, 100];
export const diceInputSchema = z.object({
	sides: z.number().refine((value) => diceSides.includes(value)),
	quantity: z.number().int().min(1).max(100),
	modifier: z.number().int().min(-999).max(999),
});
export type DiceInput = z.infer<typeof diceInputSchema>;
export type RollResult = {
	individual: number[];
	total: number;
	expression: string;
};
export function rollDice(
	input: DiceInput,
	random: () => number = Math.random,
): RollResult {
	const { sides, quantity, modifier } = diceInputSchema.parse(input);
	const individual = Array.from({ length: quantity }, () => {
		const sample = random();
		if (!Number.isFinite(sample) || sample < 0 || sample >= 1)
			throw new Error("Fonte de aleatoriedade inválida.");
		return Math.floor(sample * sides) + 1;
	});
	return {
		individual,
		total: individual.reduce((total, value) => total + value, modifier),
		expression:
			quantity +
			"D" +
			sides +
			(modifier >= 0 ? " + " : " − ") +
			Math.abs(modifier),
	};
}
