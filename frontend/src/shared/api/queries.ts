import {
	queryOptions,
	useMutation,
	useQueryClient,
} from "@tanstack/react-query";
import {
	campaignApi,
	characterApi,
	preferencesApi,
	systemsApi,
	userApi,
} from "./domains";

export const keys = {
	user: ["user", "current"] as const,
	preferences: ["preferences"] as const,
	systems: ["systems"] as const,
	campaigns: ["campaigns"] as const,
	campaign: (id: string) => ["campaigns", id] as const,
	characters: ["characters"] as const,
	character: (id: string) => ["characters", id] as const,
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
