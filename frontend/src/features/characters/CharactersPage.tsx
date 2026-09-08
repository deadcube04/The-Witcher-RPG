import { useQuery } from '@tanstack/react-query'
import { Link } from '@tanstack/react-router'
import { queries } from '../../shared/api/queries'
import { useListFilters } from '../../shared/hooks/useListFilters'
import { matchesName } from '../../shared/lib/search'
import { PageHeader } from '../../components/navigation/PageHeader'
import { RpgErrorState, RpgSkeleton } from '../../components/feedback/RemoteState'
import { CharacterFilters } from './CharacterFilters'
import { CharacterList } from './CharacterList'

export function CharactersPage() {
  const characters = useQuery(queries.characters)
  const systems = useQuery(queries.systems)
  const campaigns = useQuery(queries.campaigns)
  const { filters, update } = useListFilters()
  if (characters.isPending || systems.isPending || campaigns.isPending) return <RpgSkeleton />
  const error = characters.error ?? systems.error ?? campaigns.error
  if (error) return <RpgErrorState error={error} retry={() => { void characters.refetch(); void systems.refetch(); void campaigns.refetch() }} />
  const filtered = (characters.data ?? []).filter((sheet) => matchesName(sheet.name, filters.q) && (!filters.systemId || sheet.systemId === filters.systemId)
    && (!filters.campaignId || (filters.campaignId === 'standalone' ? sheet.campaignId === null : filters.campaignId === 'linked' ? sheet.campaignId !== null : sheet.campaignId === filters.campaignId)))
  return <><PageHeader eyebrow="03 / Personagens" title="Quem vive a história" actions={<Link to="/characters/new" className="bg-(--accent) px-5 py-3 text-sm font-bold text-(--canvas)">Nova ficha</Link>} />
    <CharacterFilters filters={filters} systems={systems.data ?? []} campaigns={campaigns.data ?? []} onChange={update} /><CharacterList characters={filtered} systems={systems.data ?? []} /></>
}
