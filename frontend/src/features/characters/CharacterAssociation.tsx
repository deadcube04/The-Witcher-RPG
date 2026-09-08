import { RpgSelect } from '../../components/primitives/RpgControls'
import type { Campaign } from '../../shared/contracts/campaign'
import type { RpgSystem } from '../../shared/contracts/rpg-system'

export function CharacterAssociation({ systemId, campaignId, systems, campaigns, onSystemChange, onCampaignChange, disabled, systemLocked }: {
  systemId: string; campaignId: string | null; systems: RpgSystem[]; campaigns: Campaign[];
  onSystemChange: (id: string) => void; onCampaignChange: (id: string | null) => void; disabled: boolean; systemLocked: boolean
}) {
  return <div className="grid gap-5 md:grid-cols-2">
    <RpgSelect label="Sistema da ficha" value={systemId} options={systems.map((system) => ({ value: system.id, label: system.name }))} onChange={onSystemChange} disabled={disabled || systemLocked} />
    <RpgSelect label="Campanha" value={campaignId ?? ''} onChange={(id) => onCampaignChange(id || null)} disabled={disabled}
      options={[{ value: '', label: 'Standalone — sem campanha' }, ...campaigns.filter((campaign) => campaign.systemId === systemId).map((campaign) => ({ value: campaign.id, label: campaign.name }))]} />
  </div>
}
