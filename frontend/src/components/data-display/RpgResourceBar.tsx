import { Button, InputNumber } from 'antd'
import { motion, useReducedMotion } from 'motion/react'

type ResourceValue = { current: number; maximum: number }
type Props = ResourceValue & {
  label: string
  tone: 'health' | 'sanity' | 'effort'
  onChange?: (value: ResourceValue) => void
  editable?: boolean
}

const colors = { health: 'bg-[#b52226]', sanity: 'bg-[#8824df]', effort: 'bg-[#ff8708]' }
const steps = [-5, -1, 1, 5] as const

export function RpgResourceBar({ label, tone, current, maximum, onChange, editable = false }: Props) {
  const reduced = useReducedMotion()
  const limit = Math.max(0, maximum)
  const amount = Math.max(0, Math.min(current, limit))
  const update = (next: number, nextMaximum = limit) => {
    if (!Number.isFinite(next) || !Number.isFinite(nextMaximum)) return
    const maximum = Math.max(0, Math.trunc(nextMaximum))
    onChange?.({ current: Math.max(0, Math.min(Math.trunc(next), maximum)), maximum })
  }
  const control = (step: typeof steps[number]) => <Button key={step} type="text" htmlType="button"
    aria-label={`${label}: ${step < 0 ? 'diminuir' : 'aumentar'} ${Math.abs(step)}`}
    disabled={!onChange || (step < 0 ? amount === 0 : amount === limit)}
    onClick={() => update(amount + step)}
    className="h-11! w-7! min-w-0! shrink-0! rounded-none! border-0! p-0! text-white! shadow-none! transition-none! hover:bg-white/15! disabled:opacity-35! focus-visible:outline-2! focus-visible:-outline-offset-2! focus-visible:outline-white!">
    <svg aria-hidden="true" viewBox="0 0 24 24" className={'size-5 ' + (step < 0 ? 'rotate-180' : '')} fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d={Math.abs(step) === 5 ? 'm5 5 7 7-7 7 M12 5l7 7-7 7' : 'm9 5 7 7-7 7'} />
    </svg>
  </Button>

  return <div className="min-w-0 space-y-1.5">
    <p className="text-center text-xs font-semibold uppercase text-(--ink)">{label}</p>
    <div className="relative isolate overflow-hidden rounded-xl border border-white/45 bg-[#121212]">
      <motion.div role="progressbar" aria-label={label} aria-valuemin={0} aria-valuemax={limit} aria-valuenow={amount}
        aria-valuetext={`${amount} de ${limit}`} className={'absolute inset-0 -z-10 origin-left ' + colors[tone]}
        initial={false} animate={{ scaleX: limit === 0 ? 0 : amount / limit }}
        transition={reduced ? { duration: 0 } : { type: 'spring', stiffness: 180, damping: 28 }} />
      <div className="flex min-h-11 items-center px-0.5">
        {steps.slice(0, 2).map(control)}
        <div className="flex min-w-0 flex-1 items-center justify-center text-base font-semibold text-white">
          {editable && onChange ? <>
            <InputNumber aria-label={label + ' atual'} value={amount} min={0} max={limit} precision={0} controls={false} variant="borderless"
              onChange={(next) => { if (next !== null) update(next) }}
              className="w-11! min-w-0! rounded-sm! bg-transparent! p-0! shadow-none! transition-none! focus-within:bg-black/25! [&_input]:h-10! [&_input]:px-0! [&_input]:text-center! [&_input]:font-semibold! [&_input]:text-white!" />
            <span aria-hidden="true">/</span>
            <InputNumber aria-label={label + ' máxima'} value={limit} min={0} precision={0} controls={false} variant="borderless"
              onChange={(next) => { if (next !== null) update(amount, next) }}
              className="w-11! min-w-0! rounded-sm! bg-transparent! p-0! shadow-none! transition-none! focus-within:bg-black/25! [&_input]:h-10! [&_input]:px-0! [&_input]:text-center! [&_input]:font-semibold! [&_input]:text-white!" />
          </> : <span className="tabular-nums">{amount} / {limit}</span>}
        </div>
        {steps.slice(2).map(control)}
      </div>
    </div>
  </div>
}
