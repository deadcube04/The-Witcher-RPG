import { Link } from '@tanstack/react-router'
import type { Campaign } from '../../shared/contracts/campaign'
import type { RpgSystem } from '../../shared/contracts/rpg-system'
import { CampaignCard } from './CampaignCard'
import { RpgEmptyState } from '../../components/feedback/RemoteState'

export function CampaignList({ campaigns, systems }: { campaigns: Campaign[]; systems: RpgSystem[] }) {
  if (!campaigns.length) return <RpgEmptyState title="Nenhuma campanha encontrada"><p>Ajuste os filtros ou comece uma nova história.</p><Link to="/campaigns/new" className="underline">Criar campanha</Link></RpgEmptyState>
  return <div className="grid gap-5 md:grid-cols-2">{campaigns.map((campaign) => <CampaignCard key={campaign.id} campaign={campaign} systemName={systems.find((item) => item.id === campaign.systemId)?.name ?? 'Sistema indisponível'} />)}</div>
}
