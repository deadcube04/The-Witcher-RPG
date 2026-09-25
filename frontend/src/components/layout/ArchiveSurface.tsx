import { motion, useReducedMotion } from "motion/react";
import type { ReactNode } from "react";
import { PiArrowUpRightThin } from "react-icons/pi";

export function ArchiveEyebrow({ children }: { children: ReactNode }) {
	return (
		<p className="font-mono text-[0.65rem] font-medium uppercase tracking-[0.24em] text-(--accent)">
			{children}
		</p>
	);
}

export function PageMasthead({
	eyebrow,
	title,
	description,
	actions,
	compact = false,
}: {
	eyebrow: string;
	title: string;
	description?: string;
	actions?: ReactNode;
	compact?: boolean;
}) {
	const reduced = useReducedMotion();
	return (
		<header
			className={`grid items-end gap-6 border-b border-(--edge)/70 ${compact ? "mb-7 pb-6" : "mb-10 pb-8 lg:grid-cols-[minmax(0,1fr)_auto] lg:pb-10"}`}
		>
			<motion.div
				initial={reduced ? false : { opacity: 0, y: 22 }}
				animate={{ opacity: 1, y: 0 }}
				transition={{ duration: reduced ? 0 : 0.52, ease: [0.32, 0.72, 0, 1] }}
				className="max-w-3xl"
			>
				<ArchiveEyebrow>{eyebrow}</ArchiveEyebrow>
				<h1 className="mt-4 font-serif text-[clamp(2.5rem,6vw,5.75rem)] font-medium leading-[0.94] tracking-[-0.045em] text-balance">
					{title}
				</h1>
				{description && (
					<p className="mt-5 max-w-2xl text-sm leading-7 text-(--muted) md:text-base">
						{description}
					</p>
				)}
			</motion.div>
			{actions && <div className="flex flex-wrap gap-3 lg:justify-end">{actions}</div>}
		</header>
	);
}

export function ArchivePanel({
	children,
	className = "",
	label,
}: {
	children: ReactNode;
	className?: string;
	label?: string;
}) {
	return (
		<section
			aria-label={label}
			className={`rounded-2xl border border-(--edge)/70 bg-(--surface) shadow-[0_22px_70px_var(--shadow)] ${className}`}
		>
			{children}
		</section>
	);
}

export function MediaFrame({
	src,
	alt,
	children,
	className = "",
	priority = false,
}: {
	src: string;
	alt: string;
	children?: ReactNode;
	className?: string;
	priority?: boolean;
}) {
	return (
		<div className={`relative isolate overflow-hidden rounded-3xl bg-(--surface-raised) ring-1 ring-white/8 ${className}`}>
			<img
				src={src}
				alt={alt}
				loading={priority ? "eager" : "lazy"}
				fetchPriority={priority ? "high" : "auto"}
				className="absolute inset-0 size-full object-cover"
			/>
			<div aria-hidden="true" className="absolute inset-0 bg-[linear-gradient(90deg,var(--scrim)_0%,color-mix(in_srgb,var(--scrim)_86%,transparent)_42%,color-mix(in_srgb,var(--scrim)_28%,transparent)_100%)]" />
			<div className="relative z-10">{children}</div>
		</div>
	);
}

export function ArrowMark() {
	return (
		<span className="grid size-9 shrink-0 place-items-center rounded-full bg-current/10 transition-transform duration-500 ease-[cubic-bezier(0.32,0.72,0,1)] group-hover:translate-x-1 group-hover:-translate-y-0.5">
			<PiArrowUpRightThin aria-hidden="true" className="size-4" />
		</span>
	);
}
