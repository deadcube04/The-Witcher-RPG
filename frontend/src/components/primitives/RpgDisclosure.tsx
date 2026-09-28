import { Button } from "antd";
import { motion, useReducedMotion } from "motion/react";
import { type ReactNode, useId, useState } from "react";

type Props = {
	title: ReactNode;
	summary?: ReactNode;
	children: ReactNode;
	defaultOpen?: boolean;
	className?: string;
	buttonClassName?: string;
	panelClassName?: string;
};

export function RpgDisclosure({
	title,
	summary,
	children,
	defaultOpen = false,
	className = "",
	buttonClassName = "",
	panelClassName = "",
}: Props) {
	const [open, setOpen] = useState(defaultOpen);
	const panelId = useId();
	const reduced = useReducedMotion();
	return (
		<div className={className}>
			<h3>
				<Button
					type="text"
					block
					aria-expanded={open}
					aria-controls={panelId}
					onClick={() => setOpen((current) => !current)}
					className={`min-h-12! h-auto! whitespace-normal! text-left! shadow-none! focus-visible:outline-2! focus-visible:outline-offset-2! focus-visible:outline-(--accent)! ${buttonClassName}`}
				>
					<span className="flex w-full items-center justify-between gap-4">
						<span className="min-w-0 flex-1">
							{title}
							{summary && (
								<span className="mt-1 block text-xs font-normal opacity-75">
									{summary}
								</span>
							)}
						</span>
						<motion.span
							aria-hidden="true"
							animate={{ rotate: open ? 45 : 0 }}
							transition={{ duration: reduced ? 0 : 0.2 }}
							className="shrink-0 text-xl leading-none"
						>
							+
						</motion.span>
					</span>
				</Button>
			</h3>
			<div id={panelId} hidden={!open} className={panelClassName}>
				{open && (
					<motion.div
						initial={reduced ? false : { opacity: 0, y: -8 }}
						animate={{ opacity: 1, y: 0 }}
						transition={{ duration: reduced ? 0 : 0.24 }}
					>
						{children}
					</motion.div>
				)}
			</div>
		</div>
	);
}
