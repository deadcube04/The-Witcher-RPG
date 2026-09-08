import type { OrdemData } from '../../../shared/contracts/character-sheet'
import { RpgNumber } from '../../../components/primitives/RpgControls'
import { attributeFields } from './fields'

export function OrdemAttributes({ value, onChange, disabled }: { value: OrdemData['attributes']; onChange: (value: OrdemData['attributes']) => void; disabled?: boolean }) {
  return <section className="space-y-5"><h3 className="border-b border-(--edge) pb-3 text-xl">03 / Atributos</h3>
    <div className="grid grid-cols-2 gap-4 sm:grid-cols-3 xl:grid-cols-5">{attributeFields.map((field) => <div key={field.key} className="border border-(--edge) bg-(--panel) p-4">
      <p aria-hidden="true" className="mb-4 font-mono text-xs text-(--accent)">{field.abbreviation}</p>
      <RpgNumber label={field.label} min={0} max={5} value={value[field.key]} onChange={(next) => onChange({ ...value, [field.key]: next })} disabled={disabled} />
    </div>)}</div></section>
}
