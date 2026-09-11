import { Button, InputNumber } from "antd";
import { AnimatePresence, motion, useReducedMotion } from "motion/react";

type ResourceValue = { current: number; maximum: number; temporary: number };
type Props = ResourceValue & {
	label: string;
	tone: ResourceTone;
	onChange?: (value: ResourceValue) => void;
	editable?: boolean;
};

type ResourceTone = "health" | "sanity" | "effort";

const colors = {
	health: "bg-[#b52226]",
	sanity: "bg-[#8824df]",
	effort: "bg-[#ff8708]",
} satisfies Record<ResourceTone, string>;
const temporaryColors = {
	health: "bg-[#7f1d1d]",
	sanity: "bg-[#581c87]",
	effort: "bg-[#9a4a00]",
} satisfies Record<ResourceTone, string>;
const steps = [-5, -1, 1, 5] as const;

function toNonNegativeInteger(value: number) {
	return Math.max(0, Math.trunc(value));
}

export function RpgResourceBar({
	label,
	tone,
	current,
	maximum,
	temporary,
	onChange,
	editable = false,
}: Props) {
	const reduced = useReducedMotion();
	const limit = toNonNegativeInteger(maximum);
	const amount = Math.min(toNonNegativeInteger(current), limit);
	const temporaryAmount = toNonNegativeInteger(temporary);
	const updateCurrent = (next: number) => {
		if (!Number.isFinite(next)) return;
		const normalized = toNonNegativeInteger(next);
		const overflow = Math.max(0, normalized - limit);
		onChange?.({
			current: Math.min(normalized, limit),
			maximum: limit,
			temporary: Math.max(temporaryAmount, overflow),
		});
	};
	const updateMaximum = (next: number) => {
		if (!Number.isFinite(next)) return;
		const nextMaximum = toNonNegativeInteger(next);
		onChange?.({
			current: Math.min(amount, nextMaximum),
			maximum: nextMaximum,
			temporary: temporaryAmount,
		});
	};
	const applyStep = (step: (typeof steps)[number]) => {
		if (step < 0) {
			const damage = Math.abs(step);
			const temporaryDamage = Math.min(temporaryAmount, damage);
			onChange?.({
				current: Math.max(0, amount - (damage - temporaryDamage)),
				maximum: limit,
				temporary: temporaryAmount - temporaryDamage,
			});
			return;
		}

		const nextCurrent = Math.min(amount + step, limit);
		const overflow = Math.max(0, amount + step - limit);
		onChange?.({
			current: nextCurrent,
			maximum: limit,
			temporary: Math.max(temporaryAmount, overflow),
		});
	};
	const isControlDisabled = (step: (typeof steps)[number]) => {
		if (!onChange) return true;
		if (step < 0) return amount === 0 && temporaryAmount === 0;
		const nextCurrent = Math.min(amount + step, limit);
		const nextTemporary = Math.max(
			temporaryAmount,
			Math.max(0, amount + step - limit),
		);
		return nextCurrent === amount && nextTemporary === temporaryAmount;
	};
	const control = (step: (typeof steps)[number]) => (
		<Button
			key={step}
			type="text"
			htmlType="button"
			aria-label={`${label}: ${step < 0 ? "diminuir" : "aumentar"} ${Math.abs(step)}`}
			disabled={isControlDisabled(step)}
			onClick={() => applyStep(step)}
			className="h-11! w-7! min-w-0! shrink-0! rounded-none! border-0! p-0! text-white! shadow-none! transition-none! hover:bg-white/15! disabled:opacity-35! focus-visible:outline-2! focus-visible:-outline-offset-2! focus-visible:outline-white!"
		>
			<svg
				aria-hidden="true"
				viewBox="0 0 24 24"
				className={`size-5 ${step < 0 ? "rotate-180" : ""}`}
				fill="none"
				stroke="currentColor"
				strokeWidth="2"
				strokeLinecap="round"
				strokeLinejoin="round"
			>
				<path
					d={
						Math.abs(step) === 5 ? "m5 5 7 7-7 7 M12 5l7 7-7 7" : "m9 5 7 7-7 7"
					}
				/>
			</svg>
		</Button>
	);

	return (
		<div className="min-w-0 space-y-1.5">
			<p className="text-center text-xs font-semibold uppercase text-(--ink)">
				{label}
			</p>
			<div className="overflow-hidden rounded-xl border border-white/45 bg-[#121212]">
				<AnimatePresence initial={false}>
					{temporaryAmount > 0 && (
						<motion.div
							role="status"
							aria-label={`${label}: ${temporaryAmount} pontos temporários`}
							className={`flex h-5 items-center justify-center overflow-hidden text-[0.625rem] font-bold tracking-wider text-white ${temporaryColors[tone]}`}
							initial={reduced ? false : { height: 0, opacity: 0 }}
							animate={{ height: 20, opacity: 1 }}
							exit={reduced ? { opacity: 0 } : { height: 0, opacity: 0 }}
							transition={reduced ? { duration: 0 } : { duration: 0.18 }}
						>
							<span aria-hidden="true" className="tabular-nums">
								TEMP +{temporaryAmount}
							</span>
						</motion.div>
					)}
				</AnimatePresence>
				<div
					className={`relative isolate bg-[#121212] ${temporaryAmount > 0 ? "border-t border-white/45" : ""}`}
				>
					<motion.div
						role="progressbar"
						aria-label={label}
						aria-valuemin={0}
						aria-valuemax={limit}
						aria-valuenow={amount}
						aria-valuetext={`${amount} de ${limit}`}
						className={`absolute inset-0 -z-10 origin-left ${colors[tone]}`}
						initial={false}
						animate={{ scaleX: limit === 0 ? 0 : amount / limit }}
						transition={
							reduced
								? { duration: 0 }
								: { type: "spring", stiffness: 180, damping: 28 }
						}
					/>
					<div className="flex min-h-11 items-center px-0.5">
						{steps.slice(0, 2).map(control)}
						<div className="flex min-w-0 flex-1 items-center justify-center text-base font-semibold text-white">
							{editable && onChange ? (
								<>
									<InputNumber
										aria-label={`${label} atual`}
										value={amount}
										min={0}
										precision={0}
										controls={false}
										variant="borderless"
										onChange={(next) => {
											if (next !== null) updateCurrent(next);
										}}
										className="w-11! min-w-0! rounded-sm! bg-transparent! p-0! shadow-none! transition-none! focus-within:bg-black/25! [&_input]:h-10! [&_input]:px-0! [&_input]:text-center! [&_input]:font-semibold! [&_input]:text-white!"
									/>
									<span aria-hidden="true">/</span>
									<InputNumber
										aria-label={`${label} máxima`}
										value={limit}
										min={0}
										precision={0}
										controls={false}
										variant="borderless"
										onChange={(next) => {
											if (next !== null) updateMaximum(next);
										}}
										className="w-11! min-w-0! rounded-sm! bg-transparent! p-0! shadow-none! transition-none! focus-within:bg-black/25! [&_input]:h-10! [&_input]:px-0! [&_input]:text-center! [&_input]:font-semibold! [&_input]:text-white!"
									/>
								</>
							) : (
								<span className="tabular-nums">
									{amount} / {limit}
								</span>
							)}
						</div>
						{steps.slice(2).map(control)}
					</div>
				</div>
			</div>
		</div>
	);
}
