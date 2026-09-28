import { useEffect, useId, useRef, useState } from "react";
import { RpgButton } from "@/components/primitives/RpgControls";
import { RpgImage } from "@/components/media/RpgImage";
import { PhotoCropDialog } from "@/components/media/PhotoCropDialog";
import { readPhoto } from "@/components/media/image-crop";

type Props = { value: string; label: string; disabled?: boolean; onSave: (blob: Blob) => Promise<void>; onRemove: () => void; onBusyChange?: (busy: boolean) => void };
type Selection = { kind: "idle" } | { kind: "reading" } | { kind: "crop"; bitmap: ImageBitmap };
export function PhotoPicker({ value, label, disabled, onSave, onRemove, onBusyChange }: Props) {
 const [selection, setSelection] = useState<Selection>({ kind: "idle" });
 const [error, setError] = useState("");
 const input = useRef<HTMLInputElement>(null);
 const bitmapRef = useRef<ImageBitmap | null>(null);
 const generation = useRef(0);
 const labelId = useId();
 const busy = selection.kind !== "idle";
 useEffect(() => { onBusyChange?.(busy); }, [busy, onBusyChange]);
 useEffect(() => () => { generation.current += 1; bitmapRef.current?.close(); }, []);
 const close = () => { bitmapRef.current?.close(); bitmapRef.current = null; setSelection({ kind: "idle" }); };
 return <section aria-labelledby={labelId} className="space-y-3">
  <p id={labelId} className="text-sm font-semibold">{label}</p>
  <RpgImage src={value} alt={label} className="aspect-square w-36 max-w-full rounded-xl" />
  <input ref={input} type="file" accept="image/jpeg,image/png,image/webp" className="hidden" aria-label={`Selecionar ${label.toLowerCase()}`} disabled={disabled || busy} onChange={(event) => {
   const file = event.target.files?.[0]; event.target.value = ""; if (!file) return;
   const current = ++generation.current; setError(""); setSelection({ kind: "reading" });
   void readPhoto(file).then((bitmap) => {
    if (current !== generation.current) { bitmap.close(); return; }
    bitmapRef.current = bitmap; setSelection({ kind: "crop", bitmap });
   }).catch((reason: unknown) => {
    if (current !== generation.current) return;
    setError(reason instanceof Error ? reason.message : "Não foi possível abrir esta imagem."); setSelection({ kind: "idle" });
   });
  }} />
  <div className="flex flex-wrap gap-2">
   <RpgButton secondary disabled={disabled || busy} loading={selection.kind === "reading"} onClick={() => input.current?.click()}>{value ? "Trocar foto" : "Escolher foto"}</RpgButton>
   {value && <RpgButton secondary disabled={disabled || busy} onClick={onRemove}>Remover foto</RpgButton>}
  </div>
  <p className="text-xs text-(--muted)">JPEG, PNG ou WebP estático. Até 10 MiB e 25 megapixels.</p>
  {error && <p role="alert" className="text-sm text-(--danger)">{error}</p>}
  {selection.kind === "crop" && <PhotoCropDialog bitmap={selection.bitmap} onClose={close} onSave={onSave} />}
 </section>;
}
