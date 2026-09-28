export type Crop = { zoom: number; x: number; y: number };
export const initialCrop: Crop = { zoom: 100, x: 50, y: 50 };

export async function readPhoto(file: File): Promise<ImageBitmap> {
 if (!file.size || file.size > 10 * 1024 * 1024) throw new Error("Escolha uma imagem de até 10 MiB.");
 const buffer = await file.arrayBuffer();
 const bytes = new Uint8Array(buffer);
 const view = new DataView(buffer);
 const chunk = (offset: number) => String.fromCharCode(...bytes.slice(offset, offset + 4));
 const png = chunk(1) === "PNG\r";
 const webp = chunk(0) === "RIFF" && chunk(8) === "WEBP";
 const jpeg = bytes[0] === 255 && bytes[1] === 216 && bytes[2] === 255;
 if (!png && !webp && !jpeg) throw new Error("Use JPEG, PNG ou WebP estático.");
 if (png || webp) {
  for (let offset = png ? 8 : 12; offset + (png ? 12 : 8) <= bytes.length;) {
   const size = view.getUint32(offset + (png ? 0 : 4), webp);
   const name = chunk(offset + (png ? 4 : 0));
   if (["acTL", "ANIM", "ANMF"].includes(name)) throw new Error("Escolha uma imagem sem animação.");
   offset += size + (png ? 12 : 8 + size % 2);
  }
 }
 const bitmap = await createImageBitmap(file, { imageOrientation: "from-image" });
 if (bitmap.width * bitmap.height > 25_000_000) { bitmap.close(); throw new Error("A imagem deve ter até 25 megapixels."); }
 return bitmap;
}

export function drawCrop(canvas: HTMLCanvasElement, bitmap: ImageBitmap, crop: Crop): void {
 const context = canvas.getContext("2d");
 if (!context) throw new Error("Seu navegador não conseguiu preparar o recorte.");
 const side = Math.min(bitmap.width, bitmap.height) * 100 / crop.zoom;
 const x = (bitmap.width - side) * crop.x / 100;
 const y = (bitmap.height - side) * crop.y / 100;
 context.clearRect(0, 0, canvas.width, canvas.height);
 context.drawImage(bitmap, x, y, side, side, 0, 0, canvas.width, canvas.height);
}

export async function exportCrop(bitmap: ImageBitmap, crop: Crop): Promise<Blob> {
 const canvas = document.createElement("canvas");
 canvas.width = canvas.height = Math.max(1, Math.min(1024, Math.floor(Math.min(bitmap.width, bitmap.height) * 100 / crop.zoom)));
 drawCrop(canvas, bitmap, crop);
 return new Promise((resolve, reject) => canvas.toBlob((blob) => {
  if (!blob || blob.size > 10 * 1024 * 1024) reject(new Error("Não foi possível preparar a imagem. Tente um recorte menor."));
  else resolve(blob);
 }, "image/png"));
}
