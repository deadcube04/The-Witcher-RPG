import { useQuery } from "@tanstack/react-query";
import {
	RpgErrorState,
	RpgSkeleton,
} from "../../components/feedback/RemoteState";
import { PageHeader } from "../../components/navigation/PageHeader";
import { queries } from "../../shared/api/queries";
import { ProfileForm } from "./ProfileForm";
import { ArchiveEyebrow, ArchivePanel } from "@/components/layout/ArchiveSurface";
import { PiUserCircleThin } from "react-icons/pi";

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
				description="Sua identidade neste arquivo de aventuras."
			/>
			<div className="grid gap-6 lg:grid-cols-[minmax(0,1fr)_20rem] lg:items-start">
				<ArchivePanel className="p-5 md:p-8"><ProfileForm user={user.data} /></ArchivePanel>
				<aside className="rounded-3xl border border-(--edge)/60 bg-(--surface-raised) p-7 lg:sticky lg:top-24"><ArchiveEyebrow>Identidade no arquivo</ArchiveEyebrow><div className="my-8 grid place-items-center">{user.data.avatarUrl ? <img src={user.data.avatarUrl} alt="" className="size-36 rounded-full object-cover ring-1 ring-(--accent)" /> : <PiUserCircleThin aria-hidden="true" className="size-36 text-(--accent)" />}</div><p className="font-serif text-3xl">{user.data.name}</p><p className="mt-2 font-mono text-xs text-(--muted)">@{user.data.username}</p></aside>
			</div>
		</>
	);
}
