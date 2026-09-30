import { RpgResourceBar } from "@/components/data-display/RpgResourceBar";
import { RpgAttributeNumber } from "@/components/primitives/RpgControls";
import type { CharacterInput } from "@/shared/contracts/character-sheet";
import { attributeFields } from "@/features/characters/ordem/fields";

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
		<div className="grid min-w-0 gap-3 lg:grid-cols-[minmax(0,1.35fr)_minmax(0,1fr)]">
			<section
				aria-label="Recursos"
				className="min-w-0 rounded-[1.75rem] bg-(--edge)/30 p-1"
			>
				<div className="h-full rounded-[calc(1.75rem-0.25rem)] bg-(--surface) p-4 sm:p-5">
					<h2 className="mb-4 font-mono text-[11px] uppercase tracking-[0.2em] text-(--muted)">
						Recursos
					</h2>
					<div className="grid min-w-0 gap-3 md:grid-cols-3">
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
					</div>
				</div>
			</section>
			<section className="min-w-0 rounded-[1.75rem] bg-(--edge)/30 p-1">
				<div className="h-full rounded-[calc(1.75rem-0.25rem)] bg-(--surface) p-4 sm:p-5">
					<h2 className="mb-4 font-mono text-[11px] uppercase tracking-[0.2em] text-(--muted)">
						Atributos
					</h2>
					<dl className="grid grid-cols-3 gap-2 sm:grid-cols-5 lg:grid-cols-3 xl:grid-cols-5">
						{attributeFields.map((field) => {
							return (
								<div
									key={field.key}
									className="min-w-0 rounded-xl bg-(--panel) px-1 py-2 text-center ring-1 ring-(--edge)/45"
								>
								<dt className="truncate text-xs font-medium">
									{field.label}
									</dt>
									<dd className="mt-1 flex justify-center">
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
				</div>
			</section>
		</div>
	);
}
