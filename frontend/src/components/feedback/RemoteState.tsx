import { Skeleton } from 'antd'
import type { ReactNode } from 'react'
import { RpgButton } from '../primitives/RpgControls'

export function RpgSkeleton() {
  return <div role="status" aria-label="Carregando" className="space-y-6 py-8"><Skeleton active={false} paragraph={{ rows: 5 }} /></div>
}
export function RpgErrorState({ error, retry }: { error: Error; retry?: () => void }) {
  return <section role="alert" className="space-y-4 border border-(--edge) p-6"><h2 className="text-xl font-semibold">Não foi possível carregar</h2><p>{error.message}</p>{retry && <RpgButton onClick={retry}>Tentar novamente</RpgButton>}</section>
}
export function RpgEmptyState({ title, children }: { title: string; children: ReactNode }) {
  return <section className="space-y-4 border border-dashed border-(--edge) p-8"><h2 className="text-xl font-semibold">{title}</h2>{children}</section>
}
export function MutationFeedback({ error, success }: { error: Error | null; success: boolean }) {
  if (error) return <p role="alert" className="border-l-2 border-red-400 pl-3">{error.message}</p>
  return success ? <p role="status" className="text-(--accent)">Alterações salvas.</p> : null
}
