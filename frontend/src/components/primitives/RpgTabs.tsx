import { Tabs } from "antd";
import type { ReactNode } from "react";

export type RpgTabKey = "information" | "sheet";

type Props = {
	activeKey: RpgTabKey;
	onChange: (key: RpgTabKey) => void;
	information: ReactNode;
	sheet: ReactNode;
};

export function RpgTabs({ activeKey, onChange, information, sheet }: Props) {
	return (
		<Tabs
			activeKey={activeKey}
			onChange={(key) => {
				if (key === "information" || key === "sheet") onChange(key);
			}}
			items={[
				{ key: "information", label: "Informações", children: information },
				{ key: "sheet", label: "Ficha", children: sheet },
			]}
			className="[&_.ant-tabs-nav]:mb-8! [&_.ant-tabs-nav]:border-b! [&_.ant-tabs-nav]:border-(--edge)/40! [&_.ant-tabs-tab]:min-h-12! [&_.ant-tabs-tab]:px-2! [&_.ant-tabs-tab]:text-base! [&_.ant-tabs-tab]:font-semibold! [&_.ant-tabs-tab-btn]:text-(--muted)! [&_.ant-tabs-tab-active_.ant-tabs-tab-btn]:text-(--ink)! [&_.ant-tabs-ink-bar]:bg-(--accent)! [&_.ant-tabs-tab-btn:focus-visible]:outline-2! [&_.ant-tabs-tab-btn:focus-visible]:outline-offset-4! [&_.ant-tabs-tab-btn:focus-visible]:outline-(--accent)!"
		/>
	);
}
