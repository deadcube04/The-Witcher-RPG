import { useQuery } from "@tanstack/react-query";
import { RpgSelect } from "@/components/primitives/RpgControls";
import { queries } from "@/shared/api/queries";
import type { OrdemData } from "../../../shared/contracts/character-sheet";

export function OrdemIdentity({
	value,
	onChange,
	disabled,
}: {
	value: OrdemData;
	onChange: (value: OrdemData) => void;
	disabled?: boolean;
}) {
	const options = useQuery(queries.characterOptions);
	return (
		<section className="space-y-5">
			<h3 className="border-b border-(--edge) pb-3 text-xl">
				02 / Agente da Ordem
			</h3>
			<div className="grid gap-5 sm:grid-cols-2 xl:grid-cols-4">
				<RpgSelect
					label="NEX (%)"
					value={String(value.nex)}
					onChange={(nex) => onChange({ ...value, nex: Number(nex) })}
					options={(options.data?.nex ?? []).map((entry) => ({ value: String(entry.value), label: `${entry.value}%` }))}
					disabled={disabled || options.isPending || !!options.error}
				/>
				<RpgSelect
					label="Classe"
					value={value.classId ?? ""}
					onChange={(classId) =>
						onChange({ ...value, classId: classId || null })
					}
					disabled={disabled || options.isPending || !!options.error}
					options={[
						{ value: "", label: "Não definida" },
						...(options.data?.classes ?? []).map((entry) => ({
							value: entry.id,
							label: entry.name,
						})),
					]}
				/>
				<RpgSelect
					label="Origem"
					value={value.originId ?? ""}
					onChange={(originId) =>
						onChange({ ...value, originId: originId || null })
					}
					disabled={disabled || options.isPending || !!options.error}
					options={[
						{ value: "", label: "Não definida" },
						...(options.data?.origins ?? []).map((entry) => ({
							value: entry.id,
							label: entry.name,
						})),
					]}
				/>
				<RpgSelect
					label="Limite de crédito"
					value={value.creditLimit ?? ""}
					disabled={disabled}
					options={[
						{ value: "", label: "Não definido" },
						{ value: "BAIXO", label: "Baixo" },
						{ value: "MEDIO", label: "Médio" },
						{ value: "ALTO", label: "Alto" },
						{ value: "ILIMITADO", label: "Ilimitado" },
					]}
					onChange={(credit) => {
						if (
							credit === "" ||
							credit === "BAIXO" ||
							credit === "MEDIO" ||
							credit === "ALTO" ||
							credit === "ILIMITADO"
						)
							onChange({ ...value, creditLimit: credit || null });
					}}
				/>
			</div>
		</section>
	);
}
