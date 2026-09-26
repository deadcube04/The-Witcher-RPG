import { Link } from "@tanstack/react-router";
import { PiArrowRightThin, PiPencilSimpleThin } from "react-icons/pi";
import {
	ArchiveEyebrow,
	ArrowMark,
	MediaFrame,
} from "@/components/layout/ArchiveSurface";
import { RpgEmptyState } from "@/components/feedback/RemoteState";
import type { Campaign } from "@/shared/contracts/campaign";
import type { RpgSystem } from "@/shared/contracts/rpg-system";
import { systemArt } from "@/shared/lib/system-art";
import { CampaignDeleteAction } from "@/features/campaigns/CampaignDeleteAction";

export function CampaignList({
	campaigns,
	systems,
}: {
	campaigns: Campaign[];
	systems: RpgSystem[];
}) {
	if (!campaigns.length)
		return (
			<RpgEmptyState title="Nenhuma campanha encontrada">
				<p>Ajuste os filtros ou comece uma nova história.</p>
				<Link to="/campaigns/new" className="underline">
					Criar campanha
				</Link>
			</RpgEmptyState>
		);
	const [featured, ...remaining] = [...campaigns].sort((a, b) =>
		b.updatedAt.localeCompare(a.updatedAt),
	);
	const featuredSystem = systems.find((item) => item.id === featured.systemId);
	return (
		<div className="space-y-6">
			<MediaFrame
				src={systemArt(featuredSystem?.slug)}
				alt="Ilustração do sistema da campanha"
				className="min-h-[25rem]"
			>
				<div className="flex min-h-[25rem] max-w-3xl flex-col justify-between p-6 md:p-10">
					<ArchiveEyebrow>
						{featuredSystem?.name ?? "Sistema indisponível"} /{" "}
						{featured.status === "active" ? "Em andamento" : "Arquivada"}
					</ArchiveEyebrow>
					<div>
						<h2 className="font-serif text-4xl leading-none tracking-[-0.04em] text-white md:text-5xl">
							{featured.name}
						</h2>
						<p className="mt-4 line-clamp-2 max-w-xl text-sm leading-7 text-white/70">
							{featured.description || "Uma história ainda por escrever."}
						</p>
						<Link
							to={`/campaigns/${featured.id}`}
							className="group mt-7 inline-flex min-h-12 items-center gap-4 rounded-full bg-(--accent) px-6 font-semibold text-(--on-accent)"
						>
							Abrir campanha
							<ArrowMark />
						</Link>
					</div>
				</div>
			</MediaFrame>
			{remaining.length > 0 && (
				<section
					aria-label="Outras campanhas"
					className="overflow-hidden rounded-2xl border border-(--edge)/60 bg-(--surface)"
				>
					<div className="border-b border-(--edge)/60 px-5 py-4">
						<ArchiveEyebrow>Índice de campanhas</ArchiveEyebrow>
					</div>
					<ul className="divide-y divide-(--edge)/60">
						{remaining.map((campaign, index) => {
							const system = systems.find(
								(item) => item.id === campaign.systemId,
							);
							return (
								<li
									key={campaign.id}
									className="group grid gap-4 px-5 py-5 transition-colors duration-500 hover:bg-(--surface-raised) md:grid-cols-[3rem_minmax(0,1fr)_auto] md:items-center"
								>
									<span className="font-mono text-xs text-(--muted)">
										{String(index + 2).padStart(2, "0")}
									</span>
									<Link
										to={`/campaigns/${campaign.id}`}
										className="min-w-0 focus-visible:outline-2"
									>
										<span className="block truncate text-lg font-medium group-hover:text-(--accent)">
											{campaign.name}
										</span>
										<span className="mt-1 block font-mono text-[10px] uppercase tracking-wider text-(--muted)">
											{system?.name} ·{" "}
											{campaign.status === "active"
												? "Em andamento"
												: "Arquivada"}
										</span>
									</Link>
									<div className="flex items-center gap-2">
										<Link
											to={`/campaigns/${campaign.id}/edit`}
											aria-label={`Editar ${campaign.name}`}
											className="grid size-11 place-items-center rounded-full border border-(--edge) hover:text-(--accent)"
										>
											<PiPencilSimpleThin />
										</Link>
										<CampaignDeleteAction campaign={campaign} />
										<PiArrowRightThin
											aria-hidden="true"
											className="hidden size-5 text-(--muted) md:block"
										/>
									</div>
								</li>
							);
						})}
					</ul>
				</section>
			)}
		</div>
	);
}
