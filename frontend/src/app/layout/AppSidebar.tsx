import { Link, useRouterState } from "@tanstack/react-router";
import { motion, useReducedMotion } from "motion/react";
import type { FocusEventHandler, MouseEventHandler } from "react";
import {
	PiBooksThin,
	PiGearThin,
	PiHouseLineThin,
	PiScrollThin,
	PiSwordThin,
	PiUserCircleThin,
} from "react-icons/pi";

import { NexusBrand } from "@/components/brand/NexusBrand";

const navigation = [
	{ to: "/", label: "Início", Icon: PiHouseLineThin },
	{ to: "/campaigns", label: "Campanhas", Icon: PiSwordThin },
	{ to: "/characters", label: "Fichas", Icon: PiScrollThin },
	{ to: "/systems", label: "Sistemas", Icon: PiBooksThin },
	{ to: "/settings", label: "Configurações", Icon: PiGearThin },
] as const;

function isNavigationItemActive(
	to: (typeof navigation)[number]["to"],
	currentPath: string,
): boolean {
	return to === "/"
		? currentPath === "/"
		: currentPath === to || currentPath.startsWith(`${to}/`);
}

type Props = {
	collapsed: boolean;
	onMouseEnter: MouseEventHandler<HTMLElement>;
	onMouseLeave: MouseEventHandler<HTMLElement>;
	onFocus: FocusEventHandler<HTMLElement>;
	onBlur: FocusEventHandler<HTMLElement>;
	systemName?: string;
	userName?: string;
	avatarUrl?: string | null;
};

function NavigationLink({
	to,
	label,
	Icon,
	collapsed,
	currentPath,
}: (typeof navigation)[number] & { collapsed: boolean; currentPath: string }) {
	const isActive = isNavigationItemActive(to, currentPath);
	return (
		<Link
			to={to}
			aria-label={label}
			aria-current={isActive ? "page" : undefined}
			title={collapsed ? label : undefined}
			className={`group flex min-h-12 items-center gap-3 rounded-2xl text-sm focus-visible:outline-2 focus-visible:outline-(--accent) ${collapsed ? "justify-center" : "px-3"} ${isActive ? "bg-(--accent) text-(--on-accent) shadow-[0_10px_30px_color-mix(in_srgb,var(--accent)_22%,transparent)]" : "text-(--muted) hover:bg-(--surface-raised) hover:text-(--ink)"}`}
		>
			<Icon aria-hidden="true" className="size-5 shrink-0" />
			{!collapsed && <span className="truncate">{label}</span>}
		</Link>
	);
}

export function AppSidebar({
	collapsed,
	onMouseEnter,
	onMouseLeave,
	onFocus,
	onBlur,
	systemName,
	userName,
	avatarUrl,
}: Props) {
	const reducedMotion = useReducedMotion();
	const currentPath = useRouterState({
		select: (state) => state.location.pathname,
	});
	return (
		<>
			<motion.aside
				initial={false}
				animate={{ width: collapsed ? 76 : 248 }}
				transition={{
					duration: reducedMotion ? 0 : 0.22,
					ease: [0.32, 0.72, 0, 1],
				}}
				aria-label="Menu da aplicação"
				onMouseEnter={onMouseEnter}
				onMouseLeave={onMouseLeave}
				onFocus={onFocus}
				onBlur={onBlur}
				className="fixed inset-y-4 left-4 z-40 hidden flex-col overflow-hidden rounded-3xl border border-(--edge)/60 bg-(--surface)/96 p-2 shadow-[0_24px_80px_var(--shadow)] md:flex"
			>
				<Link
					to="/"
					aria-label="NEXUS - início"
					className={`flex min-h-15 items-center gap-3 rounded-2xl px-3 text-(--accent) focus-visible:outline-2 ${collapsed ? "justify-center px-0" : ""}`}
				>
					<NexusBrand compact={collapsed} />
				</Link>
				<nav className="mt-6 min-h-0 flex-1 space-y-2 overflow-y-auto">
					{navigation.map((item) => (
						<NavigationLink
							key={item.to}
							{...item}
							collapsed={collapsed}
							currentPath={currentPath}
						/>
					))}
				</nav>
				<div className="space-y-2 border-t border-(--edge)/60 pt-3">
					{!collapsed && (
						<p className="px-3 py-2 font-mono text-[9px] uppercase tracking-[0.2em] text-(--muted)">
							{systemName ?? "Selecionando universo…"}
						</p>
					)}
					<Link
						to="/settings/profile"
						aria-label={userName ?? "Seu perfil"}
						className={`flex min-h-12 items-center gap-3 rounded-2xl text-sm hover:bg-(--surface-raised) focus-visible:outline-2 ${collapsed ? "justify-center" : "px-2"}`}
					>
						{avatarUrl ? (
							<img
								src={avatarUrl}
								alt=""
								referrerPolicy="no-referrer"
								className="size-9 rounded-xl object-cover ring-1 ring-(--edge)"
							/>
						) : (
							<PiUserCircleThin
								aria-hidden="true"
								className="size-8 text-(--accent)"
							/>
						)}
						{!collapsed && (
							<span className="truncate">{userName ?? "Seu perfil"}</span>
						)}
					</Link>
				</div>
			</motion.aside>

			<nav
				aria-label="Navegação principal"
				className="fixed inset-x-3 bottom-3 z-40 grid grid-cols-5 rounded-2xl border border-(--edge)/60 bg-(--surface)/96 p-1.5 shadow-[0_20px_60px_var(--shadow)] md:hidden"
			>
				{navigation.map(({ to, label, Icon }) => (
					<Link
						key={to}
						to={to}
						aria-label={label}
						aria-current={
							isNavigationItemActive(to, currentPath) ? "page" : undefined
						}
						className={`grid min-h-12 place-items-center rounded-xl focus-visible:outline-2 ${isNavigationItemActive(to, currentPath) ? "bg-(--accent) text-(--on-accent)" : "text-(--muted)"}`}
					>
						<Icon aria-hidden="true" className="size-5" />
					</Link>
				))}
			</nav>
		</>
	);
}
