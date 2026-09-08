import { ConfigProvider, theme as antTheme } from 'antd'
import ptBR from 'antd/locale/pt_BR'
import type { ReactNode } from 'react'
import type { ResolvedTheme } from '../../features/themes/definitions'

export function RpgVisualProvider({ theme, children }: { theme: ResolvedTheme; children: ReactNode }) {
  return <ConfigProvider locale={ptBR} theme={{ algorithm: antTheme.darkAlgorithm, token: {
    colorPrimary: theme.palette.accent, colorBgContainer: theme.palette.panel, colorBgElevated: theme.palette.panel,
    colorBgBase: theme.palette.background, colorText: theme.palette.ink, colorBorder: theme.palette.edge,
    borderRadius: 2, controlHeight: 44, motion: false,
  } }}>{children}</ConfigProvider>
}
