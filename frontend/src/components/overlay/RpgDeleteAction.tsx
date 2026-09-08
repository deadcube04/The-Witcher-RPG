import { useState } from 'react'
import { RpgButton } from '../primitives/RpgControls'
import { RpgConfirmDialog } from './RpgConfirmDialog'

export function RpgDeleteAction({ name, description, onDelete }: { name: string; description: string; onDelete: () => Promise<void> }) {
  const [open, setOpen] = useState(false)
  const [pending, setPending] = useState(false)
  const [error, setError] = useState<string | null>(null)
  async function confirm() {
    setPending(true)
    setError(null)
    try { await onDelete(); setOpen(false) }
    catch (cause: unknown) { setError(cause instanceof Error ? cause.message : 'Não foi possível excluir.') }
    finally { setPending(false) }
  }
  return <><RpgButton secondary danger onClick={() => setOpen(true)}>Excluir</RpgButton>
    <RpgConfirmDialog open={open} title={'Excluir ' + name + '?'} description={description} pending={pending} onCancel={() => setOpen(false)} onConfirm={() => void confirm()} error={error} /></>
}
