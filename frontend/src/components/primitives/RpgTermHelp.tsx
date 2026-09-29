import { Tooltip } from "antd";
import { PiQuestionThin } from "react-icons/pi";

export function RpgTermHelp({
	term,
	explanation,
}: {
	term: string;
	explanation: string;
}) {
	return (
		<Tooltip title={explanation} trigger={["hover", "focus", "click"]}>
			<button
				type="button"
				aria-label={`O que significa ${term}? ${explanation}`}
				className="inline-flex size-7 items-center justify-center rounded-full text-(--muted) ring-1 ring-(--edge)/50 hover:text-(--ink) focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-(--accent)"
			>
				<PiQuestionThin aria-hidden="true" className="text-base" />
			</button>
		</Tooltip>
	);
}
