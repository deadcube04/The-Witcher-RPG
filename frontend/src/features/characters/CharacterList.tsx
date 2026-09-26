import { Link } from "@tanstack/react-router";
import {
	PiArrowRightThin,
	PiPencilSimpleThin,
	PiUserCircleThin,
} from "react-icons/pi";
import {
	ArchiveEyebrow,
	ArrowMark,
	ArchivePanel,
} from "@/components/layout/ArchiveSurface";
import { RpgEmptyState } from "@/components/feedback/RemoteState";
import type { CharacterSheet } from "@/shared/contracts/character-sheet";
import type { RpgSystem } from "@/shared/contracts/rpg-system";
import { CharacterDeleteAction } from "@/features/characters/CharacterDeleteAction";

export function CharacterList({
	characters,
	systems,
}: {
	characters: CharacterSheet[];
	systems: RpgSystem[];
}) {
	if (!characters.length)
		return (
			<RpgEmptyState title="Nenhuma ficha encontrada">
				<p>Ajuste os filtros ou dê vida a um novo personagem.</p>
				<Link to="/characters/new" className="underline">
					Criar ficha
				</Link>
			</RpgEmptyState>
		);
	const [featured, ...remaining] = [...characters].sort((a, b) =>
		b.updatedAt.localeCompare(a.updatedAt),
	);
	const featuredSystem = systems.find((item) => item.id === featured.systemId);
	return (
		<div className="grid gap-6 xl:grid-cols-[minmax(18rem,0.7fr)_minmax(0,1.3fr)]">
			<ArchivePanel className="relative flex min-h-[34rem] flex-col overflow-hidden p-7 md:p-9">
				<div
					aria-hidden="true"
					className="absolute -right-20 -top-20 size-72 rounded-full bg-(--accent)/10 blur-3xl"
				/>
				<ArchiveEyebrow>Última ficha / {featuredSystem?.name}</ArchiveEyebrow>
				<div className="relative my-auto grid place-items-center">
					<div className="grid size-48 place-items-center rounded-full border border-(--accent)/40 bg-(--canvas)/70 shadow-[0_0_80px_color-mix(in_srgb,var(--accent)_14%,transparent)]">
						<PiUserCircleThin
							aria-hidden="true"
							className="size-28 text-(--accent)"
						/>
					</div>
				</div>
				<div className="relative">
					<h2 className="font-serif text-4xl leading-none tracking-[-0.04em]">
						{featured.name}
					</h2>
					<p className="mt-4 line-clamp-2 text-sm leading-6 text-(--muted)">
						{featured.description ||
							featured.background ||
							"Toda história precisa de alguém para vivê-la."}
					</p>
					<Link
						to={`/characters/${featured.id}`}
						className="group mt-7 inline-flex min-h-12 items-center gap-4 rounded-full bg-(--accent) px-6 font-semibold text-(--on-accent)"
					>
						Abrir ficha
						<ArrowMark />
					</Link>
				</div>
			</ArchivePanel>
			<section className="overflow-hidden rounded-2xl border border-(--edge)/60 bg-(--surface)">
				<div className="border-b border-(--edge)/60 px-5 py-4">
					<ArchiveEyebrow>Índice de personagens</ArchiveEyebrow>
				</div>
				{remaining.length === 0 ? (
					<p className="p-8 text-sm text-(--muted)">
						Nenhuma outra ficha registrada.
					</p>
				) : (
					<ul className="divide-y divide-(--edge)/60">
						{remaining.map((sheet, index) => (
							<li
								key={sheet.id}
								className="group grid gap-4 px-5 py-5 hover:bg-(--surface-raised) sm:grid-cols-[3rem_minmax(0,1fr)_auto] sm:items-center"
							>
								<span className="font-mono text-xs text-(--muted)">
									{String(index + 2).padStart(2, "0")}
								</span>
								<Link
									to={`/characters/${sheet.id}`}
									className="min-w-0 focus-visible:outline-2"
								>
									<span className="block truncate text-lg group-hover:text-(--accent)">
										{sheet.name}
									</span>
									<span className="mt-1 block font-mono text-[10px] uppercase tracking-wider text-(--muted)">
										{systems.find((item) => item.id === sheet.systemId)?.name} ·{" "}
										{sheet.campaignId ? "Em campanha" : "Standalone"}
									</span>
								</Link>
								<div className="flex items-center gap-2">
									<Link
										to={`/characters/${sheet.id}/edit`}
										aria-label={`Editar ${sheet.name}`}
										className="grid size-11 place-items-center rounded-full border border-(--edge)"
									>
										<PiPencilSimpleThin />
									</Link>
									<CharacterDeleteAction character={sheet} />
									<PiArrowRightThin
										aria-hidden="true"
										className="hidden sm:block"
									/>
								</div>
							</li>
						))}
					</ul>
				)}
			</section>
		</div>
	);
}
