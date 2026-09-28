import { useMutation } from "@tanstack/react-query";
import { useEffect, useRef } from "react";
import { PhotoPicker } from "@/components/media/PhotoPicker";
import { uploadImage } from "@/shared/api/media";
import type { ImagePurpose } from "@/shared/contracts/media";

type Props = { value: string; purpose: ImagePurpose; onChange: (url: string) => void; disabled?: boolean; onBusyChange?: (busy: boolean) => void };
export function PhotoField({ value, purpose, onChange, disabled, onBusyChange }: Props) {
 const latestChange = useRef(onChange);
 useEffect(() => { latestChange.current = onChange; }, [onChange]);
 const mutation = useMutation({ mutationFn: (blob: Blob) => uploadImage(blob, purpose) });
 return <PhotoPicker value={value} label={purpose === "profile" ? "Foto de perfil" : "Retrato do personagem"} disabled={disabled || mutation.isPending} onBusyChange={onBusyChange} onRemove={() => onChange("")} onSave={async (blob) => {
  const url = await mutation.mutateAsync(blob);
  latestChange.current(url);
 }} />;
}
