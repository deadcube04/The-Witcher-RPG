import { RpgNumber } from "../../../components/primitives/RpgControls";
import type { OrdemData } from "../../../shared/contracts/character-sheet";
import { resourceFields } from "./fields";

export function OrdemResources({
	value,
	onChange,
	disabled,
	determinationEnabled = false,
}: {
	value: OrdemData["resources"];
	onChange: (value: OrdemData["resources"]) => void;
	disabled?: boolean;
	determinationEnabled?: boolean;
}) {
	const fields = determinationEnabled ? [{ key: "health", label: "Vida" }, { key: "determination", label: "Determinação" }] as const : resourceFields;
	return (
		<section className="space-y-5">
			<h3 className="border-b border-(--edge) pb-3 text-xl">04 / Recursos</h3>
			<div className="grid gap-5 xl:grid-cols-3">
				{fields.map((field) => {
					const resource = value[field.key] ?? { current: 0, maximum: 0, temporary: 0, baseMaximum: 0, maxAdjustment: 0 };
					return (
					<fieldset
						key={field.key}
						className="space-y-4 border border-(--edge) p-5"
					>
						<legend className="px-2 text-lg">{field.label}</legend>
						<RpgNumber
							label={`${field.label} atual`}
							value={resource.current}
							onChange={(current) =>
								onChange({
									...value,
									[field.key]: { ...resource, current },
								})
							}
							disabled={disabled}
						/>
						<RpgNumber
							label={`${field.label} ajuste do máximo`}
							value={resource.maxAdjustment}
							onChange={(maxAdjustment) =>
								onChange({
									...value,
									[field.key]: { ...resource, maxAdjustment },
								})
							}
							disabled={disabled}
						/>
						<p className="text-xs opacity-70">Máximo calculado: {resource.maximum}</p>
						<RpgNumber
							label={`${field.label} temporária`}
							min={0}
							value={resource.temporary}
							onChange={(temporary) =>
								onChange({
									...value,
									[field.key]: { ...resource, temporary },
								})
							}
							disabled={disabled}
						/>
					</fieldset>
				)})}
			</div>
		</section>
	);
}
