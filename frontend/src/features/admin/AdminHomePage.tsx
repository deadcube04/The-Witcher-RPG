import { Link } from "@tanstack/react-router";
import { PiArrowRightThin, PiWarningCircleThin } from "react-icons/pi";
import { PageHeader } from "@/components/navigation/PageHeader";
import { AdminAccess } from "@/features/admin/AdminAccess";
import { ArchiveEyebrow } from "@/components/layout/ArchiveSurface";

export function AdminHomePage() {
	return (
		<AdminAccess>
			<PageHeader
				eyebrow="Administração"
				title="Ferramentas do NEXUS"
				description="Acompanhe a operação local e mantenha os dados técnicos da aplicação."
			/>
			<section className="max-w-3xl rounded-3xl border border-(--edge)/60 bg-(--surface)">
				<Link
					to="/admin/errors"
					className="group grid min-h-36 gap-5 p-6 hover:bg-(--surface-raised) focus-visible:outline-2 md:grid-cols-[3rem_minmax(0,1fr)_auto] md:items-center md:p-8"
				>
					<PiWarningCircleThin
						aria-hidden="true"
						className="size-10 text-(--danger)"
					/>
					<span>
						<ArchiveEyebrow>Observabilidade / 01</ArchiveEyebrow>
						<span className="mt-2 block font-serif text-3xl">
							Erros da aplicação
						</span>
						<span className="mt-2 block text-sm text-(--muted)">
							Investigue ocorrências, resolva grupos e ajuste os prazos de
							retenção.
						</span>
					</span>
					<PiArrowRightThin
						aria-hidden="true"
						className="size-6 transition-transform group-hover:translate-x-1"
					/>
				</Link>
			</section>
			<section className="mt-5 max-w-3xl rounded-[2rem] bg-(--edge)/35 p-1.5"><Link to="/admin/supplements" className="block rounded-[calc(2rem-0.375rem)] bg-(--surface) p-6 focus-visible:outline-2 focus-visible:outline-(--accent) md:p-8"><ArchiveEyebrow>Catálogo oficial</ArchiveEyebrow><span className="mt-2 block font-serif text-3xl">Pendências do suplemento</span><span className="mt-2 block text-sm text-(--muted)">Revise trechos incertos e corrija os dados oficiais com histórico.</span></Link></section>
		</AdminAccess>
	);
}
