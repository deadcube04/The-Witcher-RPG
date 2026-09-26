import { useQuery } from "@tanstack/react-query";
import { Outlet, useRouterState } from "@tanstack/react-router";
import { useState } from "react";
import { AnimatedPage } from "@/components/motion/AnimatedPage";
import { RpgVisualProvider } from "@/components/primitives/RpgVisualProvider";
import { resolveTheme } from "@/features/themes/definitions";
import { queries } from "@/shared/api/queries";
import { AppSidebar } from "@/app/layout/AppSidebar";

import { useColorMode } from "@/features/themes/useColorMode";

const pageContext = [
	[/^\/$/, ["NEXUS", "Início"]],
	[/^\/campaigns\/new/, ["Campanhas", "Nova campanha"]],
	[/^\/campaigns\/[^/]+\/edit/, ["Campanhas", "Editar campanha"]],
	[/^\/campaigns\/[^/]+/, ["Campanhas", "Detalhes"]],
	[/^\/campaigns/, ["NEXUS", "Campanhas"]],
	[/^\/characters\/new/, ["Fichas", "Novo personagem"]],
	[/^\/characters\/[^/]+\/edit/, ["Fichas", "Editar personagem"]],
	[/^\/characters\/[^/]+/, ["Fichas", "Personagem"]],
	[/^\/characters/, ["NEXUS", "Fichas"]],
	[/^\/systems/, ["NEXUS", "Universos"]],
	[/^\/settings/, ["NEXUS", "Preferências"]],
	[/^\/admin\/errors/, ["Administração", "Erros da aplicação"]],
	[/^\/admin/, ["Administração", "Painel"]],
] as const;

export function AppShell() {
	const [sidebarHovered, setSidebarHovered] = useState(false);
	const [sidebarFocused, setSidebarFocused] = useState(false);
	const preferences = useQuery(queries.preferences);
	const systems = useQuery(queries.systems);
	const user = useQuery(queries.user);
	const pathname = useRouterState({
		select: (state) => state.location.pathname,
	});
	const isCharacterSheet =
		/^\/characters\/[^/]+\/?$/.test(pathname) && pathname !== "/characters/new";
	const sidebarMode = preferences.data?.sidebarMode ?? "collapsed";
	const collapsed =
		sidebarMode === "always-collapsed" ||
		(sidebarMode === "collapsed" && !sidebarHovered && !sidebarFocused);
	const colorMode = useColorMode(preferences.data?.colorMode ?? "system");
	const theme = resolveTheme(
		preferences.data?.activeThemeId ?? null,
		colorMode,
	);
	const activeSystem = systems.data?.find(
		(system) => system.id === preferences.data?.activeSystemId,
	);
	const [section, page] = pageContext.find(([pattern]) =>
		pattern.test(pathname),
	)?.[1] ?? ["NEXUS", "Página"];
	if (!preferences.data)
		return (
			<div className="grid min-h-dvh place-items-center bg-[#0f1117] p-6 text-[#c9cdd6]">
				{preferences.isError ? (
					<div role="alert">
						<p>Não foi possível carregar sua aparência.</p>
						<button
							type="button"
							className="mt-4 underline focus-visible:outline-2"
							onClick={() => void preferences.refetch()}
						>
							Tentar novamente
						</button>
					</div>
				) : (
					<p role="status">Carregando NEXUS…</p>
				)}
			</div>
		);
	return (
		<div
			data-theme={theme.id}
			data-color-mode={theme.mode ?? "dark"}
			className={
				theme.classes +
				" min-h-[100dvh] max-h-[100dvh] overflow-y-auto bg-(--canvas) font-sans text-(--ink) selection:bg-(--accent) selection:text-(--on-accent)"
			}
		>
			<RpgVisualProvider theme={theme}>
				<a
					href="#main-content"
					className="sr-only focus:not-sr-only focus:fixed focus:left-4 focus:top-4 focus:z-50 focus:bg-(--accent) focus:p-3 focus:text-(--on-accent)"
				>
					Pular para conteúdo
				</a>
				<div className="min-h-[100dvh] before:pointer-events-none before:fixed before:inset-0 before:z-30 before:bg-[radial-gradient(circle_at_20%_0%,color-mix(in_srgb,var(--accent)_6%,transparent),transparent_30%)]">
					<AppSidebar
						collapsed={collapsed}
						onMouseEnter={() => setSidebarHovered(true)}
						onMouseLeave={() => setSidebarHovered(false)}
						onFocus={() => setSidebarFocused(true)}
						onBlur={(event) => {
							if (
								!event.currentTarget.contains(
									event.relatedTarget instanceof Node
										? event.relatedTarget
										: null,
								)
							)
								setSidebarFocused(false);
						}}
						systemName={activeSystem?.name}
						userName={user.data?.name}
						avatarUrl={user.data?.avatarUrl}
					/>
					<header className="sticky top-0 z-20 border-b border-(--edge)/50 bg-(--canvas)/92 px-4 py-3 md:ml-24 md:px-8 lg:px-12">
						<div className="mx-auto flex max-w-[1480px] items-center justify-between gap-4">
							<div className="flex min-w-0 items-center gap-3 font-mono text-[10px] uppercase tracking-[0.2em]">
								<span className="text-(--muted)">{section}</span>
								<span aria-hidden="true" className="text-(--edge)">
									/
								</span>
								<span className="truncate text-(--accent)">{page}</span>
							</div>
							<span className="truncate text-xs text-(--muted)">
								{activeSystem?.name ?? "Universo não selecionado"}
							</span>
						</div>
					</header>
					<main
						id="main-content"
						tabIndex={-1}
						className={
							"relative z-10 min-w-0 pb-24 outline-none md:ml-24 md:pb-10 " +
							(isCharacterSheet
								? "px-4 pt-4 md:px-6 "
								: "px-4 py-8 md:px-8 lg:py-12 xl:px-12 ") +
							(collapsed ? "" : "md:ml-64")
						}
					>
						{(preferences.isError || systems.isError || user.isError) && (
							<p role="alert" className="mb-6 border border-(--edge) p-4">
								Não foi possível carregar seu contexto.{" "}
								<button
									type="button"
									className="underline"
									onClick={() => {
										void preferences.refetch();
										void systems.refetch();
										void user.refetch();
									}}
								>
									Tentar novamente
								</button>
							</p>
						)}
						<AnimatedPage
							key={pathname}
							duration={theme.duration}
							offset={theme.offset}
						>
							<Outlet />
						</AnimatedPage>
					</main>
				</div>
			</RpgVisualProvider>
		</div>
	);
}
