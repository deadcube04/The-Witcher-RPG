export function NexusBrand({ compact = false }: { compact?: boolean }) {
	return (
		<span
			aria-hidden="true"
			className="flex min-w-0 items-center gap-3 text-(--ink)"
		>
			<img
				src="/brand/nexus-symbol.svg"
				alt=""
				width="40"
				height="40"
				className="size-10 shrink-0"
			/>
			{!compact && (
				<span className="block h-8 w-36 bg-current [mask-image:url('/brand/nexus-wordmark.svg')] [mask-repeat:no-repeat] [mask-position:center] [mask-size:contain]" />
			)}
		</span>
	);
}
