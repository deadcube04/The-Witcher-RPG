import type { ReactNode } from "react";
import { RpgButton } from "../primitives/RpgControls";
import { PiArchiveThin, PiWarningCircleThin } from "react-icons/pi";

export function RpgSkeleton() {
	return (
		<div
			role="status"
			aria-label="Carregando página"
			aria-busy="true"
			className="min-h-80 space-y-5 py-8"
		>
			<div className="h-3 w-28 animate-pulse rounded-full bg-(--edge) motion-reduce:animate-none" />
			<div className="h-16 max-w-2xl animate-pulse rounded-2xl bg-(--surface) motion-reduce:animate-none" />
			<div className="grid gap-5 pt-6 lg:grid-cols-[minmax(0,1.4fr)_minmax(18rem,0.6fr)]"><div className="min-h-72 animate-pulse rounded-3xl bg-(--surface-raised) motion-reduce:animate-none" /><div className="min-h-72 animate-pulse rounded-3xl border border-(--edge) bg-(--surface) motion-reduce:animate-none" /></div>
		</div>
	);
}
export function RpgErrorState({
	error,
	retry,
}: {
	error: Error;
	retry?: () => void;
}) {
	return (
		<section role="alert" className="grid min-h-80 place-items-center rounded-3xl border border-(--edge)/70 bg-(--surface) p-8 text-center">
			<div className="max-w-lg"><PiWarningCircleThin aria-hidden="true" className="mx-auto size-12 text-(--danger)" /><p className="mt-6 font-mono text-[10px] uppercase tracking-[0.22em] text-(--danger)">Interferência no arquivo</p><h2 className="mt-3 font-serif text-4xl">Não foi possível carregar</h2>
			<p className="my-5 text-sm leading-6 text-(--muted)">{error.message}</p>
			{retry && <RpgButton onClick={retry}>Tentar novamente</RpgButton>}
			</div>
		</section>
	);
}
export function RpgEmptyState({
	title,
	children,
}: {
	title: string;
	children: ReactNode;
}) {
	return (
		<section className="grid min-h-64 place-items-center rounded-3xl border border-dashed border-(--edge) bg-(--surface)/50 p-8 text-center">
			<div className="max-w-md"><PiArchiveThin aria-hidden="true" className="mx-auto size-10 text-(--accent)" /><h2 className="mt-5 font-serif text-3xl">{title}</h2><div className="mt-4 text-sm leading-6 text-(--muted)">{children}</div></div>
		</section>
	);
}
export function MutationFeedback({
	error,
	success,
}: {
	error: Error | null;
	success: boolean;
}) {
	if (error)
		return (
			<p role="alert" className="border-l-2 border-red-400 pl-3">
				{error.message}
			</p>
		);
	return success ? (
		<p role="status" className="text-(--accent)">
			Alterações salvas.
		</p>
	) : null;
}
