import { RpgInput, RpgSelect } from '../../components/primitives/RpgControls'
import type { RpgSystem } from '../../shared/contracts/rpg-system'
import type { ListFilters } from '../../shared/hooks/useListFilters'

export function CampaignFilters({ filters, systems, onChange }: { filters: ListFilters; systems: RpgSystem[]; onChange: (patch: Partial<ListFilters>) => void }) {
  return <div className="mb-8 grid gap-4 md:grid-cols-[2fr_1fr]"><RpgInput label="Buscar campanha" value={filters.q} onChange={(q) => onChange({ q })} />
    <RpgSelect label="Sistema" value={filters.systemId} onChange={(systemId) => onChange({ systemId })} options={[{ value: '', label: 'Todos os sistemas' }, ...systems.map((item) => ({ value: item.id, label: item.name }))]} /></div>
}
