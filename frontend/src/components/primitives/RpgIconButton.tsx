import { Button, Tooltip } from 'antd'
import type { ReactNode } from 'react'

type Props = { label: string; children: ReactNode; onClick: () => void; expanded?: boolean; controls?: string }
export function RpgIconButton({ label, children, onClick, expanded, controls }: Props) {
  return <Tooltip title={label} placement="right">
    <Button type="text" aria-label={label} aria-expanded={expanded} aria-controls={controls} onClick={onClick}
      className="size-11! shrink-0! rounded-sm! border! border-(--edge)! text-(--ink)! hover:bg-(--canvas)! focus-visible:outline-2! focus-visible:outline-(--accent)!">
      {children}
    </Button>
  </Tooltip>
}
