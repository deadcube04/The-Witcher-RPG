import { useEffect, useId, useRef, useState } from "react";
import { PiCameraThin } from "react-icons/pi";
import { RpgButton } from "@/components/primitives/RpgControls";
import { RpgImage } from "@/components/media/RpgImage";
import { PhotoCropDialog } from "@/components/media/PhotoCropDialog";
import { RpgModal } from "@/components/overlay/RpgModal";
import { readPhoto } from "@/components/media/image-crop";

type Props = {
	value: string;
	label: string;
	disabled?: boolean;
	compact?: boolean;
	onSave: (blob: Blob) => Promise<void>;
	onRemove: () => void;
	onBusyChange?: (busy: boolean) => void;
};
type Selection =
	| { kind: "idle" }
	| { kind: "reading" }
	| { kind: "crop"; bitmap: ImageBitmap };
export function PhotoPicker({
	value,
	label,
	disabled,
	compact = false,
	onSave,
	onRemove,
	onBusyChange,
}: Props) {
	const [selection, setSelection] = useState<Selection>({ kind: "idle" });
	const [error, setError] = useState("");
	const [manageOpen, setManageOpen] = useState(false);
	const input = useRef<HTMLInputElement>(null);
	const bitmapRef = useRef<ImageBitmap | null>(null);
	const generation = useRef(0);
	const labelId = useId();
	const busy = selection.kind !== "idle";
	useEffect(() => {
		onBusyChange?.(busy);
	}, [busy, onBusyChange]);
	useEffect(
		() => () => {
			generation.current += 1;
			bitmapRef.current?.close();
		},
		[],
	);
	const close = () => {
		bitmapRef.current?.close();
		bitmapRef.current = null;
		setSelection({ kind: "idle" });
	};
	const choosePhoto = () => {
		setManageOpen(false);
		input.current?.click();
	};
	return (
		<section
			aria-labelledby={labelId}
			className={compact ? "min-w-0" : "space-y-3"}
		>
			<p id={labelId} className={compact ? "sr-only" : "text-sm font-semibold"}>
				{label}
			</p>
			{compact ? (
				<button
					type="button"
					aria-label={`Gerenciar ${label.toLowerCase()}`}
					aria-haspopup="dialog"
					aria-expanded={manageOpen}
					disabled={disabled || busy}
					onClick={() => setManageOpen(true)}
					className="group relative block size-20 overflow-hidden rounded-2xl ring-1 ring-(--edge)/60 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-(--accent) sm:size-24"
				>
					<RpgImage
						src={value}
						alt=""
						className="size-full object-cover transition-transform duration-300 ease-[cubic-bezier(0.32,0.72,0,1)] group-hover:scale-105"
					/>
					<span className="absolute inset-0 grid place-items-center bg-black/0 text-white transition-colors duration-200 group-hover:bg-black/45 group-hover:text-white">
						<span className="grid size-9 place-items-center rounded-full bg-black/55 text-xl text-white opacity-0 shadow-sm group-hover:opacity-100 group-focus-visible:opacity-100">
							<PiCameraThin aria-hidden="true" />
							<span className="sr-only">Editar imagem</span>
						</span>
					</span>
				</button>
			) : (
				<RpgImage
					src={value}
					alt={label}
					className="aspect-square w-36 max-w-full rounded-xl"
				/>
			)}
			<input
				ref={input}
				type="file"
				accept="image/jpeg,image/png,image/webp"
				className="hidden"
				aria-label={`Selecionar ${label.toLowerCase()}`}
				disabled={disabled || busy}
				onChange={(event) => {
					const file = event.target.files?.[0];
					event.target.value = "";
					if (!file) return;
					const current = ++generation.current;
					setError("");
					setSelection({ kind: "reading" });
					void readPhoto(file)
						.then((bitmap) => {
							if (current !== generation.current) {
								bitmap.close();
								return;
							}
							bitmapRef.current = bitmap;
							setSelection({ kind: "crop", bitmap });
						})
						.catch((reason: unknown) => {
							if (current !== generation.current) return;
							setError(
								reason instanceof Error
									? reason.message
									: "Não foi possível abrir esta imagem.",
							);
							setSelection({ kind: "idle" });
						});
				}}
			/>
			{!compact && (
				<div className="flex flex-wrap gap-2">
					<RpgButton
						secondary
						disabled={disabled || busy}
						loading={selection.kind === "reading"}
						onClick={choosePhoto}
					>
						{value ? "Trocar foto" : "Escolher foto"}
					</RpgButton>
					{value && (
						<RpgButton secondary disabled={disabled || busy} onClick={onRemove}>
							Remover foto
						</RpgButton>
					)}
				</div>
			)}
			{!compact && (
				<p className="text-xs text-(--muted)">
					JPEG, PNG ou WebP estático. Até 10 MiB e 25 megapixels.
				</p>
			)}
			{error && (
				<p
					role="alert"
					className={`text-sm text-(--danger) ${compact ? "mt-2 max-w-28" : ""}`}
				>
					{error}
				</p>
			)}
			{compact && (
				<RpgModal
					open={manageOpen}
					title="Gerenciar retrato"
					onClose={() => setManageOpen(false)}
					width={420}
				>
					<div className="space-y-4">
						<p className="text-sm text-(--muted)">
							{value
								? "Troque ou remova a imagem deste personagem."
								: "Adicione uma imagem para identificar este personagem."}
						</p>
						<div className="flex flex-wrap gap-2">
							<RpgButton
								secondary
								disabled={disabled || busy}
								loading={selection.kind === "reading"}
								onClick={choosePhoto}
							>
								{value ? "Trocar imagem" : "Adicionar imagem"}
							</RpgButton>
							{value && (
								<RpgButton
									danger
									disabled={disabled || busy}
									onClick={() => {
										onRemove();
										setManageOpen(false);
									}}
								>
									Remover imagem
								</RpgButton>
							)}
						</div>
						<p className="text-xs text-(--muted)">
							JPEG, PNG ou WebP estático. Até 10 MiB e 25 megapixels.
						</p>
					</div>
				</RpgModal>
			)}
			{selection.kind === "crop" && (
				<PhotoCropDialog
					bitmap={selection.bitmap}
					onClose={close}
					onSave={onSave}
				/>
			)}
		</section>
	);
}
