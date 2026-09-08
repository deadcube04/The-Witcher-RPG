import { useEffect, useState, type ReactNode } from 'react'
import { AnimatePresence, motion, useReducedMotion } from 'motion/react'

export type SheetDrawer = { key: string; label: string; icon: ReactNode; children: ReactNode }
const rowClasses = ['row-start-1', 'row-start-2', 'row-start-3', 'row-start-4'] as const

export function RpgSheetDrawers({ items }: { items: SheetDrawer[] }) {
  const [activeKey, setActiveKey] = useState<string | null>(null)
  const reduced = useReducedMotion()
  const active = items.find((item) => item.key === activeKey)
  const activeIndex = items.findIndex((item) => item.key === activeKey)
  useEffect(() => {
    if (!activeKey) return
    const onKeyDown = (event: KeyboardEvent) => { if (event.key === 'Escape') setActiveKey(null) }
    window.addEventListener('keydown', onKeyDown)
    return () => window.removeEventListener('keydown', onKeyDown)
  }, [activeKey])
  return <div className="pointer-events-none absolute inset-0 z-30 overflow-visible">
    {active ? <div aria-hidden="true" className="absolute inset-y-0 right-0 grid w-[clamp(72px,7vw,112px)] grid-rows-[repeat(4,minmax(0,1fr))] gap-4">
      {items.map((item) => <div key={item.key} className="grid place-items-center rounded-l-3xl border border-r-0 border-(--edge) bg-(--panel) text-3xl text-(--ink) md:text-4xl">{item.icon}</div>)}
    </div> : <div className="pointer-events-auto absolute inset-y-0 right-0 grid w-[clamp(72px,7vw,112px)] grid-rows-[repeat(4,minmax(0,1fr))] gap-4">
      {items.map((item) => <button key={item.key} type="button" aria-label={'Abrir ' + item.label} aria-expanded={false} onClick={() => setActiveKey(item.key)}
        className="grid h-full w-full place-items-center rounded-l-3xl border border-r-0 border-(--edge) bg-(--panel) text-3xl text-(--ink) shadow-xl hover:text-(--accent) focus-visible:z-10 focus-visible:outline-2 focus-visible:outline-(--accent) md:text-4xl">
        {item.icon}<span className="sr-only">{item.label}</span>
      </button>)}
    </div>}
    <AnimatePresence>
      {active && <motion.div key={active.key} role="dialog" aria-modal="false" aria-label={active.label}
        initial={reduced ? false : { x: 'calc(100% - clamp(72px, 7vw, 112px))' }} animate={{ x: 0 }}
        exit={reduced ? undefined : { x: 'calc(100% - clamp(72px, 7vw, 112px))' }} transition={{ duration: reduced ? 0 : 0.28 }}
        className="pointer-events-auto absolute inset-y-0 right-0 -left-[clamp(72px,7vw,112px)] grid grid-cols-[clamp(72px,7vw,112px)_minmax(0,1fr)] grid-rows-[repeat(4,minmax(0,1fr))] gap-y-4 overflow-visible">
        <button type="button" aria-label={'Fechar ' + active.label} aria-expanded="true" onClick={() => setActiveKey(null)}
          className={'col-start-1 grid h-full w-full place-items-center rounded-l-3xl border border-r-0 border-(--accent) bg-(--panel) text-3xl text-(--accent) shadow-xl focus-visible:outline-2 focus-visible:outline-(--accent) md:text-4xl ' + (rowClasses[activeIndex] ?? 'row-start-1')}>
          {active.icon}<span className="sr-only">{active.label}</span>
        </button>
        <section className="col-start-2 row-start-1 row-end-5 flex min-w-0 flex-col overflow-y-auto rounded-r-3xl border border-(--edge) bg-(--panel) p-5 shadow-2xl md:p-8">
          <div className="mb-6 flex items-center justify-between border-b border-(--edge) pb-4"><h3 className="text-xl font-semibold">{active.label}</h3>
            <button type="button" aria-label={'Fechar ' + active.label} onClick={() => setActiveKey(null)} className="grid size-10 place-items-center rounded-full border border-(--edge) text-xl hover:text-(--accent) focus-visible:outline-2 focus-visible:outline-(--accent)">×</button>
          </div>
          {active.children}
        </section>
      </motion.div>}
    </AnimatePresence>
  </div>
}
