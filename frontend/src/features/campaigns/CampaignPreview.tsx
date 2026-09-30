import { ArchiveEyebrow, MediaFrame } from "@/components/layout/ArchiveSurface";
import type { RpgSystem } from "@/shared/contracts/rpg-system";
import { systemArt } from "@/shared/lib/system-art";

export function CampaignPreview({ name, description, system, coverUrl }: {
	name: string; description: string; system?: RpgSystem; coverUrl: string;
}) {
	return <MediaFrame src={coverUrl || systemArt(system?.slug)} alt="Prévia da capa da campanha" className="min-h-64">
		<div className="flex min-h-64 flex-col justify-between p-6">
			<ArchiveEyebrow>{system?.name ?? "Escolha um sistema"} / Prévia da campanha</ArchiveEyebrow>
			<div>
				<h2 className="font-serif text-3xl leading-none text-white">{name.trim() || "Uma história sem título"}</h2>
				<p className="mt-3 line-clamp-2 text-sm leading-6 text-white/80">{description.trim() || "Uma história ainda por escrever."}</p>
			</div>
		</div>
	</MediaFrame>;
}
