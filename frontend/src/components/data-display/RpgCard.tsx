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
				"h-full! rounded-2xl! border-(--edge)! bg-(--surface)! text-(--ink)! shadow-[0_22px_70px_var(--shadow)]! " +
				className
			}
		>
			{children}
		</Card>
	);
}
