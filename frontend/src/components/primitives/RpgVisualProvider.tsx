import { theme as antTheme, ConfigProvider } from "antd";
import ptBR from "antd/locale/pt_BR";
import type { ReactNode } from "react";
import type { ResolvedTheme } from "@/features/themes/definitions";

export function RpgVisualProvider({
	theme,
	children,
}: {
	theme: ResolvedTheme;
	children: ReactNode;
}) {
	return (
		<ConfigProvider
			locale={ptBR}
			modal={{ classNames: { root: theme.classes } }}
			tooltip={{ classNames: { root: theme.classes } }}
			theme={{
				algorithm:
					theme.mode === "light"
						? antTheme.defaultAlgorithm
						: antTheme.darkAlgorithm,
				token: {
					colorPrimary: theme.palette.accent,
					colorBgContainer: theme.palette.surface,
					colorBgElevated: theme.palette.surfaceRaised,
					colorBgBase: theme.palette.canvas,
					colorText: theme.palette.ink,
					colorTextSecondary: theme.palette.muted,
					colorTextPlaceholder: theme.palette.muted,
					colorBorder: theme.palette.edge,
					colorError: theme.palette.danger,
					colorSuccess: theme.palette.success,
					borderRadius: 12,
					controlHeight: 44,
					motion: false,
				},
			}}
		>
			{children}
		</ConfigProvider>
	);
}
