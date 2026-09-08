import { Link } from '@tanstack/react-router'
import { RpgCard } from '../../components/data-display/RpgCard'
import type { Campaign } from '../../shared/contracts/campaign'
import { CampaignDeleteAction } from './CampaignDeleteAction'

export function CampaignCard({ campaign, systemName }: { campaign: Campaign; systemName: string }) {
  return <RpgCard><p className="mb-5 font-mono text-xs text-(--accent)">{systemName} / {campaign.status === 'active' ? 'Em andamento' : 'Arquivada'}</p>
    <h3 className="text-2xl"><Link to={'/campaigns/' + campaign.id} className="hover:text-(--accent)">{campaign.name}</Link></h3>
    <p className="my-5 line-clamp-3 min-h-16 text-sm leading-6 opacity-75">{campaign.description || 'Uma história ainda por escrever.'}</p>
    <div className="flex flex-wrap gap-5"><Link to={'/campaigns/' + campaign.id} className="py-3 text-sm text-(--accent) underline">Abrir campanha</Link>
      <Link to={'/campaigns/' + campaign.id + '/edit'} className="py-3 text-sm underline">Editar</Link><CampaignDeleteAction campaign={campaign} /></div></RpgCard>
}
