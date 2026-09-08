import { useQuery } from '@tanstack/react-query'
import { Link, useNavigate, useParams } from '@tanstack/react-router'
import { queries, keys, useDomainMutation } from '../../shared/api/queries'
import { campaignApi } from '../../shared/api/domains'
import type { CampaignInput } from '../../shared/contracts/campaign'
import { CampaignForm } from './CampaignForm'
import { RpgSkeleton, RpgErrorState } from '../../components/feedback/RemoteState'
import { PageHeader } from '../../components/navigation/PageHeader'

export function CampaignEditorPage() {
  const { campaignId = '' } = useParams({ strict: false })
  const navigate = useNavigate()
  const systems = useQuery(queries.systems)
  const preferences = useQuery(queries.preferences)
  const campaign = useQuery({ ...queries.campaign(campaignId), enabled: !!campaignId })
  const characters = useQuery(queries.characters)
  const mutation = useDomainMutation((input: CampaignInput) => campaignId ? campaignApi.update(campaignId, input) : campaignApi.create(input), [keys.campaigns])
  if (systems.isPending || preferences.isPending || characters.isPending || (campaignId && campaign.isPending)) return <RpgSkeleton />
  const error = systems.error ?? preferences.error ?? characters.error ?? (campaignId ? campaign.error : null)
  if (error) return <RpgErrorState error={error} retry={() => { void systems.refetch(); void preferences.refetch(); void characters.refetch(); if (campaignId) void campaign.refetch() }} />
  if (!systems.data || !preferences.data) return null
  const initial: CampaignInput = campaign.data ? { name: campaign.data.name, systemId: campaign.data.systemId, description: campaign.data.description, status: campaign.data.status }
    : { name: '', description: '', systemId: preferences.data.activeSystemId, status: 'active' }
  return <><Link to={campaignId ? '/campaigns/' + campaignId : '/campaigns'} className="mb-6 inline-block py-2 text-sm underline">← Voltar para campanhas</Link>
    <PageHeader eyebrow="Campanhas / Registro" title={campaignId ? 'Editar campanha' : 'Uma nova história'} />
    <div className="max-w-3xl"><CampaignForm initial={initial} systems={systems.data} pending={mutation.isPending} error={mutation.error}
      systemLocked={!!characters.data?.some((sheet) => sheet.campaignId === campaignId)}
      onSave={async (input) => { const saved = await mutation.mutateAsync(input).catch(() => undefined); if (saved) await navigate({ to: '/campaigns/' + saved.id }) }} /></div></>
}
