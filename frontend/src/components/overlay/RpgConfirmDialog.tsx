import { Modal } from 'antd'
import { RpgButton } from '../primitives/RpgControls'

export function RpgConfirmDialog({ open, title, description, pending, onCancel, onConfirm, error }: {
  open: boolean; title: string; description: string; pending: boolean; onCancel: () => void; onConfirm: () => void; error?: string | null
}) {
  return <Modal open={open} title={title} onCancel={pending ? undefined : onCancel} closable={!pending} keyboard={!pending}
    mask={{ closable: !pending }} footer={<div className="flex flex-wrap justify-end gap-3">
      <RpgButton secondary disabled={pending} onClick={onCancel}>Cancelar</RpgButton>
      <RpgButton danger loading={pending} onClick={onConfirm}>Confirmar exclusão</RpgButton>
    </div>}><p className="py-4">{description}</p>{error && <p role="alert">{error}</p>}</Modal>
}
