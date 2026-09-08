import { LuCloud, LuCloudUpload } from 'react-icons/lu'
import { motion, useReducedMotion } from 'motion/react'
import type { AutoSaveStatus } from './useAutoSaveIndicator'

const labels: Record<AutoSaveStatus, string> = { saved: 'Alterações locais atualizadas', pending: 'Atualizando alterações locais' }

export function AutoSaveIndicator({ status }: { status: AutoSaveStatus }) {
  const reduced = useReducedMotion()
  const label = labels[status]
  const Icon = status === 'saved' ? LuCloud : LuCloudUpload
  return <div role="status" aria-label={label} title={label} className="grid size-11 place-items-center rounded-lg border border-(--edge) text-(--accent)">
    <motion.span animate={status === 'pending' && !reduced ? { y: [0, -2, 0] } : { y: 0 }} transition={{ duration: 0.8, repeat: status === 'pending' && !reduced ? Number.POSITIVE_INFINITY : 0 }}>
      <Icon aria-hidden="true" className="size-5" />
    </motion.span>
  </div>
}
