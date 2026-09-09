import { motion, useReducedMotion } from "motion/react";
import type { ReactNode } from "react";

export function AnimatedPage({
	children,
	duration = 0.2,
	offset = 8,
}: {
	children: ReactNode;
	duration?: number;
	offset?: number;
}) {
	const reduced = useReducedMotion();
	return (
		<motion.div
			initial={reduced ? false : { opacity: 0, y: offset }}
			animate={{ opacity: 1, y: 0 }}
			exit={reduced ? undefined : { opacity: 0 }}
			transition={{ duration: reduced ? 0 : duration }}
		>
			{children}
		</motion.div>
	);
}
export function AnimatedResult({
	children,
	resultKey,
}: {
	children: ReactNode;
	resultKey: number;
}) {
	const reduced = useReducedMotion();
	return (
		<motion.div
			key={resultKey}
			initial={reduced ? false : { scale: 0.92, opacity: 0 }}
			animate={{ scale: 1, opacity: 1 }}
			transition={{ duration: reduced ? 0 : 0.2 }}
		>
			{children}
		</motion.div>
	);
}
