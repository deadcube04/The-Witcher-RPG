import { Link } from "@tanstack/react-router";
import { PiArrowRightThin, PiPaletteThin, PiUserCircleThin } from "react-icons/pi";
import { ArchiveEyebrow } from "@/components/layout/ArchiveSurface";
import { PageHeader } from "@/components/navigation/PageHeader";

const preferences = [
	{ to: "/settings/profile", title: "Perfil", description: "Nome, identificação e avatar usados em todo o arquivo.", Icon: PiUserCircleThin, index: "01" },
	{ to: "/settings/appearance", title: "Aparência", description: "Tema global, atmosfera e comportamento da rail de navegação.", Icon: PiPaletteThin, index: "02" },
] as const;

export function SettingsPage() {
	return <><PageHeader eyebrow="05 / Preferências" title="O arquivo, do seu jeito" description="Ajuste sua identidade e a atmosfera sem alterar o conteúdo das histórias." />
		<section className="overflow-hidden rounded-2xl border border-(--edge)/60 bg-(--surface)"><div className="border-b border-(--edge)/60 px-6 py-4"><ArchiveEyebrow>Índice de preferências</ArchiveEyebrow></div><ul className="divide-y divide-(--edge)/60">{preferences.map(({ to, title, description, Icon, index }) => <li key={to}><Link to={to} className="group grid min-h-32 gap-4 p-6 hover:bg-white/3 focus-visible:outline-2 md:grid-cols-[3rem_3rem_minmax(0,1fr)_auto] md:items-center"><span className="font-mono text-xs text-(--muted)">{index}</span><Icon aria-hidden="true" className="size-8 text-(--accent)" /><span><span className="block font-serif text-3xl">{title}</span><span className="mt-2 block text-sm text-(--muted)">{description}</span></span><PiArrowRightThin aria-hidden="true" className="size-5 transition-transform duration-500 group-hover:translate-x-1" /></Link></li>)}</ul></section></>;
}
