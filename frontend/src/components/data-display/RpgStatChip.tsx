export function RpgStatChip({
	label,
	value,
	onActivate,
}: {
	label: string;
	value: string;
	onActivate?: () => void;
}) {
	const classes =
		"min-w-0 rounded-sm border border-(--edge) bg-(--panel) px-3 py-2 text-left focus-visible:outline-2 focus-visible:outline-(--accent)";
	const content = (
		<>
			<span className="block truncate font-mono text-base font-semibold">
				{value}
			</span>
			<span className="block truncate text-[10px] uppercase tracking-wider opacity-60">
				{label}
			</span>
		</>
	);
	return onActivate ? (
		<button
			type="button"
			onClick={onActivate}
			className={`${classes} hover:border-(--accent) hover:text-(--accent)`}
		>
			{content}
		</button>
	) : (
		<div className={classes}>{content}</div>
	);
}
