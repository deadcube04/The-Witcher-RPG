import { Link } from "@tanstack/react-router";
import { RpgCard } from "../../components/data-display/RpgCard";
import { PageHeader } from "../../components/navigation/PageHeader";

export function SettingsPage() {
	return (
		<>
			<PageHeader
				eyebrow="05 / Preferências"
				title="Do seu jeito"
				description="Cuide de sua identidade e da atmosfera das suas histórias."
			/>
			<div className="grid gap-5 md:grid-cols-2">
				<RpgCard>
					<h3 className="text-2xl">Perfil</h3>
					<p className="my-4 opacity-75">Nome, identificação e avatar.</p>
					<Link
						to="/settings/profile"
						className="inline-block py-3 text-(--accent) underline"
					>
						Editar perfil →
					</Link>
				</RpgCard>
				<RpgCard>
					<h3 className="text-2xl">Aparência</h3>
					<p className="my-4 opacity-75">
						Cinco formas de atravessar a membrana.
					</p>
					<Link
						to="/settings/appearance"
						className="inline-block py-3 text-(--accent) underline"
					>
						Escolher tema →
					</Link>
				</RpgCard>
			</div>
		</>
	);
}
