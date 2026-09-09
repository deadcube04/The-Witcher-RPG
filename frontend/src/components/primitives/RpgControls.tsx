import { Button, Input, InputNumber, Select } from "antd";
import { AnimatePresence, motion, useReducedMotion } from "motion/react";
import { IoIosArrowDown } from "react-icons/io";
import { type ReactNode, useId, useState } from "react";

type ButtonProps = {
	children: ReactNode;
	onClick?: () => void;
	disabled?: boolean;
	loading?: boolean;
	submit?: boolean;
	secondary?: boolean;
	danger?: boolean;
};
export function RpgButton({
	children,
	onClick,
	disabled,
	loading,
	submit,
	secondary,
	danger,
}: ButtonProps) {
	return (
		<Button
			htmlType={submit ? "submit" : "button"}
			onClick={onClick}
			disabled={disabled}
			loading={loading}
			danger={danger}
			type={secondary ? "default" : "primary"}
			className={
				"min-h-11! rounded-sm! px-5! font-semibold! shadow-none! focus-visible:outline-2! focus-visible:outline-offset-4! " +
				(!secondary && !danger && !disabled
					? "bg-(--accent)! text-(--canvas)!"
					: "")
			}
		>
			{children}
		</Button>
	);
}
type FieldProps = {
	label: string;
	error?: string;
	hint?: string;
	children: (id: string) => ReactNode;
};
export function RpgField({ label, error, hint, children }: FieldProps) {
	const id = useId();
	return (
		<div className="min-w-0 space-y-2">
			<label htmlFor={id} className="block text-sm font-semibold">
				{label}
			</label>
			{children(id)}
			{hint && <p className="text-xs opacity-75">{hint}</p>}
			{error && (
				<p id={`${id}-error`} role="alert" className="text-sm text-red-400">
					{error}
				</p>
			)}
		</div>
	);
}
type InputProps = {
	label: string;
	value: string;
	onChange: (value: string) => void;
	onBlur?: () => void;
	disabled?: boolean;
	error?: string;
	multiline?: boolean;
	hint?: string;
};
export function RpgInput({
	label,
	value,
	onChange,
	onBlur,
	disabled,
	error,
	multiline,
	hint,
}: InputProps) {
	return (
		<RpgField label={label} error={error} hint={hint}>
			{(id) =>
				multiline ? (
					<Input.TextArea
						id={id}
						value={value}
						onChange={(event) => onChange(event.target.value)}
						onBlur={onBlur}
						disabled={disabled}
						rows={4}
						aria-invalid={!!error}
						aria-describedby={error ? `${id}-error` : undefined}
						className="rounded-sm!"
					/>
				) : (
					<Input
						id={id}
						value={value}
						onChange={(event) => onChange(event.target.value)}
						onBlur={onBlur}
						disabled={disabled}
						aria-invalid={!!error}
						aria-describedby={error ? `${id}-error` : undefined}
						className="min-h-11! rounded-sm!"
					/>
				)
			}
		</RpgField>
	);
}
export type SelectOption = { value: string; label: string; disabled?: boolean };
export function RpgSelect({
	label,
	value,
	onChange,
	options,
	disabled,
}: {
	label: string;
	value: string;
	onChange: (value: string) => void;
	options: SelectOption[];
	disabled?: boolean;
}) {
	return (
		<RpgField label={label}>
			{(id) => (
				<Select
					id={id}
					value={value}
					onChange={onChange}
					options={options}
					disabled={disabled}
					className="min-h-11! w-full!"
					virtual={false}
				/>
			)}
		</RpgField>
	);
}
export function RpgNumber({
	label,
	value,
	onChange,
	min,
	max,
	disabled,
}: {
	label: string;
	value: number;
	onChange: (value: number) => void;
	min?: number;
	max?: number;
	disabled?: boolean;
}) {
	return (
		<RpgField label={label}>
			{(id) => (
				<InputNumber
					id={id}
					value={value}
					onChange={(next) => onChange(next ?? 0)}
					min={min}
					max={max}
					precision={0}
					disabled={disabled}
					className="min-h-11! w-full! rounded-sm!"
				/>
			)}
		</RpgField>
	);
}
export function RpgInlineNumber({
	label,
	value,
	onChange,
	min,
	max,
}: {
	label: string;
	value: number;
	onChange: (value: number) => void;
	min?: number;
	max?: number;
}) {
	return (
		<InputNumber
			aria-label={label}
			value={value}
			onChange={(next) => {
				if (next !== null) onChange(next);
			}}
			min={min}
			max={max}
			precision={0}
			className="min-h-10! w-20! rounded-sm! [&_input]:text-center!"
		/>
	);
}
export function RpgInlineSelect({
	label,
	value,
	onChange,
	options,
}: {
	label: string;
	value: string;
	onChange: (value: string) => void;
	options: SelectOption[];
}) {
	const [open, setOpen] = useState(false);
	const [closing, setClosing] = useState(false);
	const reduced = useReducedMotion();
	const popupOpen = open || closing;
	const transition = { duration: reduced ? 0 : 0.18 };

	return (
		<Select
			aria-label={label}
			value={value}
			onChange={onChange}
			options={options}
			virtual={false}
			open={popupOpen}
			onOpenChange={(nextOpen) => {
				if (nextOpen) {
					setClosing(false);
					setOpen(true);
				} else {
					setClosing(true);
				}
			}}
			suffixIcon={
				<motion.span
					initial={false}
					animate={{ rotate: open ? 180 : 0 }}
					transition={transition}
					className="inline-flex text-base"
				>
					<IoIosArrowDown aria-hidden="true" />
				</motion.span>
			}
			popupRender={(menu) => (
				<AnimatePresence
					initial={false}
					onExitComplete={() => {
						if (closing) {
							setClosing(false);
							setOpen(false);
						}
					}}
				>
					{!closing && (
						<motion.div
							key="inline-select-menu"
							initial={
								reduced
									? false
									: { opacity: 0, height: 0, scaleY: 0.96 }
							}
							animate={{ opacity: 1, height: "auto", scaleY: 1 }}
							exit={
								reduced
									? undefined
									: { opacity: 0, height: 0, scaleY: 0.96 }
							}
							transition={transition}
							className="origin-top overflow-hidden"
						>
							{menu}
						</motion.div>
					)}
				</AnimatePresence>
			)}
			className="min-h-10! w-32! [&_.ant-select-selection-item]:text-center!"
		/>
	);
}
export function RpgAttributeNumber({
	label,
	value,
	onChange,
}: {
	label: string;
	value: number;
	onChange: (value: number) => void;
}) {
	return (
		<InputNumber
			aria-label={label}
			value={value}
			onChange={(next) => {
				if (next !== null) onChange(next);
			}}
			min={0}
			max={5}
			precision={0}
			controls={false}
			variant="borderless"
			className="w-16! bg-transparent! shadow-none! hover:bg-(--panel)! focus-within:bg-(--panel)! [&_input]:cursor-text! [&_input]:text-center! [&_input]:font-mono! [&_input]:text-2xl! [&_input]:font-semibold! [&_input]:text-(--accent)!"
		/>
	);
}
