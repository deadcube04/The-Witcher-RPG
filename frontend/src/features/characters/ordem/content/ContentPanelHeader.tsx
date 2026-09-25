import {
	RpgButton,
	RpgInput,
	RpgSelect,
	type SelectOption,
} from "@/components/primitives/RpgControls";

export function ContentPanelHeader({
	count,
	query,
	onQueryChange,
	filter,
	onFilterChange,
	filterLabel,
	filterOptions,
	onAdd,
}: {
	count: number;
	query: string;
	onQueryChange: (value: string) => void;
	filter: string;
	onFilterChange: (value: string) => void;
	filterLabel: string;
	filterOptions: SelectOption[];
	onAdd: () => void;
}) {
	return (
		<div className="mb-5 space-y-4">
			<div className="flex flex-wrap items-center justify-between gap-3">
				<p className="text-xs uppercase tracking-[0.2em] opacity-65">
					{count} {count === 1 ? "registro" : "registros"}
				</p>
				<RpgButton onClick={onAdd}>+ Adicionar</RpgButton>
			</div>
			<div className="grid gap-3 sm:grid-cols-[minmax(0,1fr)_12rem]">
				<RpgInput
					label="Buscar nos seus registros"
					value={query}
					onChange={onQueryChange}
				/>
				<RpgSelect
					label={filterLabel}
					value={filter}
					onChange={onFilterChange}
					options={filterOptions}
				/>
			</div>
		</div>
	);
}
