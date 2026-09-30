import { z } from "zod";

const publicBase = new URL(import.meta.env.VITE_MEDIA_PUBLIC_URL || "http://127.0.0.1:9000/rpg-media");
export const imageUrlSchema = z.string().max(2048).refine((raw) => {
 if (raw === "") return true;
 try {
  const url = new URL(raw);
  if (url.username || url.password || url.hash) return false;
  return url.protocol === "https:" || (url.protocol === "http:" &&
   ["localhost", "127.0.0.1"].includes(publicBase.hostname) && url.origin === publicBase.origin &&
   url.pathname.startsWith(`${publicBase.pathname.replace(/\/$/, "")}/`) && !url.search);
 } catch { return false; }
}, "Use uma imagem enviada ou uma URL HTTPS válida.");
export const imageUploadSchema = z.strictObject({ imageUrl: imageUrlSchema });
export type ImagePurpose = "profile" | "character" | "campaign";
