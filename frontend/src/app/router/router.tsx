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
import { bestiaryIdSchema } from "@/shared/contracts/bestiary";

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
const BestiaryGalleryPage = lazyRouteComponent(
	() => import("@/features/bestiary/BestiaryGalleryPage"),
	"BestiaryGalleryPage",
);
const BestiaryDetailPage = lazyRouteComponent(
	() => import("@/features/bestiary/BestiaryDetailPage"),
	"BestiaryDetailPage",
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
const AdminHomePage = lazyRouteComponent(
	() => import("@/features/admin/AdminHomePage"),
	"AdminHomePage",
);
const ErrorAdminPage = lazyRouteComponent(
	() => import("@/features/admin/ErrorAdminPage"),
	"ErrorAdminPage",
);

const rootRoute = createRootRoute({
	component: AppShell,
	notFoundComponent: () => (
		<section className="grid min-h-[60dvh] place-items-center rounded-3xl border border-dashed border-(--edge) bg-(--surface)/50 p-8 text-center">
			<div>
				<p className="font-mono text-[10px] uppercase tracking-[0.22em] text-(--accent)">
					Registro / 404
				</p>
				<h2 className="mt-4 font-serif text-5xl">Página não encontrada</h2>
				<p className="mt-4 text-(--muted)">
					Este endereço não corresponde a um recurso válido.
				</p>
				<Link
					to="/"
					className="mt-7 inline-flex min-h-11 items-center rounded-full bg-(--accent) px-6 font-semibold text-(--on-accent)"
				>
					Voltar para o início
				</Link>
			</div>
		</section>
	),
	errorComponent: ({ reset }) => (
		<section
			role="alert"
			className="grid min-h-[60dvh] place-items-center rounded-3xl border border-(--edge) bg-(--surface) p-8 text-center"
		>
			<div>
				<p className="font-mono text-[10px] uppercase tracking-[0.22em] text-(--danger)">
					Interferência detectada
				</p>
				<h2 className="mt-4 font-serif text-5xl">
					Não foi possível abrir esta página
				</h2>
				<button
					type="button"
					onClick={reset}
					className="mt-7 min-h-11 rounded-full bg-(--accent) px-6 font-semibold text-(--on-accent)"
				>
					Tentar novamente
				</button>
			</div>
		</section>
	),
});
const paths = [
	"/",
	"/systems",
	"/settings",
	"/settings/profile",
	"/settings/appearance",
	"/admin",
	"/admin/errors",
	"/campaigns",
	"/campaigns/new",
	"/campaigns/$campaignId",
	"/characters",
	"/characters/new",
	"/characters/$characterId",
	"/characters/$characterId/edit",
	"/bestiary",
	"/bestiary/$threatId",
] as const;
const pages: Record<(typeof paths)[number], RouteComponent> = {
	"/": HomePage,
	"/systems": SystemsPage,
	"/settings": SettingsPage,
	"/settings/profile": ProfilePage,
	"/settings/appearance": AppearancePage,
	"/admin": AdminHomePage,
	"/admin/errors": ErrorAdminPage,
	"/campaigns": CampaignsPage,
	"/campaigns/new": CampaignEditorPage,
	"/campaigns/$campaignId": CampaignDetailPage,
	"/characters": CharactersPage,
	"/characters/new": CharacterEditorPage,
	"/characters/$characterId": CharacterDetailPage,
	"/characters/$characterId/edit": CharacterEditorPage,
	"/bestiary": BestiaryGalleryPage,
	"/bestiary/$threatId": BestiaryDetailPage,
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
				|| ("threatId" in params &&
					!bestiaryIdSchema.safeParse(params.threatId).success)
			)
				throw notFound();
		},
		validateSearch: (search: Record<string, unknown>) => ({
			q: typeof search.q === "string" ? search.q : "",
			systemId: typeof search.systemId === "string" ? search.systemId : "",
			campaignId:
				typeof search.campaignId === "string" ? search.campaignId : "",
			elementId: typeof search.elementId === "string" ? search.elementId : "",
			beingTypeId: typeof search.beingTypeId === "string" ? search.beingTypeId : "",
			sizeId: typeof search.sizeId === "string" ? search.sizeId : "",
			vdMin: typeof search.vdMin === "string" ? search.vdMin : "",
			vdMax: typeof search.vdMax === "string" ? search.vdMax : "",
			sort: search.sort === "vd-asc" || search.sort === "vd-desc" || search.sort === "relevance" ? search.sort : "name",
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
