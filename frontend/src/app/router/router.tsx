import {
	createRootRoute,
	createRoute,
	createRouter,
	Link,
	lazyRouteComponent,
	notFound,
	type RouteComponent,
	type RouterHistory,
} from "@tanstack/react-router";
import { AppShell } from "@/app/layout/AppShell";
import { RpgSkeleton } from "@/components/feedback/RemoteState";
import { HomePage } from "@/features/home/HomePage";
import { idSchema } from "@/shared/contracts/common";

const CampaignsPage = lazyRouteComponent(
	() => import("@/features/campaigns/CampaignsPage"),
	"CampaignsPage",
);
const CampaignEditorPage = lazyRouteComponent(
	() => import("@/features/campaigns/CampaignEditorPage"),
	"CampaignEditorPage",
);
const CampaignDetailPage = lazyRouteComponent(
	() => import("@/features/campaigns/CampaignDetailPage"),
	"CampaignDetailPage",
);
const CharactersPage = lazyRouteComponent(
	() => import("@/features/characters/CharactersPage"),
	"CharactersPage",
);
const CharacterEditorPage = lazyRouteComponent(
	() => import("@/features/characters/CharacterEditorPage"),
	"CharacterEditorPage",
);
const CharacterDetailPage = lazyRouteComponent(
	() => import("@/features/characters/CharacterDetailPage"),
	"CharacterDetailPage",
);
const SystemsPage = lazyRouteComponent(
	() => import("@/features/systems/SystemsPage"),
	"SystemsPage",
);
const SettingsPage = lazyRouteComponent(
	() => import("@/features/settings/SettingsPage"),
	"SettingsPage",
);
const ProfilePage = lazyRouteComponent(
	() => import("@/features/settings/ProfilePage"),
	"ProfilePage",
);
const AppearancePage = lazyRouteComponent(
	() => import("@/features/settings/AppearancePage"),
	"AppearancePage",
);

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
	return createRouter({
		routeTree,
		history,
		defaultPreload: "intent",
		defaultPendingComponent: RpgSkeleton,
		defaultPendingMs: 250,
		defaultPendingMinMs: 300,
	});
}
