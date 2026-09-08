import type { OrdemData } from '../../../shared/contracts/character-sheet'
import { RpgNumber } from '../../../components/primitives/RpgControls'
import { resourceFields } from './fields'

export function OrdemResources({ value, onChange, disabled }: { value: OrdemData['resources']; onChange: (value: OrdemData['resources']) => void; disabled?: boolean }) {
  return <section className="space-y-5"><h3 className="border-b border-(--edge) pb-3 text-xl">04 / Recursos</h3>
    <div className="grid gap-5 xl:grid-cols-3">{resourceFields.map((field) => <fieldset key={field.key} className="space-y-4 border border-(--edge) p-5">
      <legend className="px-2 text-lg">{field.label}</legend>
      <RpgNumber label={field.label + ' atual'} value={value[field.key].current} onChange={(current) => onChange({ ...value, [field.key]: { ...value[field.key], current } })} disabled={disabled} />
      <RpgNumber label={field.label + ' máxima'} min={0} value={value[field.key].maximum} onChange={(maximum) => onChange({ ...value, [field.key]: { ...value[field.key], maximum } })} disabled={disabled} />
      <RpgNumber label={field.label + ' temporária'} min={0} value={value[field.key].temporary} onChange={(temporary) => onChange({ ...value, [field.key]: { ...value[field.key], temporary } })} disabled={disabled} />
    </fieldset>)}</div></section>
}
