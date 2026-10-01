import {
	queryOptions,
	useMutation,
	useQueryClient,
} from "@tanstack/react-query";
import {
	campaignApi,
	attackApi,
	bestiaryApi,
	characterApi,
	errorAdminApi,
	inventoryApi,
	preferencesApi,
	ritualApi,
	systemsApi,
	supplementApi,
	supplementReviewApi,
	userApi,
} from "@/shared/api/domains";
import type { ErrorFilter } from "@/shared/contracts/application-error";

export const keys = {
	user: ["user", "current"] as const,
	preferences: ["preferences"] as const,
	systems: ["systems"] as const,
	supplements: ["ordem", "supplements"] as const,
	supplementIssues: (id: string, state: string) => ["admin", "supplements", id, "issues", state] as const,
	campaigns: ["campaigns"] as const,
	campaign: (id: string) => ["campaigns", id] as const,
	characters: ["characters"] as const,
	characterOptions: ["ordem", "character-options"] as const,
	character: (id: string) => ["characters", id] as const,
	skills: (id: string) => ["characters", id, "skills"] as const,
	powers: (id: string) => ["characters", id, "powers"] as const,
	supplementReference: (id: string) => ["characters", id, "supplement-reference"] as const,
	inventory: (id: string) => ["characters", id, "inventory"] as const,
	modifications: (id: string, entryId: string) => ["characters", id, "inventory", entryId, "modifications"] as const,
	rituals: (id: string) => ["characters", id, "rituals"] as const,
	attacks: (id: string) => ["characters", id, "attacks"] as const,
	adminErrorGroups: (filter: ErrorFilter) => ["admin", "errors", "groups", filter] as const,
	adminErrorOccurrences: (filter: ErrorFilter) => ["admin", "errors", "occurrences", filter] as const,
	adminErrorOccurrence: (id: string) => ["admin", "errors", "occurrence", id] as const,
	adminErrorRetention: ["admin", "errors", "retention"] as const,
	bestiaryOptions: ["ordem", "bestiary", "options"] as const,
	bestiaryList: (filters: object) => ["ordem", "bestiary", "list", filters] as const,
	bestiaryEntry: (id: string, filters: object) => ["ordem", "bestiary", "entry", id, filters] as const,
	inventoryCatalog: (query: string, kind?: string, characterId?: string) =>
		["ordem", "catalog", "inventory", query, kind ?? "all", characterId ?? ""] as const,
	ritualCatalog: (query: string, element?: string, characterId?: string) =>
		["ordem", "catalog", "rituals", query, element ?? "all", characterId ?? ""] as const,
	attackCatalog: (query: string, source?: string, characterId?: string) =>
		["ordem", "catalog", "attacks", query, source ?? "all", characterId ?? ""] as const,
};
export const queries = {
	user: queryOptions({
		queryKey: keys.user,
		queryFn: ({ signal }) => userApi.get(signal),
	}),
	bestiaryOptions: queryOptions({
		queryKey: keys.bestiaryOptions,
		queryFn: ({ signal }) => bestiaryApi.options(signal),
	}),
	preferences: queryOptions({
		queryKey: keys.preferences,
		queryFn: ({ signal }) => preferencesApi.get(signal),
	}),
	systems: queryOptions({
		queryKey: keys.systems,
		queryFn: ({ signal }) => systemsApi.list(signal),
	}),
	supplements: queryOptions({ queryKey: keys.supplements, queryFn: ({ signal }) => supplementApi.list(signal) }),
	supplementIssues: (id: string, state: "open" | "resolved") => queryOptions({ queryKey: keys.supplementIssues(id, state), queryFn: ({ signal }) => supplementReviewApi.issues(id, state, signal) }),
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
	characterOptions: queryOptions({
		queryKey: keys.characterOptions,
		queryFn: ({ signal }) => characterApi.options(signal),
	}),
	character: (id: string) =>
		queryOptions({
			queryKey: keys.character(id),
			queryFn: ({ signal }) => characterApi.get(id, signal),
		}),
	skills: (id: string) => queryOptions({
		queryKey: keys.skills(id),
		queryFn: ({ signal }) => characterApi.skills(id, signal),
	}),
	powers: (id: string) => queryOptions({ queryKey: keys.powers(id), queryFn: ({ signal }) => characterApi.powers(id, signal) }),
	supplementReference: (id: string) => queryOptions({ queryKey: keys.supplementReference(id), queryFn: ({ signal }) => characterApi.supplementReference(id, signal) }),
	inventory: (id: string) =>
		queryOptions({
			queryKey: keys.inventory(id),
			queryFn: ({ signal }) => inventoryApi.list(id, signal),
		}),
	modifications: (id: string, entryId: string) => queryOptions({ queryKey: keys.modifications(id, entryId), queryFn: ({ signal }) => inventoryApi.modifications(id, entryId, signal) }),
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
	adminErrorGroups: (filter: ErrorFilter) => queryOptions({
		queryKey: keys.adminErrorGroups(filter),
		queryFn: ({ signal }) => errorAdminApi.groups(filter, signal),
	}),
	adminErrorOccurrences: (filter: ErrorFilter) => queryOptions({
		queryKey: keys.adminErrorOccurrences(filter),
		queryFn: ({ signal }) => errorAdminApi.occurrences(filter, signal),
	}),
	adminErrorOccurrence: (id: string) => queryOptions({
		queryKey: keys.adminErrorOccurrence(id),
		queryFn: ({ signal }) => errorAdminApi.occurrence(id, signal),
	}),
	adminErrorRetention: queryOptions({
		queryKey: keys.adminErrorRetention,
		queryFn: ({ signal }) => errorAdminApi.retention(signal),
	}),
	inventoryCatalog: (query: string, characterId: string, kind?: Parameters<typeof inventoryApi.catalog>[1]) =>
		queryOptions({
			queryKey: keys.inventoryCatalog(query, kind, characterId),
			queryFn: ({ signal }) => inventoryApi.catalog(query, kind, signal, characterId),
		}),
	ritualCatalog: (query: string, characterId: string, element?: string) =>
		queryOptions({
			queryKey: keys.ritualCatalog(query, element, characterId),
			queryFn: ({ signal }) => ritualApi.catalog(query, element, signal, characterId),
		}),
	attackCatalog: (query: string, characterId: string, source?: string) =>
		queryOptions({
			queryKey: keys.attackCatalog(query, source, characterId),
			queryFn: ({ signal }) => attackApi.catalog(query, source, signal, characterId),
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
