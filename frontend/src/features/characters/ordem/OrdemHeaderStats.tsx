import { useQuery } from "@tanstack/react-query";
import { RpgInlineSelect } from "@/components/primitives/RpgControls";
import type { OrdemData } from "@/shared/contracts/character-sheet";
import { queries } from "@/shared/api/queries";

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
	const options = useQuery(queries.characterOptions);
	const nexOptions = (value.progressionMode === "nex" ? options.data?.nex ?? [] : [{ value: 0 }, ...(options.data?.nex ?? [])]).map((entry) => ({
		value: String(entry.value),
		label: `${entry.value}%`,
	}));
	const stats = [
		[value.progressionMode === "survivor" ? "Estágio" : "NEX", value.progressionMode === "survivor" ? String(value.survivorStage ?? 1) : `${value.nex}%`],
		[
			"Classe",
			value.progressionMode === "survivor" ? "Sobrevivente" : options.data?.classes.find((entry) => entry.id === value.classId)?.name ?? "Não definida",
		],
		[
			"Origem",
			options.data?.origins.find((entry) => entry.id === value.originId)
				?.name ?? "Não definida",
		],
		["Crédito", value.creditLimit ?? "Não definido"],
		["Deslocamento", "9m / 6q"],
	] as const;

	return (
		<section aria-label="Resumo da ficha" className="min-w-0">
			<dl className="grid grid-cols-2 gap-1.5 sm:grid-cols-3 xl:grid-cols-5">
				{stats.map(([label, text]) => (
					<div
						key={label}
						className="min-w-0 rounded-xl bg-(--panel) px-3 py-2"
					>
						<dt className="truncate font-mono text-[10px] uppercase tracking-[0.12em] text-(--muted)">
							{label}
						</dt>
						<dd className="mt-0.5 truncate text-sm font-semibold">
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
