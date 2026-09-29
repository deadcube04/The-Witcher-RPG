import { Tabs } from "antd";
import { motion, useReducedMotion } from "motion/react";
import type { ReactNode } from "react";

export type SheetTab = {
	key: string;
	label: string;
	icon?: ReactNode;
	children: ReactNode;
};

type Props = {
	items: SheetTab[];
	secondary?: boolean;
};

const primaryClasses =
	"[&_.ant-tabs-nav]:mb-0! [&_.ant-tabs-nav]:px-2! [&_.ant-tabs-nav::before]:border-(--edge)/50! [&_.ant-tabs-nav-wrap]:overflow-x-auto! [&_.ant-tabs-nav-list]:min-w-max! [&_.ant-tabs-tab]:m-0! [&_.ant-tabs-tab]:min-h-12! [&_.ant-tabs-tab]:px-3! [&_.ant-tabs-tab-btn]:font-semibold! [&_.ant-tabs-tab-btn]:text-(--muted)! [&_.ant-tabs-tab-active_.ant-tabs-tab-btn]:text-(--accent)! [&_.ant-tabs-ink-bar]:bg-(--accent)! [&_.ant-tabs-content-holder]:min-w-0! [&_.ant-tabs-tabpane]:min-w-0! sm:[&_.ant-tabs-tab]:px-5!";
const secondaryClasses =
	"[&_.ant-tabs-nav]:mb-4! [&_.ant-tabs-nav]:w-full! [&_.ant-tabs-nav::before]:border-(--edge)/40! [&_.ant-tabs-nav-wrap]:w-full! [&_.ant-tabs-nav-list]:flex! [&_.ant-tabs-nav-list]:w-full! [&_.ant-tabs-tab]:m-0! [&_.ant-tabs-tab]:min-h-11! [&_.ant-tabs-tab]:min-w-0! [&_.ant-tabs-tab]:flex-1! [&_.ant-tabs-tab]:justify-center! [&_.ant-tabs-tab]:px-2! [&_.ant-tabs-tab-btn]:w-full! [&_.ant-tabs-tab-btn]:whitespace-nowrap! [&_.ant-tabs-tab-btn]:text-center! [&_.ant-tabs-tab-btn]:text-sm! [&_.ant-tabs-tab-btn]:font-medium! [&_.ant-tabs-tab-btn]:text-(--muted)! [&_.ant-tabs-tab-active_.ant-tabs-tab-btn]:text-(--ink)! [&_.ant-tabs-ink-bar]:bg-(--accent)! [&_.ant-tabs-content-holder]:min-w-0! [&_.ant-tabs-tabpane]:min-w-0!";

export function RpgSheetTabs({ items, secondary = false }: Props) {
	return (
		<Tabs
			defaultActiveKey={items[0]?.key}
			animated={false}
			destroyOnHidden={false}
			className={`min-w-0 ${secondary ? secondaryClasses : primaryClasses}`}
			items={items.map(({ key, label, icon, children }) => ({
				key,
				label: (
					<span className="inline-flex items-center gap-2 whitespace-nowrap">
						{icon && (
							<span aria-hidden="true" className="text-lg">
								{icon}
							</span>
						)}
						{label}
					</span>
				),
				children: (
					<SheetTabContent secondary={secondary}>{children}</SheetTabContent>
				),
			}))}
		/>
	);
}

function SheetTabContent({
	children,
	secondary,
}: {
	children: ReactNode;
	secondary: boolean;
}) {
	const reduced = useReducedMotion();
	return (
		<motion.div
			initial={reduced ? false : { opacity: 0, y: 8 }}
			animate={{ opacity: 1, y: 0 }}
			transition={{ duration: reduced ? 0 : 0.26, ease: [0.32, 0.72, 0, 1] }}
			className={secondary ? "min-w-0" : "min-w-0 p-3 sm:p-5"}
		>
			{children}
		</motion.div>
	);
}
