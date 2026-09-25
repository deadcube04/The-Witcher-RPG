import { Link } from "@tanstack/react-router";
import type { FocusEventHandler, MouseEventHandler } from "react";
import {
	PiArchiveThin,
	PiBooksThin,
	PiGearThin,
	PiHouseLineThin,
	PiScrollThin,
	PiSwordThin,
	PiUserCircleThin,
} from "react-icons/pi";

const navigation = [
	{ to: "/", label: "Início", Icon: PiHouseLineThin },
	{ to: "/campaigns", label: "Campanhas", Icon: PiSwordThin },
	{ to: "/characters", label: "Fichas", Icon: PiScrollThin },
	{ to: "/systems", label: "Sistemas", Icon: PiBooksThin },
	{ to: "/settings", label: "Configurações", Icon: PiGearThin },
] as const;

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

function NavigationLink({ to, label, Icon, collapsed }: (typeof navigation)[number] & { collapsed: boolean }) {
	return (
		<Link
			to={to}
			aria-label={label}
			title={collapsed ? label : undefined}
			activeOptions={{ exact: to === "/" }}
			className={`group flex min-h-12 items-center gap-3 rounded-2xl text-sm text-(--muted) transition-[color,background-color,transform] duration-500 ease-[cubic-bezier(0.32,0.72,0,1)] hover:bg-white/5 hover:text-(--ink) active:scale-[0.98] focus-visible:outline-2 focus-visible:outline-(--accent) ${collapsed ? "justify-center" : "px-3"}`}
			activeProps={{ className: "bg-(--accent)! text-(--canvas)! shadow-[0_10px_30px_color-mix(in_srgb,var(--accent)_22%,transparent)]", "aria-current": "page" }}
		>
			<Icon aria-hidden="true" className="size-5 shrink-0" />
			{!collapsed && <span className="truncate">{label}</span>}
		</Link>
	);
}

export function AppSidebar({ collapsed, onMouseEnter, onMouseLeave, onFocus, onBlur, systemName, userName, avatarUrl }: Props) {
	return (
		<>
			<aside
				aria-label="Menu da aplicação"
				onMouseEnter={onMouseEnter}
				onMouseLeave={onMouseLeave}
				onFocus={onFocus}
				onBlur={onBlur}
				className={`fixed inset-y-4 left-4 z-40 hidden flex-col overflow-hidden rounded-3xl border border-white/8 bg-(--surface)/96 p-2 shadow-[0_24px_80px_var(--shadow)] md:flex ${collapsed ? "w-[76px]" : "w-[248px]"}`}
			>
				<Link to="/" aria-label="RPG Manager — início" className={`flex min-h-15 items-center gap-3 rounded-2xl px-3 text-(--accent) focus-visible:outline-2 ${collapsed ? "justify-center px-0" : ""}`}>
					<PiArchiveThin aria-hidden="true" className="size-7 shrink-0" />
					{!collapsed && <div className="min-w-0"><p className="truncate font-serif text-xl text-(--ink)">RPG Manager</p><p className="mt-0.5 truncate font-mono text-[9px] uppercase tracking-[0.2em] text-(--muted)">Arquivo de aventuras</p></div>}
				</Link>
				<nav className="mt-6 min-h-0 flex-1 space-y-2 overflow-y-auto">
					{navigation.map((item) => <NavigationLink key={item.to} {...item} collapsed={collapsed} />)}
				</nav>
				<div className="space-y-2 border-t border-(--edge)/60 pt-3">
					{!collapsed && <p className="px-3 py-2 font-mono text-[9px] uppercase tracking-[0.2em] text-(--muted)">{systemName ?? "Selecionando universo…"}</p>}
					<Link to="/settings/profile" aria-label={userName ?? "Seu perfil"} className={`flex min-h-12 items-center gap-3 rounded-2xl text-sm hover:bg-white/5 focus-visible:outline-2 ${collapsed ? "justify-center" : "px-2"}`}>
						{avatarUrl ? <img src={avatarUrl} alt="" referrerPolicy="no-referrer" className="size-9 rounded-xl object-cover ring-1 ring-(--edge)" /> : <PiUserCircleThin aria-hidden="true" className="size-8 text-(--accent)" />}
						{!collapsed && <span className="truncate">{userName ?? "Seu perfil"}</span>}
					</Link>
				</div>
			</aside>

			<nav aria-label="Navegação principal" className="fixed inset-x-3 bottom-3 z-40 grid grid-cols-5 rounded-2xl border border-white/10 bg-(--surface)/96 p-1.5 shadow-[0_20px_60px_var(--shadow)] md:hidden">
				{navigation.map(({ to, label, Icon }) => (
					<Link key={to} to={to} aria-label={label} activeOptions={{ exact: to === "/" }} className="grid min-h-12 place-items-center rounded-xl text-(--muted) focus-visible:outline-2" activeProps={{ className: "bg-(--accent)! text-(--canvas)!", "aria-current": "page" }}>
						<Icon aria-hidden="true" className="size-5" />
					</Link>
				))}
			</nav>
		</>
	);
}
