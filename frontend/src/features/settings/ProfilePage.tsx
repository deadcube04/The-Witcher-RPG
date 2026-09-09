import { useQuery } from "@tanstack/react-query";
import {
	RpgErrorState,
	RpgSkeleton,
} from "../../components/feedback/RemoteState";
import { PageHeader } from "../../components/navigation/PageHeader";
import { queries } from "../../shared/api/queries";
import { ProfileForm } from "./ProfileForm";

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
			<div className="max-w-2xl">
				<ProfileForm user={user.data} />
			</div>
		</>
	);
}
