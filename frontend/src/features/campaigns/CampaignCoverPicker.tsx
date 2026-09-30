import { useEffect, useRef, useState } from "react";
import { RpgButton, RpgNumber } from "@/components/primitives/RpgControls";
import { RpgModal } from "@/components/overlay/RpgModal";
import { readPhoto } from "@/components/media/image-crop";

type Crop = { zoom: number; x: number; y: number };
const initialCrop: Crop = { zoom: 100, x: 50, y: 50 };

function sourceRect(bitmap: ImageBitmap, crop: Crop) {
	const width = Math.min(bitmap.width, bitmap.height * 16 / 9) * 100 / crop.zoom;
	const height = width * 9 / 16;
	return { x: (bitmap.width - width) * crop.x / 100, y: (bitmap.height - height) * crop.y / 100, width, height };
}

function drawCover(canvas: HTMLCanvasElement, bitmap: ImageBitmap, crop: Crop): void {
	const context = canvas.getContext("2d");
	if (!context) throw new Error("Não foi possível preparar o recorte.");
	const rect = sourceRect(bitmap, crop);
	context.clearRect(0, 0, canvas.width, canvas.height);
	context.drawImage(bitmap, rect.x, rect.y, rect.width, rect.height, 0, 0, canvas.width, canvas.height);
}

async function exportCover(bitmap: ImageBitmap, crop: Crop): Promise<Blob> {
	const canvas = document.createElement("canvas");
	canvas.width = 1600;
	canvas.height = 900;
	drawCover(canvas, bitmap, crop);
	return new Promise((resolve, reject) => canvas.toBlob((blob) => {
		if (!blob || blob.size > 10 * 1024 * 1024) reject(new Error("A capa recortada excede 10 MiB."));
		else resolve(blob);
	}, "image/png"));
}

export function CampaignCoverPicker({
	hasCover, disabled, onChange,
}: {
	hasCover: boolean;
	disabled?: boolean;
	onChange: (cover: Blob | null) => Promise<void>;
}) {
	const input = useRef<HTMLInputElement>(null);
	const canvas = useRef<HTMLCanvasElement>(null);
	const [bitmap, setBitmap] = useState<ImageBitmap | null>(null);
	const [crop, setCrop] = useState<Crop>(initialCrop);
	const [pending, setPending] = useState(false);
	const [error, setError] = useState("");
	useEffect(() => { if (bitmap && canvas.current) drawCover(canvas.current, bitmap, crop); }, [bitmap, crop]);
	useEffect(() => () => { bitmap?.close(); }, [bitmap]);
	const close = () => { bitmap?.close(); setBitmap(null); setCrop(initialCrop); };
	return <section className="space-y-3" aria-label="Capa da campanha">
		<p className="text-sm font-semibold">Capa da campanha <span className="font-normal text-(--muted)">(opcional)</span></p>
		<div className="flex flex-wrap gap-3">
			<RpgButton secondary disabled={disabled || pending} onClick={() => input.current?.click()}>{hasCover ? "Trocar capa" : "Escolher capa"}</RpgButton>
			{hasCover && <RpgButton secondary disabled={disabled || pending} onClick={() => { void onChange(null).catch(() => setError("Não foi possível remover a capa do rascunho.")); }}>Remover capa</RpgButton>}
		</div>
		<input ref={input} type="file" accept="image/jpeg,image/png,image/webp" aria-label="Selecionar capa da campanha" className="sr-only" disabled={disabled || pending} onChange={(event) => {
			const file = event.target.files?.[0]; event.target.value = "";
			if (!file) return;
			setError(""); setPending(true);
			void readPhoto(file).then((image) => { setBitmap(image); setCrop(initialCrop); }).catch((reason: unknown) => setError(reason instanceof Error ? reason.message : "Não foi possível abrir a imagem.")).finally(() => setPending(false));
		}} />
		<p className="text-xs text-(--muted)">JPEG, PNG ou WebP estático. Até 10 MiB e 25 megapixels. Recorte horizontal 16:9.</p>
		{error && <p role="alert" className="text-sm text-(--danger)">{error}</p>}
		<RpgModal open={bitmap !== null} title="Enquadrar capa" onClose={close} pending={pending} width={760} footer={<div className="flex justify-end gap-3">
			<RpgButton secondary disabled={pending} onClick={close}>Cancelar</RpgButton>
			<RpgButton loading={pending} onClick={() => {
				if (!bitmap) return;
				setError(""); setPending(true);
				void exportCover(bitmap, crop).then(onChange).then(close).catch((reason: unknown) => setError(reason instanceof Error ? reason.message : "Não foi possível preparar a capa.")).finally(() => setPending(false));
			}}>Usar capa</RpgButton>
		</div>}>
			<div className="space-y-4">
				<canvas ref={canvas} width={960} height={540} role="img" aria-label="Prévia do recorte horizontal" className="aspect-video w-full rounded-xl border border-(--edge)" />
				<div className="grid gap-3 sm:grid-cols-3">
					<RpgNumber label="Zoom (%)" min={100} max={300} value={crop.zoom} disabled={pending} onChange={(zoom) => setCrop((current) => ({ ...current, zoom }))} />
					<RpgNumber label="Posição horizontal (%)" min={0} max={100} value={crop.x} disabled={pending} onChange={(x) => setCrop((current) => ({ ...current, x }))} />
					<RpgNumber label="Posição vertical (%)" min={0} max={100} value={crop.y} disabled={pending} onChange={(y) => setCrop((current) => ({ ...current, y }))} />
				</div>
			</div>
		</RpgModal>
	</section>;
}
