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
export function parseDiceExpression(expression: string): DiceInput | null {
	const match = /^\s*(\d+)\s*d\s*(\d+)\s*([+-]\s*\d+)?\s*$/i.exec(expression);
	if (!match) return null;
	const candidate = {
		quantity: Number(match[1]),
		sides: Number(match[2]),
		modifier: Number((match[3] ?? "0").replaceAll(" ", "")),
	};
	const parsed = diceInputSchema.safeParse(candidate);
	return parsed.success ? parsed.data : null;
}
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
			(modifier === 0
				? ""
				: (modifier > 0 ? " + " : " − ") + Math.abs(modifier)),
	};
}
export function rollOrdemTest(input: { diceCount: number; keep: "highest" | "lowest"; bonus: number }): RollResult {
	const rolled = rollDice({ sides: 20, quantity: input.diceCount, modifier: 0 });
	const selected = input.keep === "highest" ? Math.max(...rolled.individual) : Math.min(...rolled.individual);
	return {
		individual: rolled.individual,
		total: selected + input.bonus,
		expression: `${input.diceCount}D20 (${input.keep === "highest" ? "maior" : "menor"})${input.bonus === 0 ? "" : input.bonus > 0 ? ` + ${input.bonus}` : ` − ${Math.abs(input.bonus)}`}`,
	};
}
