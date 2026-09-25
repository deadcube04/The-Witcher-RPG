import {
	queryOptions,
	useMutation,
	useQueryClient,
} from "@tanstack/react-query";
import {
	campaignApi,
	attackApi,
	characterApi,
	inventoryApi,
	preferencesApi,
	ritualApi,
	systemsApi,
	userApi,
} from "@/shared/api/domains";

export const keys = {
	user: ["user", "current"] as const,
	preferences: ["preferences"] as const,
	systems: ["systems"] as const,
	campaigns: ["campaigns"] as const,
	campaign: (id: string) => ["campaigns", id] as const,
	characters: ["characters"] as const,
	character: (id: string) => ["characters", id] as const,
	inventory: (id: string) => ["characters", id, "inventory"] as const,
	rituals: (id: string) => ["characters", id, "rituals"] as const,
	attacks: (id: string) => ["characters", id, "attacks"] as const,
	inventoryCatalog: (query: string, kind?: string) =>
		["ordem", "catalog", "inventory", query, kind ?? "all"] as const,
	ritualCatalog: (query: string, element?: string) =>
		["ordem", "catalog", "rituals", query, element ?? "all"] as const,
	attackCatalog: (query: string, source?: string) =>
		["ordem", "catalog", "attacks", query, source ?? "all"] as const,
};
export const queries = {
	user: queryOptions({
		queryKey: keys.user,
		queryFn: ({ signal }) => userApi.get(signal),
	}),
	preferences: queryOptions({
		queryKey: keys.preferences,
		queryFn: ({ signal }) => preferencesApi.get(signal),
	}),
	systems: queryOptions({
		queryKey: keys.systems,
		queryFn: ({ signal }) => systemsApi.list(signal),
	}),
	campaigns: queryOptions({
		queryKey: keys.campaigns,
		queryFn: ({ signal }) => campaignApi.list(signal),
	}),
	campaign: (id: string) =>
		queryOptions({
			queryKey: keys.campaign(id),
			queryFn: ({ signal }) => campaignApi.get(id, signal),
		}),
	characters: queryOptions({
		queryKey: keys.characters,
		queryFn: ({ signal }) => characterApi.list(signal),
	}),
	character: (id: string) =>
		queryOptions({
			queryKey: keys.character(id),
			queryFn: ({ signal }) => characterApi.get(id, signal),
		}),
	inventory: (id: string) =>
		queryOptions({
			queryKey: keys.inventory(id),
			queryFn: ({ signal }) => inventoryApi.list(id, signal),
		}),
	rituals: (id: string) =>
		queryOptions({
			queryKey: keys.rituals(id),
			queryFn: ({ signal }) => ritualApi.list(id, signal),
		}),
	attacks: (id: string) =>
		queryOptions({
			queryKey: keys.attacks(id),
			queryFn: ({ signal }) => attackApi.list(id, signal),
		}),
	inventoryCatalog: (query: string, kind?: Parameters<typeof inventoryApi.catalog>[1]) =>
		queryOptions({
			queryKey: keys.inventoryCatalog(query, kind),
			queryFn: ({ signal }) => inventoryApi.catalog(query, kind, signal),
		}),
	ritualCatalog: (query: string, element?: string) =>
		queryOptions({
			queryKey: keys.ritualCatalog(query, element),
			queryFn: ({ signal }) => ritualApi.catalog(query, element, signal),
		}),
	attackCatalog: (query: string, source?: string) =>
		queryOptions({
			queryKey: keys.attackCatalog(query, source),
			queryFn: ({ signal }) => attackApi.catalog(query, source, signal),
		}),
};
export function useDomainMutation<TInput, TResult>(
	mutationFn: (input: TInput) => Promise<TResult>,
	domains: readonly (readonly string[])[],
) {
	const client = useQueryClient();
	return useMutation({
		mutationFn,
		onSuccess: async () => {
			await Promise.all(
				domains.map((queryKey) => client.invalidateQueries({ queryKey })),
			);
		},
	});
}
