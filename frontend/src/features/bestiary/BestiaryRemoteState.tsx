import { RpgButton } from "@/components/primitives/RpgControls";

export function BestiaryLoading({
	variant,
}: {
	variant: "gallery" | "results" | "detail";
}) {
	return (
		<div
			role="status"
			aria-busy="true"
			aria-label="Abrindo registros do bestiário"
			className="mx-auto max-w-[1480px]"
		>
			<p className="mb-4 text-sm text-(--muted)">Carregando ameaças…</p>
			{variant === "gallery" ? (
				<>
					<div className="h-40 rounded-2xl bg-(--surface)/65" />
					<div className="mt-8 grid gap-5 sm:grid-cols-2 xl:grid-cols-3">
						{[0, 1, 2].map((item) => (
							<div
								key={item}
								className="h-80 rounded-[1.7rem] bg-(--surface)/65"
							/>
						))}
					</div>
				</>
			) : variant === "results" ? (
				<div className="grid gap-5 sm:grid-cols-2 xl:grid-cols-3">
					{[0, 1, 2].map((item) => (
						<div
							key={item}
							className="h-80 rounded-[1.7rem] bg-(--surface)/65"
						/>
					))}
				</div>
			) : (
				<div className="grid gap-6 lg:grid-cols-2">
					<div className="h-80 rounded-[1.7rem] bg-(--surface)/65 lg:h-[31rem]" />
					<div className="py-6">
						<div className="h-14 w-2/3 rounded-lg bg-(--surface)/65" />
						<div className="mt-7 h-24 w-full rounded-lg bg-(--surface)/65" />
						<div className="mt-7 h-20 w-4/5 rounded-lg bg-(--surface)/65" />
					</div>
				</div>
			)}
		</div>
	);
}

export function BestiaryError({
	error,
	retry,
}: {
	error: Error;
	retry: () => void;
}) {
	return (
		<section
			role="alert"
			className="mx-auto max-w-[1480px] border border-(--edge) bg-(--surface) p-7 md:p-10"
		>
			<p className="font-mono text-[10px] uppercase tracking-[0.2em] text-(--danger)">
				Arquivo interrompido
			</p>
			<h2 className="mt-3 font-serif text-4xl">
				Não foi possível abrir este registro
			</h2>
			<p className="mt-3 max-w-xl text-sm leading-6 text-(--muted)">
				A ligação com o arquivo falhou. Tente abrir o registro novamente.
			</p>
			<p className="mt-2 max-w-xl break-words font-mono text-xs text-(--muted)">
				{error.message}
			</p>
			<div className="mt-6">
				<RpgButton onClick={retry}>Tentar novamente</RpgButton>
			</div>
		</section>
	);
}
