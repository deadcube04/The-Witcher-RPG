import { RpgDisclosure } from "@/components/primitives/RpgDisclosure";
import {
	RpgInput,
	RpgSelect,
	RpgTextNumber,
	type SelectOption,
} from "@/components/primitives/RpgControls";
import type {
	BestiaryOptions,
	BestiaryFilters as FilterValues,
} from "@/shared/contracts/bestiary";

type Props = {
	filters: FilterValues;
	options: BestiaryOptions;
	onChange: (patch: Partial<FilterValues>) => void;
};

function selectOptions(items: BestiaryOptions["elements"]): SelectOption[] {
	return [
		{ value: "", label: "Todos" },
		...items.map(({ id, name }) => ({ value: id, label: name })),
	];
}

function selectedName(
	items: BestiaryOptions["elements"],
	id: string | undefined,
): string | null {
	return items.find((item) => item.id === id)?.name ?? null;
}

export function BestiaryFilters({ filters, options, onChange }: Props) {
	const elementName = selectedName(options.elements, filters.elementId);
	const typeName = selectedName(options.types, filters.beingTypeId);
	const sizeName = selectedName(options.sizes, filters.sizeId);
	const labels = [
		elementName && `Elemento: ${elementName}`,
		typeName && `Tipo: ${typeName}`,
		sizeName && `Porte: ${sizeName}`,
		filters.vdMin && `VD a partir de ${filters.vdMin}`,
		filters.vdMax && `VD até ${filters.vdMax}`,
		filters.sort &&
			filters.sort !== "name" &&
			`Ordem: ${filters.sort === "relevance" ? "relevância" : filters.sort === "vd-asc" ? "VD crescente" : "VD decrescente"}`,
	].filter((label): label is string => Boolean(label));
	const hasFilters = Boolean(filters.q) || labels.length > 0;
	return (
		<section
			aria-label="Pesquisar e filtrar ameaças"
			className="mb-10 border-y border-(--edge)/70 bg-(--surface)/75 px-4 py-5 md:px-6"
		>
			<div className="grid gap-4 lg:grid-cols-[minmax(0,1fr)_auto] lg:items-end">
				<RpgInput
					label="Nome no registro"
					value={filters.q ?? ""}
					onChange={(q) => onChange({ q })}
					hint="Um nome ou fragmento dele basta para iniciar a busca."
				/>
				{hasFilters && (
					<button
						type="button"
						onClick={() =>
							onChange({
								q: "",
								elementId: "",
								beingTypeId: "",
								sizeId: "",
								vdMin: "",
								vdMax: "",
								sort: "name",
							})
						}
						className="min-h-11 self-end border border-(--edge) px-4 text-sm font-semibold text-(--ink) hover:border-(--accent) focus-visible:outline-2 focus-visible:outline-(--accent)"
					>
						Limpar o registro de busca
					</button>
				)}
			</div>
			<RpgDisclosure
				title={
					<span className="font-serif text-xl text-(--ink)">
						Refinar a investigação
					</span>
				}
				summary={
					labels.length > 0
						? `${labels.length} critério${labels.length === 1 ? "" : "s"} aplicado${labels.length === 1 ? "" : "s"}`
						: "Elemento, tipo, porte, VD e ordem"
				}
				className="mt-5 border-t border-(--edge)/60 pt-3"
				buttonClassName="px-0! hover:bg-transparent!"
				panelClassName="pt-4"
			>
				<div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
					<RpgSelect
						label="Elemento"
						value={filters.elementId ?? ""}
						onChange={(elementId) => onChange({ elementId })}
						options={selectOptions(options.elements)}
					/>
					<RpgSelect
						label="Tipo de ser"
						value={filters.beingTypeId ?? ""}
						onChange={(beingTypeId) => onChange({ beingTypeId })}
						options={selectOptions(options.types)}
					/>
					<RpgSelect
						label="Porte"
						value={filters.sizeId ?? ""}
						onChange={(sizeId) => onChange({ sizeId })}
						options={selectOptions(options.sizes)}
					/>
					<RpgSelect
						label="Ordenar registros"
						value={filters.sort ?? "name"}
						onChange={(sort) =>
							onChange({
								sort:
									sort === "vd-asc" ||
									sort === "vd-desc" ||
									sort === "relevance"
										? sort
										: "name",
							})
						}
						options={[
							{ value: "name", label: "Nome" },
							{ value: "relevance", label: "Relevância" },
							{ value: "vd-asc", label: "VD crescente" },
							{ value: "vd-desc", label: "VD decrescente" },
						]}
					/>
					<RpgTextNumber
						label="VD mínima"
						value={filters.vdMin ?? ""}
						onChange={(vdMin) => onChange({ vdMin })}
						min={options.minVD}
						max={options.maxVD}
					/>
					<RpgTextNumber
						label="VD máxima"
						value={filters.vdMax ?? ""}
						onChange={(vdMax) => onChange({ vdMax })}
						min={options.minVD}
						max={options.maxVD}
					/>
				</div>
			</RpgDisclosure>
			{labels.length > 0 && (
				<div
					aria-label="Critérios ativos"
					className="mt-4 flex flex-wrap gap-2"
				>
					{labels.map((label) => (
						<span
							key={label}
							className="border border-(--accent)/50 bg-(--accent)/10 px-3 py-1.5 font-mono text-[10px] uppercase tracking-[0.08em] text-(--ink)"
						>
							{label}
						</span>
					))}
				</div>
			)}
		</section>
	);
}
