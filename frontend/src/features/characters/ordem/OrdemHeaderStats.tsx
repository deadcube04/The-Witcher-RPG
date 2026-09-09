import { RpgInlineSelect } from "../../../components/primitives/RpgControls";
import type { OrdemData } from "../../../shared/contracts/character-sheet";
import catalog from "../../../shared/contracts/ordem-catalog.json";

const nexOptions = [
	...Array.from({ length: 20 }, (_, index) => index * 5),
	99,
].map((nex) => ({ value: String(nex), label: `${nex}%` }));
const creditOptions = [
	{ value: "", label: "Não definido" },
	{ value: "BAIXO", label: "Baixo" },
	{ value: "MEDIO", label: "Médio" },
	{ value: "ALTO", label: "Alto" },
	{ value: "ILIMITADO", label: "Ilimitado" },
] as const;
type CreditLimit = NonNullable<OrdemData["creditLimit"]>;

function isCreditLimit(value: string): value is CreditLimit {
	return creditOptions.some((option) => option.value === value && value !== "");
}

export function OrdemHeaderStats({
	value,
	onChange,
}: {
	value: OrdemData;
	onChange?: (value: OrdemData) => void;
}) {
	const stats = [
		["NEX", `${value.nex}%`],
		[
			"Classe",
			catalog.class_definition.find((entry) => entry.id === value.classId)
				?.name ?? "Não definida",
		],
		[
			"Origem",
			catalog.origin_definition.find((entry) => entry.id === value.originId)
				?.name ?? "Não definida",
		],
		["Crédito", value.creditLimit ?? "Não definido"],
		["Deslocamento", "9m / 6q"],
	] as const;

	return (
		<section
			aria-label="Resumo da ficha"
			className="mb-4 min-w-0 border-b border-(--edge) px-2 py-2"
		>
			<dl className="grid grid-cols-2 divide-x divide-y divide-(--edge) sm:grid-cols-5 sm:divide-y-0">
				{stats.map(([label, text]) => (
					<div
						key={label}
						className="min-w-0 px-3 py-1 first:pl-0 sm:last:pr-0"
					>
						<dt className="truncate text-xs font-semibold uppercase tracking-widest opacity-60">
							{label}
						</dt>
						<dd className="mt-0.5 truncate text-base font-medium sm:text-lg">
							{label === "NEX" && onChange ? (
								<RpgInlineSelect
									label="NEX"
									value={String(value.nex)}
									onChange={(next) => {
										const nex = Number(next);
										if (nexOptions.some((option) => option.value === next))
											onChange({ ...value, nex });
									}}
									options={nexOptions}
								/>
							) : label === "Crédito" && onChange ? (
								<RpgInlineSelect
									label="Crédito"
									value={value.creditLimit ?? ""}
									onChange={(creditLimit) => {
										if (creditLimit === "") {
											onChange({ ...value, creditLimit: null });
										} else if (isCreditLimit(creditLimit)) {
											onChange({ ...value, creditLimit });
										}
									}}
									options={creditOptions.map((option) => ({
										value: option.value,
										label: option.label,
									}))}
								/>
							) : (
								text
							)}
						</dd>
					</div>
				))}
			</dl>
		</section>
	);
}
