import { useState } from "react";

export function RpgImage({ src, alt, className = "aspect-square w-full rounded-xl" }: { src?: string | null; alt: string; className?: string }) {
 return <ImageContent key={src || "empty"} src={src} alt={alt} className={className} />;
}
function ImageContent({ src, alt, className }: { src?: string | null; alt: string; className: string }) {
 const [failed, setFailed] = useState(false);
 return <div className={`overflow-hidden border border-(--edge) bg-(--surface-raised) ${className}`}>
  {src && !failed ? <img src={src} alt={alt} onError={() => setFailed(true)} className="h-full w-full object-contain" loading="lazy" /> :
   <div className="grid h-full min-h-24 place-items-center p-4 text-center text-xs text-(--muted)">{src ? "Imagem indisponível" : "Sem imagem"}</div>}
 </div>;
}
