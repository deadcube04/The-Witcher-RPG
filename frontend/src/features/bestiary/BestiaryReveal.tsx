import { motion, useReducedMotion } from "motion/react";
import type { ReactNode } from "react";

export function BestiaryReveal({
	children,
	className = "",
	delay = 0,
}: {
	children: ReactNode;
	className?: string;
	delay?: number;
}) {
	const reduced = useReducedMotion();
	return (
		<motion.div
			initial={reduced ? false : { opacity: 0, y: 20 }}
			whileInView={{ opacity: 1, y: 0 }}
			viewport={{ once: true, amount: 0.08 }}
			transition={{
				duration: reduced ? 0 : 0.48,
				delay: reduced ? 0 : delay,
				ease: [0.32, 0.72, 0, 1],
			}}
			className={className}
		>
			{children}
		</motion.div>
	);
}
