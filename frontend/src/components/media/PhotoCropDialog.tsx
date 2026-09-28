import { useEffect, useRef, useState, type PointerEvent } from "react";
import { RpgModal } from "@/components/overlay/RpgModal";
import { RpgButton, RpgNumber } from "@/components/primitives/RpgControls";
import { drawCrop, exportCrop, initialCrop } from "@/components/media/image-crop";

type Props = { bitmap: ImageBitmap; onClose: () => void; onSave: (blob: Blob) => Promise<void> };
export function PhotoCropDialog({ bitmap, onClose, onSave }: Props) {
 const [crop, setCrop] = useState(initialCrop);
 const [pending, setPending] = useState(false);
 const [error, setError] = useState("");
 const canvas = useRef<HTMLCanvasElement>(null);
 const drag = useRef<{ x: number; y: number } | null>(null);
 useEffect(() => { if (canvas.current) drawCrop(canvas.current, bitmap, crop); }, [bitmap, crop]);
 const move = (event: PointerEvent<HTMLCanvasElement>) => {
  const previous = drag.current;
  if (!previous || pending) return;
  const width = event.currentTarget.getBoundingClientRect().width;
  const side = Math.min(bitmap.width, bitmap.height) * 100 / crop.zoom;
  const dx = (event.clientX - previous.x) * side / width;
  const dy = (event.clientY - previous.y) * side / width;
  setCrop((value) => ({ ...value, x: Math.max(0, Math.min(100, value.x - dx / Math.max(1, bitmap.width - side) * 100)), y: Math.max(0, Math.min(100, value.y - dy / Math.max(1, bitmap.height - side) * 100)) }));
  drag.current = { x: event.clientX, y: event.clientY };
 };
 return <RpgModal open title="Enquadrar foto" pending={pending} onClose={onClose} width={520} footer={<div className="flex flex-wrap justify-end gap-3">
  <RpgButton secondary disabled={pending} onClick={onClose}>Cancelar</RpgButton>
  <RpgButton loading={pending} onClick={() => {
   setPending(true); setError("");
   void exportCrop(bitmap, crop).then(onSave).then(onClose).catch((reason: unknown) => {
    setError(reason instanceof Error ? reason.message : "Não foi possível enviar a foto.");
    setPending(false);
   });
  }}>Usar foto</RpgButton>
 </div>}>
  <div className="space-y-5">
   <p className="text-sm text-(--muted)">Arraste para mover ou use os controles abaixo. O recorte é quadrado.</p>
   <canvas ref={canvas} width={512} height={512} role="img" aria-label="Prévia do recorte da foto" className="mx-auto aspect-square w-full max-w-80 touch-none cursor-move rounded-xl border border-(--edge) bg-(--canvas)"
    onPointerDown={(event) => { if (!pending) { event.currentTarget.setPointerCapture(event.pointerId); drag.current = { x: event.clientX, y: event.clientY }; } }} onPointerMove={move} onPointerUp={() => { drag.current = null; }} onPointerCancel={() => { drag.current = null; }} />
   <RpgNumber label="Zoom (%)" min={100} max={400} value={crop.zoom} disabled={pending} onChange={(zoom) => setCrop({ ...crop, zoom: Math.max(100, Math.min(400, zoom)) })} />
   <div className="grid grid-cols-2 gap-3">
    <RpgNumber label="Posição horizontal (%)" min={0} max={100} value={Math.round(crop.x)} disabled={pending} onChange={(x) => setCrop({ ...crop, x: Math.max(0, Math.min(100, x)) })} />
    <RpgNumber label="Posição vertical (%)" min={0} max={100} value={Math.round(crop.y)} disabled={pending} onChange={(y) => setCrop({ ...crop, y: Math.max(0, Math.min(100, y)) })} />
   </div>
   {error && <p role="alert" className="text-sm text-(--danger)">{error}</p>}
  </div>
 </RpgModal>;
}
