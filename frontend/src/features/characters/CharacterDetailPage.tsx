import { useEffect } from 'react'
import { Link, useParams } from '@tanstack/react-router'
import { useQuery } from '@tanstack/react-query'
import { queries } from '../../shared/api/queries'
import { rememberAccess } from '../../shared/lib/recent-access'
import { RpgErrorState, RpgSkeleton } from '../../components/feedback/RemoteState'
import { EditableCharacterSheet } from './EditableCharacterSheet'

export function CharacterDetailPage() {
  const { characterId = '' } = useParams({ strict: false })
  const character = useQuery(queries.character(characterId))
  const campaigns = useQuery(queries.campaigns)
  const systems = useQuery(queries.systems)
  useEffect(() => { if (character.data) rememberAccess({ kind: 'characters', id: character.data.id, name: character.data.name }) }, [character.data])
  if (character.isPending || campaigns.isPending || systems.isPending) return <RpgSkeleton />
  if (character.isError) return <RpgErrorState error={character.error} retry={() => void character.refetch()} />
  if (campaigns.isError) return <RpgErrorState error={campaigns.error} retry={() => void campaigns.refetch()} />
  if (systems.isError) return <RpgErrorState error={systems.error} retry={() => void systems.refetch()} />
  const item = character.data
  const system = systems.data.find((entry) => entry.id === item.systemId)
  const campaign = campaigns.data.find((entry) => entry.id === item.campaignId)
  const campaignReference = campaign ? <Link to={'/campaigns/' + campaign.id} className="text-(--accent) underline">{campaign.name}</Link> : 'Ficha standalone · sem campanha'
  return <EditableCharacterSheet key={item.id} character={item} systemName={system?.name ?? 'Personagem'} campaignReference={campaignReference} />
}
