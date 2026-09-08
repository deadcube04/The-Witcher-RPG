import type { ReactNode } from 'react'

export function PageHeader({ eyebrow, title, description, actions }: { eyebrow: string; title: string; description?: string; actions?: ReactNode }) {
  return <header className="mb-8 flex flex-wrap items-end justify-between gap-5 border-b border-(--edge) pb-7">
    <div className="max-w-2xl"><p className="mb-3 font-mono text-xs uppercase tracking-[0.24em] text-(--accent)">{eyebrow}</p>
      <h2 className="text-3xl font-semibold tracking-tight md:text-5xl">{title}</h2>
      {description && <p className="mt-4 max-w-xl text-sm leading-6 opacity-75">{description}</p>}</div>
    <div className="flex flex-wrap gap-3">{actions}</div>
  </header>
}
