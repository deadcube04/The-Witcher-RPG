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
			<p className="mb-4 font-mono text-xs uppercase tracking-[0.18em] text-(--muted)">
				Abrindo registros…
			</p>
			{variant === "gallery" ? (
				<>
					<div className="h-72 border border-(--edge) bg-(--surface)" />
					<div className="mt-8 grid gap-3 sm:grid-cols-2 lg:grid-cols-5">
						{[0, 1, 2, 3, 4].map((item) => (
							<div
								key={item}
								className="h-52 border border-(--edge) bg-(--surface-raised)"
							/>
						))}
					</div>
					<div className="mt-10 h-24 border border-(--edge) bg-(--surface)" />
				</>
			) : variant === "results" ? (
				<div className="grid gap-5 sm:grid-cols-2 2xl:grid-cols-3">
					{[0, 1, 2].map((item) => (
						<div
							key={item}
							className="h-96 border border-(--edge) bg-(--surface)"
						/>
					))}
				</div>
			) : (
				<div className="grid gap-px border border-(--edge) bg-(--edge) lg:grid-cols-2">
					<div className="min-h-[65dvh] bg-[#eeeae2] p-8">
						<div className="h-12 w-2/3 bg-[#c9c2b5]" />
						<div className="mt-7 h-80 bg-[#d8d0c2]" />
					</div>
					<div className="min-h-[65dvh] bg-[#eeeae2] p-8">
						<div className="h-8 w-1/2 bg-[#c9c2b5]" />
						<div className="mt-8 grid grid-cols-2 gap-3">
							{[0, 1, 2, 3].map((item) => (
								<div key={item} className="h-24 bg-[#d8d0c2]" />
							))}
						</div>
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
