import {
	createRootRoute,
	createRoute,
	createRouter,
	Link,
	notFound,
	type RouteComponent,
	type RouterHistory,
} from "@tanstack/react-router";
import { CampaignDetailPage } from "../../features/campaigns/CampaignDetailPage";
import { CampaignEditorPage } from "../../features/campaigns/CampaignEditorPage";
import { CampaignsPage } from "../../features/campaigns/CampaignsPage";
import { CharacterDetailPage } from "../../features/characters/CharacterDetailPage";
import { CharacterEditorPage } from "../../features/characters/CharacterEditorPage";
import { CharactersPage } from "../../features/characters/CharactersPage";
import { HomePage } from "../../features/home/HomePage";
import { AppearancePage } from "../../features/settings/AppearancePage";
import { ProfilePage } from "../../features/settings/ProfilePage";
import { SettingsPage } from "../../features/settings/SettingsPage";
import { SystemsPage } from "../../features/systems/SystemsPage";
import { idSchema } from "../../shared/contracts/common";
import { AppShell } from "../layout/AppShell";

const rootRoute = createRootRoute({
	component: AppShell,
	notFoundComponent: () => (
		<section className="space-y-5">
			<h2 className="text-3xl">Página não encontrada</h2>
			<p>Este endereço não corresponde a um recurso válido.</p>
			<Link to="/" className="inline-block py-3 text-(--accent) underline">
				Voltar para o início
			</Link>
		</section>
	),
	errorComponent: ({ reset }) => (
		<section role="alert" className="space-y-5">
			<h2 className="text-3xl">Não foi possível abrir esta página</h2>
			<button type="button" onClick={reset} className="underline">
				Tentar novamente
			</button>
		</section>
	),
});
const paths = [
	"/",
	"/systems",
	"/settings",
	"/settings/profile",
	"/settings/appearance",
	"/campaigns",
	"/campaigns/new",
	"/campaigns/$campaignId",
	"/campaigns/$campaignId/edit",
	"/characters",
	"/characters/new",
	"/characters/$characterId",
	"/characters/$characterId/edit",
] as const;
const pages: Record<(typeof paths)[number], RouteComponent> = {
	"/": HomePage,
	"/systems": SystemsPage,
	"/settings": SettingsPage,
	"/settings/profile": ProfilePage,
	"/settings/appearance": AppearancePage,
	"/campaigns": CampaignsPage,
	"/campaigns/new": CampaignEditorPage,
	"/campaigns/$campaignId": CampaignDetailPage,
	"/campaigns/$campaignId/edit": CampaignEditorPage,
	"/characters": CharactersPage,
	"/characters/new": CharacterEditorPage,
	"/characters/$characterId": CharacterDetailPage,
	"/characters/$characterId/edit": CharacterEditorPage,
};

const routes = paths.map((path) =>
	createRoute({
		getParentRoute: () => rootRoute,
		path,
		component: pages[path],
		beforeLoad: ({ params }) => {
			if (
				("campaignId" in params &&
					!idSchema.safeParse(params.campaignId).success) ||
				("characterId" in params &&
					!idSchema.safeParse(params.characterId).success)
			)
				throw notFound();
		},
		validateSearch: (search: Record<string, unknown>) => ({
			q: typeof search.q === "string" ? search.q : "",
			systemId: typeof search.systemId === "string" ? search.systemId : "",
			campaignId:
				typeof search.campaignId === "string" ? search.campaignId : "",
		}),
	}),
);
const routeTree = rootRoute.addChildren(routes);
export function createAppRouter(history?: RouterHistory) {
	return createRouter({ routeTree, history, defaultPreload: "intent" });
}
