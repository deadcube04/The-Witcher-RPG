import type { BestiaryFilters } from "@/shared/contracts/bestiary";

export type BestiarySearchState = BestiaryFilters;

export function filtersFromSearch(value: { q?: unknown; elementId?: unknown; beingTypeId?: unknown; sizeId?: unknown; vdMin?: unknown; vdMax?: unknown; sort?: unknown }): BestiaryFilters {
	const sort = value.sort === "vd-asc" || value.sort === "vd-desc" || value.sort === "relevance" ? value.sort : "name";
	return {
		q: typeof value.q === "string" ? value.q : "",
		elementId: typeof value.elementId === "string" ? value.elementId : "",
		beingTypeId: typeof value.beingTypeId === "string" ? value.beingTypeId : "",
		sizeId: typeof value.sizeId === "string" ? value.sizeId : "",
		vdMin: typeof value.vdMin === "string" ? value.vdMin : "",
		vdMax: typeof value.vdMax === "string" ? value.vdMax : "",
		sort,
	};
}

