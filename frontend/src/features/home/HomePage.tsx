import { useQuery } from "@tanstack/react-query";
import { Link } from "@tanstack/react-router";
import { useState } from "react";
import { ResourceLinks } from "../../components/data-display/ResourceLinks";
import {
	RpgErrorState,
	RpgSkeleton,
} from "../../components/feedback/RemoteState";
import { PageHeader } from "../../components/navigation/PageHeader";
import { queries } from "../../shared/api/queries";
import { readRecentAccess } from "../../shared/lib/recent-access";
import { resolveTheme } from "../themes/definitions";

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
			<PageHeader
				eyebrow="01 / Seu arquivo de histórias"
				title="Seu próximo capítulo"
				description="Retome uma investigação, dê vida a um personagem ou comece algo que ainda não tem nome."
			/>
			<section
				className={
					theme.decoration +
					" relative mb-10 flex min-h-72 flex-col justify-between gap-8 bg-(--panel) p-7 md:p-10"
				}
			>
				<div className="flex justify-between font-mono text-xs uppercase tracking-widest">
					<span>{active?.name}</span>
					<span aria-hidden="true">{theme.mark}</span>
				</div>
				<div className="max-w-lg">
					<p className="mb-5 text-3xl leading-tight md:text-5xl">
						Há histórias esperando
						<br />
						por você.
					</p>
					<div className="flex flex-wrap gap-3">
						<Link
							to="/campaigns/new"
							className="inline-flex min-h-11 items-center bg-(--accent) px-5 font-sans text-sm font-bold text-(--canvas)"
						>
							Nova campanha ↗
						</Link>
						<Link
							to="/characters/new"
							className="inline-flex min-h-11 items-center border border-(--edge) px-5 font-sans text-sm"
						>
							Criar ficha
						</Link>
					</div>
				</div>
			</section>
			{resumable && recent && (
				<p className="mb-8 border-l-2 border-(--accent) pl-4 text-sm">
					Continuar de onde parou:{" "}
					<Link to={`/${recent.kind}/${recent.id}`} className="underline">
						{recent.name}
					</Link>
				</p>
			)}
			<div className="grid gap-10 xl:grid-cols-[1.2fr_1fr]">
				<section>
					<div className="flex justify-between gap-3">
						<h3 className="text-xl">Campanhas recentes</h3>
						<Link to="/campaigns" className="text-sm text-(--accent) underline">
							Ver todas
						</Link>
					</div>
					<ResourceLinks items={latestCampaigns} kind="campaigns" />
				</section>
				<section>
					<div className="flex justify-between gap-3">
						<h3 className="text-xl">Seus personagens</h3>
						<Link
							to="/characters"
							className="text-sm text-(--accent) underline"
						>
							Ver todos
						</Link>
					</div>
					<ResourceLinks items={latestCharacters} kind="characters" />
				</section>
			</div>
			<Link
				to="/systems"
				className="mt-8 inline-block min-h-11 py-3 text-sm text-(--accent) underline"
			>
				Explorar outros sistemas →
			</Link>
		</>
	);
}
