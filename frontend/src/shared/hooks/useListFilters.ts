import { useNavigate, useSearch } from '@tanstack/react-router'
export type ListFilters = { q: string; systemId: string; campaignId: string }
export function useListFilters() {
  const search = useSearch({ strict: false })
  const navigate = useNavigate()
  const filters: ListFilters = {
    q: typeof search.q === 'string' ? search.q : '',
    systemId: typeof search.systemId === 'string' ? search.systemId : '',
    campaignId: typeof search.campaignId === 'string' ? search.campaignId : '',
  }
  return { filters, update: (patch: Partial<ListFilters>) => { void navigate({ to: '.', search: { ...filters, ...patch }, replace: true }) } }
}
