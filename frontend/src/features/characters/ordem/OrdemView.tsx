import { GiSprint, GiBiceps, GiBrain, GiAura, GiHeartShield } from 'react-icons/gi'
import type { CharacterInput } from '../../../shared/contracts/character-sheet'
import catalog from '../../../shared/contracts/ordem-catalog.json'
import { attributeFields, resourceFields } from './fields'
import { RpgAttributeNumber } from '../../../components/primitives/RpgControls'

const attributeIcons = { agility: GiSprint, strength: GiBiceps, intellect: GiBrain, presence: GiAura, vigor: GiHeartShield }
const resourceColors = {
  health: '[&::-webkit-progress-value]:bg-rose-400 [&::-moz-progress-bar]:bg-rose-400',
  effort: '[&::-webkit-progress-value]:bg-amber-300 [&::-moz-progress-bar]:bg-amber-300',
  sanity: '[&::-webkit-progress-value]:bg-violet-400 [&::-moz-progress-bar]:bg-violet-400',
}
export function OrdemView({ value, onChange }: { value: CharacterInput['systemData']; onChange?: (value: CharacterInput['systemData']) => void }) {
  if (value.kind !== 'ordem-paranormal') return null
  return <div className="space-y-6">
    <section aria-label="Recursos" className="space-y-4">{resourceFields.map((field) => {
      const resource = value.resources[field.key]
      return <div key={field.key}><div className="mb-2 flex justify-between gap-2 text-xs font-semibold"><span>{field.label}</span><span>{resource.current} / {resource.maximum}</span></div>
        <progress aria-label={field.label} value={Math.max(0, Math.min(resource.current, resource.maximum))} max={Math.max(1, resource.maximum)}
          className={'block h-2 w-full overflow-hidden rounded-full border-0 bg-(--panel) [&::-webkit-progress-bar]:bg-(--panel) [&::-webkit-progress-value]:rounded-full ' + resourceColors[field.key]} />
        {resource.temporary > 0 && <p className="mt-1 text-right text-xs opacity-60">Temporários: +{resource.temporary}</p>}
      </div>
    })}</section>
    <section className="rounded-2xl border border-(--edge) bg-(--panel) p-4"><h3 className="mb-4 text-xs font-semibold uppercase tracking-widest opacity-70">Atributos</h3>
      <dl className="grid grid-cols-2 gap-3">{attributeFields.map((field) => {
        const Icon = attributeIcons[field.key]
        return <div key={field.key} className={'rounded-xl border border-(--edge) bg-(--canvas) px-2 py-3 text-center ' + (field.key === 'vigor' ? 'col-span-2 mx-auto w-1/2' : '')}>
          <dt className="flex flex-col items-center gap-2 text-xs"><Icon aria-hidden="true" className="size-5 text-(--accent)" />{field.label}</dt>
          <dd className="mt-2 flex justify-center">{onChange
            ? <RpgAttributeNumber label={field.label} value={value.attributes[field.key]}
              onChange={(next) => onChange({ ...value, attributes: { ...value.attributes, [field.key]: next } })} />
            : <span className="font-mono text-2xl text-(--accent)">{value.attributes[field.key]}</span>}</dd>
        </div>
      })}</dl>
    </section>
    <dl className="grid grid-cols-2 gap-4 border-t border-(--edge) pt-5 text-sm">
      {[['NEX', value.nex + '%'], ['Classe', catalog.class_definition.find((entry) => entry.id === value.classId)?.name ?? 'Não definida'],
        ['Origem', catalog.origin_definition.find((entry) => entry.id === value.originId)?.name ?? 'Não definida'], ['Crédito', value.creditLimit ?? 'Não definido']].map(([label, text]) => <div key={label}><dt className="text-[10px] uppercase tracking-widest opacity-60">{label}</dt><dd className="mt-1">{text}</dd></div>)}
    </dl>
  </div>
}
