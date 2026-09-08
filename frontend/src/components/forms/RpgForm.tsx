import type { ReactNode } from 'react'

export function RpgForm({ children, onSubmit }: { children: ReactNode; onSubmit: () => Promise<void> }) {
  return <form className="space-y-6" onSubmit={(event) => { event.preventDefault(); event.stopPropagation(); void onSubmit() }}>{children}</form>
}
