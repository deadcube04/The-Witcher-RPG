import type { ReactNode } from "react";
import { BestiaryReveal } from "@/features/bestiary/BestiaryReveal";

export function BookSpread({
	children,
	label,
}: {
	children: ReactNode;
	label: string;
}) {
	return (
		<BestiaryReveal>
			<section
				aria-label={label}
				className="relative mb-6 grid items-stretch gap-px border border-(--paper-rule) bg-(--paper-rule) shadow-[0_24px_70px_var(--shadow)] lg:grid-cols-2 lg:before:pointer-events-none lg:before:absolute lg:before:inset-y-0 lg:before:left-1/2 lg:before:z-10 lg:before:w-4 lg:before:-translate-x-1/2 lg:before:bg-[linear-gradient(90deg,transparent,rgba(42,33,25,0.16),transparent)]"
			>
				{children}
			</section>
		</BestiaryReveal>
	);
}

export function BookPage({
	children,
	folio,
	className = "",
}: {
	children: ReactNode;
	folio: string;
	className?: string;
}) {
	return (
		<div
			className={`flex min-w-0 flex-col bg-(--paper) px-5 py-7 text-(--paper-ink) md:px-8 md:py-9 xl:px-10 ${className}`}
		>
			<div className="flex-1">{children}</div>
			<p className="mt-8 border-t border-(--paper-rule) pt-3 font-mono text-[10px] uppercase tracking-[0.18em] text-(--paper-muted)">
				{folio}
			</p>
		</div>
	);
}

export function BookHeading({ mark, title }: { mark: string; title: string }) {
	return (
		<div className="mb-6 border-b border-(--paper-rule) pb-4">
			<p className="font-mono text-[10px] uppercase tracking-[0.2em] text-(--paper-muted)">
				{mark}
			</p>
			<h2 className="mt-2 font-serif text-3xl leading-tight md:text-4xl">
				{title}
			</h2>
		</div>
	);
}

type Fact = [label: string, value: string | number | null | undefined];

export function BookFacts({
	entries,
	columns = 2,
}: {
	entries: Fact[];
	columns?: 2 | 4;
}) {
	const available = entries.filter(
		([, value]) => value !== null && value !== undefined && value !== "",
	);
	if (available.length === 0) return null;
	return (
		<dl
			className={`grid gap-px border border-(--paper-rule) bg-(--paper-rule) ${columns === 4 ? "grid-cols-2 xl:grid-cols-4" : "grid-cols-2"}`}
		>
			{available.map(([label, value]) => (
				<div key={label} className="min-w-0 bg-(--paper) p-3">
					<dt className="font-mono text-[10px] uppercase tracking-[0.09em] text-(--paper-muted)">
						{label}
					</dt>
					<dd className="mt-1 break-words font-serif text-xl leading-tight text-(--paper-ink)">
						{value}
					</dd>
				</div>
			))}
		</dl>
	);
}

export function BookNotes({ entries }: { entries: Fact[] }) {
	const available = entries.filter(
		([, value]) => value !== null && value !== undefined && value !== "",
	);
	if (available.length === 0) return null;
	return (
		<dl className="space-y-4">
			{available.map(([label, value]) => (
				<div key={label} className="border-l-2 border-(--paper-rule) pl-3">
					<dt className="font-mono text-[10px] uppercase tracking-[0.12em] text-(--paper-muted)">
						{label}
					</dt>
					<dd className="mt-1 whitespace-pre-line text-sm leading-6 text-(--paper-ink)">
						{value}
					</dd>
				</div>
			))}
		</dl>
	);
}

export function BookSubheading({ children }: { children: ReactNode }) {
	return (
		<h3 className="mb-4 mt-8 border-b border-(--paper-rule) pb-2 font-serif text-2xl leading-tight first:mt-0">
			{children}
		</h3>
	);
}
