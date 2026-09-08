import { RpgInput, RpgSelect } from '../../components/primitives/RpgControls'
import type { RpgSystem } from '../../shared/contracts/rpg-system'
import type { Campaign } from '../../shared/contracts/campaign'
import type { ListFilters } from '../../shared/hooks/useListFilters'

export function CharacterFilters({ filters, systems, campaigns, onChange }: { filters: ListFilters; systems: RpgSystem[]; campaigns: Campaign[]; onChange: (patch: Partial<ListFilters>) => void }) {
  return <div className="mb-8 grid gap-4 md:grid-cols-3"><RpgInput label="Buscar ficha" value={filters.q} onChange={(q) => onChange({ q })} />
    <RpgSelect label="Sistema" value={filters.systemId} onChange={(systemId) => onChange({ systemId })} options={[{ value: '', label: 'Todos os sistemas' }, ...systems.map((item) => ({ value: item.id, label: item.name }))]} />
    <RpgSelect label="Vínculo" value={filters.campaignId} onChange={(campaignId) => onChange({ campaignId })} options={[{ value: '', label: 'Todas as fichas' }, { value: 'standalone', label: 'Standalone' }, { value: 'linked', label: 'Vinculadas a campanhas' }, ...campaigns.map((item) => ({ value: item.id, label: item.name }))]} /></div>
}
