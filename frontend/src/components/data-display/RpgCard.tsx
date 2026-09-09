import { Card } from "antd";
import type { ReactNode } from "react";

export function RpgCard({
	children,
	className = "",
}: {
	children: ReactNode;
	className?: string;
}) {
	return (
		<Card
			className={
				"h-full! rounded-sm! border-(--edge)! bg-(--panel)! text-(--ink)! shadow-none! " +
				className
			}
		>
			{children}
		</Card>
	);
}
