import { useQuery } from "@tanstack/react-query";
import { Link } from "@tanstack/react-router";
import { useState } from "react";
import { RpgErrorState, RpgSkeleton } from "@/components/feedback/RemoteState";
import {
	RecentCampaigns,
	RecentCharacters,
} from "@/features/home/HomeRecentSections";
import { resolveTheme } from "@/features/themes/definitions";
import { queries } from "@/shared/api/queries";
import { readRecentAccess } from "@/shared/lib/recent-access";

export function HomePage() {
	const campaigns = useQuery(queries.campaigns);
	const characters = useQuery(queries.characters);
	const preferences = useQuery(queries.preferences);
	const systems = useQuery(queries.systems);
	const [recent] = useState(readRecentAccess);
	if (
		campaigns.isPending ||
		characters.isPending ||
		preferences.isPending ||
		systems.isPending
	)
		return <RpgSkeleton />;
	const error =
		campaigns.error ?? characters.error ?? preferences.error ?? systems.error;
	if (error)
		return (
			<RpgErrorState
				error={error}
				retry={() => {
					void campaigns.refetch();
					void characters.refetch();
					void preferences.refetch();
					void systems.refetch();
				}}
			/>
		);
	const theme = resolveTheme(preferences.data?.activeThemeId ?? null);
	const active = systems.data?.find(
		(system) => system.id === preferences.data?.activeSystemId,
	);
	const latestCampaigns = [...(campaigns.data ?? [])]
		.sort((a, b) => b.updatedAt.localeCompare(a.updatedAt))
		.slice(0, 3);
	const latestCharacters = [...(characters.data ?? [])]
		.sort((a, b) => b.updatedAt.localeCompare(a.updatedAt))
		.slice(0, 4);
	const resumable =
		recent &&
		(recent.kind === "campaigns" ? campaigns.data : characters.data)?.some(
			(item) => item.id === recent.id,
		);
	return (
		<>
			<header className="mb-8 border-b border-(--edge) pb-7">
				<p className="text-sm text-(--accent)">
					{active?.name ?? "Sistema não selecionado"}
				</p>
				<h2 className="mt-2 text-3xl font-semibold tracking-tight md:text-5xl">
					Sua mesa de jogo
				</h2>
				<p className="mt-3 max-w-xl text-sm leading-6 opacity-70">
					{latestCampaigns.length}{" "}
					{latestCampaigns.length === 1
						? "campanha recente"
						: "campanhas recentes"}{" "}
					e {latestCharacters.length}{" "}
					{latestCharacters.length === 1 ? "personagem" : "personagens"} à mão.
				</p>
			</header>

			<div className="mb-12 grid gap-5 lg:grid-cols-[minmax(0,1fr)_18rem]">
				<section
					className={
						theme.decoration +
						" flex min-h-64 flex-col justify-between gap-8 bg-(--panel) p-7 md:p-9"
					}
				>
					<div>
						<p className="text-sm opacity-65">
							{resumable ? "Último acesso" : "Comece por aqui"}
						</p>
						<h3 className="mt-3 max-w-2xl text-3xl font-semibold leading-tight tracking-tight md:text-4xl">
							{resumable && recent
								? recent.name
								: "Crie a primeira campanha da sua mesa"}
						</h3>
					</div>
					<Link
						to={
							resumable && recent
								? `/${recent.kind}/${recent.id}`
								: "/campaigns/new"
						}
						className="inline-flex min-h-11 w-fit items-center bg-(--accent) px-5 text-sm font-bold text-(--canvas) focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-(--accent) active:translate-y-px"
					>
						{resumable ? "Continuar" : "Criar campanha"}
					</Link>
				</section>

				<section
					aria-labelledby="quick-actions-title"
					className="border border-(--edge) p-6"
				>
					<h3 id="quick-actions-title" className="text-lg font-semibold">
						Criar algo novo
					</h3>
					<div className="mt-5 grid gap-3">
						<Link
							to="/campaigns/new"
							className="flex min-h-14 items-center justify-between border-b border-(--edge) py-3 hover:text-(--accent) focus-visible:outline-2 focus-visible:outline-(--accent)"
						>
							<span>Nova campanha</span>
							<span aria-hidden="true">→</span>
						</Link>
						<Link
							to="/characters/new"
							className="flex min-h-14 items-center justify-between border-b border-(--edge) py-3 hover:text-(--accent) focus-visible:outline-2 focus-visible:outline-(--accent)"
						>
							<span>Novo personagem</span>
							<span aria-hidden="true">→</span>
						</Link>
					</div>
					<Link
						to="/systems"
						className="mt-5 inline-flex min-h-11 items-center text-sm text-(--accent) underline underline-offset-4"
					>
						Trocar sistema
					</Link>
				</section>
			</div>

			<div className="grid gap-10 xl:grid-cols-[minmax(0,1.25fr)_minmax(18rem,0.75fr)]">
				<RecentCampaigns items={latestCampaigns} />
				<RecentCharacters items={latestCharacters} />
			</div>
		</>
	);
}
