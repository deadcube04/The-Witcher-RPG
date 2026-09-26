import { useMutation, useQueryClient } from "@tanstack/react-query";
import { preferencesApi } from "@/shared/api/domains";
import { keys } from "@/shared/api/queries";
import type {
	PreferencesPatch,
	UserPreferences,
} from "@/shared/contracts/preferences";

export function useThemeMutation() {
	const client = useQueryClient();
	return useMutation({
		mutationFn: (patch: PreferencesPatch) => preferencesApi.update(patch),
		onMutate: async (patch) => {
			await client.cancelQueries({ queryKey: keys.preferences });
			const previous = client.getQueryData<UserPreferences>(keys.preferences);
			if (previous)
				client.setQueryData(keys.preferences, { ...previous, ...patch });
			return { previous };
		},
		onError: (_error, _variables, context) => {
			if (context?.previous)
				client.setQueryData(keys.preferences, context.previous);
		},
		onSuccess: (preferences) => {
			client.setQueryData(keys.preferences, preferences);
		},
	});
}
