import { Link } from '@tanstack/react-router'
import { GiDiceTwentyFacesTwenty, GiScrollUnfurled, GiHoodedFigure, GiSpellBook, GiCrossedSwords } from 'react-icons/gi'
import { LuSettings } from 'react-icons/lu'
import type { FocusEventHandler, MouseEventHandler } from 'react'
import { motion, useReducedMotion } from 'motion/react'

const navigation = [
  { to: '/', label: 'Início', Icon: GiDiceTwentyFacesTwenty },
  { to: '/campaigns', label: 'Campanhas', Icon: GiCrossedSwords },
  { to: '/characters', label: 'Fichas', Icon: GiScrollUnfurled },
  { to: '/systems', label: 'Sistemas', Icon: GiSpellBook },
  { to: '/settings', label: 'Configurações', Icon: LuSettings },
]
type Props = {
  collapsed: boolean; onMouseEnter: MouseEventHandler<HTMLElement>; onMouseLeave: MouseEventHandler<HTMLElement>; onFocus: FocusEventHandler<HTMLElement>; onBlur: FocusEventHandler<HTMLElement>
  systemName?: string; userName?: string; avatarUrl?: string | null
}
export function AppSidebar({ collapsed, onMouseEnter, onMouseLeave, onFocus, onBlur, systemName, userName, avatarUrl }: Props) {
  const reduced = useReducedMotion()
  return <motion.aside aria-label="Menu da aplicação" onMouseEnter={onMouseEnter} onMouseLeave={onMouseLeave} onFocus={onFocus} onBlur={onBlur}
    initial={false} animate={{ width: collapsed ? 72 : 248 }} transition={{ duration: reduced ? 0 : 0.22, ease: 'easeInOut' }}
    className="fixed inset-y-0 left-0 z-40 flex h-dvh flex-col overflow-hidden border-r border-(--edge) bg-(--panel) shadow-xl">
    <div className="flex min-h-24 items-center gap-3 border-b border-(--edge) px-3">
      <Link to="/" aria-label="RPG Manager — início" className="flex min-h-11 min-w-0 items-center gap-3 text-(--accent) focus-visible:outline-2">
        <GiDiceTwentyFacesTwenty aria-hidden="true" className="size-11 shrink-0" />
        <div className={collapsed ? 'sr-only' : ''}><h1 className="font-serif text-xl font-semibold text-(--ink)">RPG Manager</h1><p className="mt-1 text-[10px] uppercase tracking-[0.2em]">Arquivo de aventuras</p></div>
      </Link>
    </div>
    <nav id="main-navigation" aria-label="Navegação principal" className="min-h-0 flex-1 space-y-2 overflow-y-auto px-3 py-6">
      {navigation.map(({ to, label, Icon }) => <Link key={to} to={to} aria-label={label} title={collapsed ? label : undefined}
        activeOptions={{ exact: to === '/' }}
        className={'flex min-h-11 items-center gap-3 rounded-sm border border-transparent text-sm text-(--ink) hover:border-(--edge) hover:bg-(--canvas) focus-visible:outline-2 focus-visible:outline-(--accent) ' + (collapsed ? 'justify-center' : 'px-3')}
        activeProps={{ className: 'border-(--edge)! bg-(--canvas) font-semibold text-(--accent)!', 'aria-current': 'page' }}>
        <Icon aria-hidden="true" className="size-5 shrink-0" />{!collapsed && <span>{label}</span>}
      </Link>)}
    </nav>
    <div className="space-y-4 border-t border-(--edge) px-3 py-4">
      {!collapsed && <div className="px-3"><p className="text-[10px] uppercase tracking-[0.2em] opacity-60">Universo atual</p><p className="mt-2 text-sm text-(--accent)">{systemName ?? 'Selecionando universo…'}</p></div>}
      <Link to="/settings/profile" aria-label={userName ?? 'Seu perfil'} title={collapsed ? (userName ?? 'Seu perfil') : undefined}
        className={'flex min-h-11 items-center gap-3 rounded-sm text-sm hover:bg-(--canvas) focus-visible:outline-2 focus-visible:outline-(--accent) ' + (collapsed ? 'justify-center' : 'px-2')}>
        {avatarUrl ? <img src={avatarUrl} alt="" referrerPolicy="no-referrer" className="size-9 shrink-0 rounded-sm border border-(--edge) object-cover" />
          : <GiHoodedFigure aria-hidden="true" className="size-9 shrink-0 text-(--accent)" />}
        {!collapsed && <span className="truncate">{userName ?? 'Seu perfil'}</span>}
      </Link>
    </div>
  </motion.aside>
}
