import {
	RpgNumber,
	RpgSelect,
} from "../../../components/primitives/RpgControls";
import type { OrdemData } from "../../../shared/contracts/character-sheet";
import catalog from "../../../shared/contracts/ordem-catalog.json";

export function OrdemIdentity({
	value,
	onChange,
	disabled,
}: {
	value: OrdemData;
	onChange: (value: OrdemData) => void;
	disabled?: boolean;
}) {
	return (
		<section className="space-y-5">
			<h3 className="border-b border-(--edge) pb-3 text-xl">
				02 / Agente da Ordem
			</h3>
			<div className="grid gap-5 sm:grid-cols-2 xl:grid-cols-4">
				<RpgNumber
					label="NEX (%)"
					value={value.nex}
					onChange={(nex) => onChange({ ...value, nex })}
					min={0}
					max={99}
					disabled={disabled}
				/>
				<RpgSelect
					label="Classe"
					value={value.classId ?? ""}
					onChange={(classId) =>
						onChange({ ...value, classId: classId || null })
					}
					disabled={disabled}
					options={[
						{ value: "", label: "Não definida" },
						...catalog.class_definition.map((entry) => ({
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
					disabled={disabled}
					options={[
						{ value: "", label: "Não definida" },
						...catalog.origin_definition.map((entry) => ({
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
