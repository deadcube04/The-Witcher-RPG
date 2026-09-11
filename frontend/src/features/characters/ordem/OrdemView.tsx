import {
	GiAura,
	GiBiceps,
	GiBrain,
	GiHeartShield,
	GiSprint,
} from "react-icons/gi";
import { RpgResourceBar } from "../../../components/data-display/RpgResourceBar";
import { RpgAttributeNumber } from "../../../components/primitives/RpgControls";
import type { CharacterInput } from "../../../shared/contracts/character-sheet";
import { attributeFields } from "./fields";

const attributeIcons = {
	agility: GiSprint,
	strength: GiBiceps,
	intellect: GiBrain,
	presence: GiAura,
	vigor: GiHeartShield,
};
const resourceFields = [
	{ key: "health", label: "Vida" },
	{ key: "sanity", label: "Sanidade" },
	{ key: "effort", label: "Esforço" },
] as const;
export function OrdemView({
	value,
	onChange,
}: {
	value: CharacterInput["systemData"];
	onChange?: (value: CharacterInput["systemData"]) => void;
}) {
	if (value.kind !== "ordem-paranormal") return null;
	return (
		<div className="space-y-6">
			<section aria-label="Recursos" className="space-y-4">
				{resourceFields.map((field) => {
					const resource = value.resources[field.key];
					return (
						<RpgResourceBar
							key={field.key}
							label={field.label}
							tone={field.key}
							current={resource.current}
							maximum={resource.maximum}
							temporary={resource.temporary}
							editable={Boolean(onChange)}
							onChange={
								onChange
									? (next) =>
											onChange({
												...value,
												resources: {
													...value.resources,
													[field.key]: { ...resource, ...next },
												},
											})
									: undefined
							}
						/>
					);
				})}
			</section>
			<section className="rounded-2xl border border-(--edge) bg-(--panel) p-4">
				<h3 className="mb-4 text-xs font-semibold uppercase tracking-widest opacity-70">
					Atributos
				</h3>
				<dl className="grid grid-cols-2 gap-3">
					{attributeFields.map((field) => {
						const Icon = attributeIcons[field.key];
						return (
							<div
								key={field.key}
								className={
									"rounded-xl border border-(--edge) bg-(--canvas) px-2 py-3 text-center " +
									(field.key === "vigor" ? "col-span-2 mx-auto w-1/2" : "")
								}
							>
								<dt className="flex flex-col items-center gap-2 text-xs">
									<Icon aria-hidden="true" className="size-5 text-(--accent)" />
									{field.label}
								</dt>
								<dd className="mt-2 flex justify-center">
									{onChange ? (
										<RpgAttributeNumber
											label={field.label}
											value={value.attributes[field.key]}
											onChange={(next) =>
												onChange({
													...value,
													attributes: {
														...value.attributes,
														[field.key]: next,
													},
												})
											}
										/>
									) : (
										<span className="font-mono text-2xl text-(--accent)">
											{value.attributes[field.key]}
										</span>
									)}
								</dd>
							</div>
						);
					})}
				</dl>
			</section>
		</div>
	);
}
