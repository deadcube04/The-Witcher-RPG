import { Outlet, useRouterState } from '@tanstack/react-router'
import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { queries } from '../../shared/api/queries'
import { resolveTheme } from '../../features/themes/definitions'
import { RpgVisualProvider } from '../../components/primitives/RpgVisualProvider'
import { AnimatedPage } from '../../components/motion/AnimatedPage'
import { AppSidebar } from './AppSidebar'

export function AppShell() {
  const [sidebarHovered, setSidebarHovered] = useState(false)
  const [sidebarFocused, setSidebarFocused] = useState(false)
  const preferences = useQuery(queries.preferences)
  const systems = useQuery(queries.systems)
  const user = useQuery(queries.user)
  const pathname = useRouterState({ select: (state) => state.location.pathname })
  const sidebarMode = preferences.data?.sidebarMode ?? 'collapsed'
  const collapsed = sidebarMode === 'always-collapsed' || (sidebarMode === 'collapsed' && !sidebarHovered && !sidebarFocused)
  const theme = resolveTheme(preferences.data?.activeThemeId ?? null)
  const activeSystem = systems.data?.find((system) => system.id === preferences.data?.activeSystemId)
  return <div data-theme={theme.id} className={theme.classes + ' min-h-screen bg-(--canvas) text-(--ink) selection:bg-(--accent) selection:text-(--canvas)'}>
    <RpgVisualProvider theme={theme}>
      <a href="#main-content" className="sr-only focus:not-sr-only focus:fixed focus:left-4 focus:top-4 focus:z-50 focus:bg-(--accent) focus:p-3 focus:text-(--canvas)">Pular para conteúdo</a>
      <div className="min-h-screen">
        <AppSidebar collapsed={collapsed} onMouseEnter={() => setSidebarHovered(true)} onMouseLeave={() => setSidebarHovered(false)}
          onFocus={() => setSidebarFocused(true)} onBlur={(event) => {
            if (!event.currentTarget.contains(event.relatedTarget instanceof Node ? event.relatedTarget : null)) setSidebarFocused(false)
          }}
          systemName={activeSystem?.name} userName={user.data?.name} avatarUrl={user.data?.avatarUrl} />
        <main id="main-content" tabIndex={-1} className={'min-w-0 px-4 py-8 outline-none md:px-8 lg:py-12 xl:px-12 ' + (collapsed ? 'ml-[72px]' : 'ml-[72px] md:ml-[248px]')}>
          {(preferences.isError || systems.isError || user.isError) && <p role="alert" className="mb-6 border border-(--edge) p-4">Não foi possível carregar seu contexto. <button className="underline" onClick={() => { void preferences.refetch(); void systems.refetch(); void user.refetch() }}>Tentar novamente</button></p>}
          <AnimatedPage key={pathname} duration={theme.duration} offset={theme.offset}><Outlet /></AnimatedPage>
          <footer className="mt-16 flex justify-between border-t border-(--edge) pt-5 font-mono text-[10px] uppercase tracking-widest opacity-60"><span>Suas histórias começam aqui.</span><span>RPG / 0.1</span></footer>
        </main>
      </div>
    </RpgVisualProvider>
  </div>
}
