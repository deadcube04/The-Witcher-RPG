import { useQuery } from "@tanstack/react-query";
import { RpgErrorState, RpgSkeleton } from "@/components/feedback/RemoteState";
import { PageHeader } from "@/components/navigation/PageHeader";
import { queries } from "@/shared/api/queries";
import { ProfileForm } from "@/features/settings/ProfileForm";
import {
	ArchiveEyebrow,
	ArchivePanel,
} from "@/components/layout/ArchiveSurface";
import { PiUserCircleThin } from "react-icons/pi";
import { Link } from "@tanstack/react-router";

export function ProfilePage() {
	const user = useQuery(queries.user);
	if (user.isPending) return <RpgSkeleton />;
	if (user.isError)
		return (
			<RpgErrorState error={user.error} retry={() => void user.refetch()} />
		);
	return (
		<>
			<PageHeader
				eyebrow="Configurações / Perfil"
				title="Quem conta a história"
				description="Sua identidade nas histórias que você compartilha."
			/>
			<div className="grid gap-6 lg:grid-cols-[minmax(0,1fr)_20rem] lg:items-start">
				<ArchivePanel className="p-5 md:p-8">
					<ProfileForm user={user.data} />
				</ArchivePanel>
				<aside className="rounded-3xl border border-(--edge)/60 bg-(--surface-raised) p-7 lg:sticky lg:top-24">
					<ArchiveEyebrow>Seu perfil no NEXUS</ArchiveEyebrow>
					<div className="my-8 grid place-items-center">
						{user.data.avatarUrl ? (
							<img
								src={user.data.avatarUrl}
								alt=""
								className="size-36 rounded-full object-cover ring-1 ring-(--accent)"
							/>
						) : (
							<PiUserCircleThin
								aria-hidden="true"
								className="size-36 text-(--accent)"
							/>
						)}
					</div>
					<p className="font-serif text-3xl">{user.data.name}</p>
					<p className="mt-2 font-mono text-xs text-(--muted)">
						@{user.data.username}
					</p>
				</aside>
			</div>
			{user.data.role === "ADMIN" && (
				<section className="mt-8 rounded-3xl border border-(--edge)/60 bg-(--surface) p-6 md:p-8">
					<ArchiveEyebrow>Área restrita</ArchiveEyebrow>
					<h2 className="mt-3 font-serif text-3xl">Administração</h2>
					<p className="mt-2 max-w-2xl text-sm text-(--muted)">
						Acompanhe falhas registradas e mantenha as regras de retenção.
					</p>
					<Link
						to="/admin"
						className="mt-5 inline-flex min-h-11 items-center rounded-full bg-(--accent) px-6 font-semibold text-(--on-accent) focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-(--accent)"
					>
						Abrir administração
					</Link>
				</section>
			)}
		</>
	);
}
