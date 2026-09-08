import { useMutation, useQueryClient } from '@tanstack/react-query'
import { preferencesApi } from '../../shared/api/domains'
import { keys } from '../../shared/api/queries'
import type { ThemeId, UserPreferences } from '../../shared/contracts/preferences'

export function useThemeMutation() {
  const client = useQueryClient()
  return useMutation({
    mutationFn: (activeThemeId: ThemeId | null) => preferencesApi.update({ activeThemeId }),
    onMutate: async (activeThemeId) => {
      await client.cancelQueries({ queryKey: keys.preferences })
      const previous = client.getQueryData<UserPreferences>(keys.preferences)
      if (previous) client.setQueryData(keys.preferences, { ...previous, activeThemeId })
      return { previous }
    },
    onError: (_error, _variables, context) => { if (context?.previous) client.setQueryData(keys.preferences, context.previous) },
    onSuccess: (preferences) => { client.setQueryData(keys.preferences, preferences) },
  })
}
