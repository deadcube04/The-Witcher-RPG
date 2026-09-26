import { useState } from "react";
import type { ReactNode } from "react";
import { RpgErrorState, RpgSkeleton } from "@/components/feedback/RemoteState";
import { RpgModal } from "@/components/overlay/RpgModal";
import { RpgButton, RpgInput } from "@/components/primitives/RpgControls";
import type { ContentSource } from "@/shared/contracts/content-source";

type CatalogChoice = {
	id: string;
	name: string;
	description: string;
	source: ContentSource;
};

export function CatalogPickerModal<TChoice extends CatalogChoice>({
	open,
	title,
	query,
	onQueryChange,
	items,
	loading,
	error,
	actionError,
	pending,
	onRetry,
	onAdd,
	renderMeta,
	renderActions,
	createForm,
	onClose,
}: {
	open: boolean;
	title: string;
	query: string;
	onQueryChange: (value: string) => void;
	items: TChoice[];
	loading: boolean;
	error: Error | null;
	actionError?: Error | null;
	pending: boolean;
	onRetry: () => void;
	onAdd: (item: TChoice) => void;
	renderMeta: (item: TChoice) => ReactNode;
	renderActions?: (item: TChoice) => ReactNode;
	createForm: ReactNode;
	onClose: () => void;
}) {
	const [creating, setCreating] = useState(false);
	return (
		<RpgModal
			open={open}
			title={creating ? `Criar ${title.toLocaleLowerCase("pt-BR")}` : title}
			onClose={onClose}
			afterClose={() => setCreating(false)}
			pending={pending}
		>
			{creating ? (
				<div className="space-y-5">
					<RpgButton
						secondary
						disabled={pending}
						onClick={() => setCreating(false)}
					>
						← Voltar ao catálogo
					</RpgButton>
					{createForm}
				</div>
			) : (
				<div className="space-y-5">
					<div className="grid gap-3 sm:grid-cols-[minmax(0,1fr)_auto] sm:items-end">
						<RpgInput
							label="Buscar no catálogo"
							value={query}
							onChange={onQueryChange}
							disabled={pending}
						/>
						<RpgButton
							secondary
							disabled={pending}
							onClick={() => setCreating(true)}
						>
							Criar homebrew
						</RpgButton>
					</div>
					{actionError ? (
						<p
							role="alert"
							className="border-l-2 border-(--danger) pl-3 text-sm"
						>
							{actionError.message}
						</p>
					) : null}
					{loading ? (
						<RpgSkeleton />
					) : error ? (
						<RpgErrorState error={error} retry={onRetry} />
					) : items.length === 0 ? (
						<div className="rounded-xl border border-dashed border-(--edge) p-6 text-sm">
							Nenhum resultado. Você pode criar este conteúdo como homebrew.
						</div>
					) : (
						<ul className="space-y-3">
							{items.map((item) => (
								<li
									key={item.id}
									className="rounded-xl border border-(--edge) bg-(--canvas) p-4"
								>
									<div className="flex flex-wrap items-start justify-between gap-4">
										<div className="min-w-0 flex-1 space-y-2">
											<div className="flex flex-wrap items-center gap-2">
												<p className="font-semibold">{item.name}</p>
												<span className="rounded-full border border-(--edge) px-2 py-0.5 text-[10px] uppercase tracking-wider opacity-70">
													{item.source.kind === "official"
														? "Oficial"
														: "Homebrew"}
												</span>
											</div>
											<div className="text-xs text-(--accent)">
												{renderMeta(item)}
											</div>
											<p className="text-sm leading-6 opacity-70">
												{item.description}
											</p>
										</div>
										<RpgButton disabled={pending} onClick={() => onAdd(item)}>
											Adicionar
										</RpgButton>
									</div>
									{renderActions && item.source.kind === "homebrew" ? (
										<div className="mt-3 flex flex-wrap gap-2 border-t border-(--edge) pt-3">
											{renderActions(item)}
										</div>
									) : null}
								</li>
							))}
						</ul>
					)}
				</div>
			)}
		</RpgModal>
	);
}
