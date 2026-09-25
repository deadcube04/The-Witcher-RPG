import { notification } from "antd";
import type { ReactNode } from "react";

export type RollFeedbackResult = {
	expression: string;
	total: number;
	individual: number[];
};

type RollFeedback = {
	holder: ReactNode;
	show: (label: string, result: RollFeedbackResult) => void;
};

export function useRpgRollFeedback(): RollFeedback {
	const [api, contextHolder] = notification.useNotification();
	return {
		holder: (
			<div aria-live="polite" aria-atomic="true">
				{contextHolder}
			</div>
		),
		show: (label, result) => {
			api.open({
				message: label,
				description: (
					<div className="space-y-2 text-(--ink)">
						<p className="font-mono text-xs text-(--accent)">
							{result.expression}
						</p>
						<p className="font-mono text-3xl font-semibold">{result.total}</p>
						<p className="text-xs opacity-70">
							Dados: {result.individual.join(", ")}
						</p>
					</div>
				),
				placement: "bottomRight",
				duration: 4,
			});
		},
	};
}
