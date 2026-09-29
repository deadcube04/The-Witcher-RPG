import { useState } from "react";
import {
	elementVisuals,
	type BestiaryElementKey,
} from "@/features/bestiary/element-visuals";

type Props = {
	src: string | null;
	name: string;
	element: BestiaryElementKey | null;
	className?: string;
	priority?: boolean;
};

export function BestiaryPortrait({
	src,
	name,
	element,
	className = "",
	priority = false,
}: Props) {
	return (
		<PortraitContent
			key={src ?? "missing"}
			src={src}
			name={name}
			element={element}
			className={className}
			priority={priority}
		/>
	);
}

function PortraitContent({
	src,
	name,
	element,
	className = "",
	priority = false,
}: Props) {
	const [failed, setFailed] = useState(false);
	const visual = element ? elementVisuals[element] : null;
	return (
		<div
			className={`relative isolate overflow-hidden bg-[#151413] ${className}`}
		>
			{src && !failed ? (
				<img
					src={src}
					alt={name}
					loading={priority ? "eager" : "lazy"}
					fetchPriority={priority ? "high" : "auto"}
					onError={() => setFailed(true)}
					className="size-full object-contain"
				/>
			) : (
				<div
					role="img"
					aria-label={`Sem registro visual de ${name}`}
					className="grid size-full min-h-44 place-items-center bg-[radial-gradient(circle_at_50%_35%,color-mix(in_srgb,var(--element,#8c8274)_20%,transparent),transparent_55%)] p-5 text-center"
				>
					<div>
						<span
							aria-hidden="true"
							className="font-serif text-6xl text-[#b8aa99]"
						>
							{name.charAt(0)}
						</span>
						<p className="mt-3 font-mono text-[10px] uppercase tracking-[0.2em] text-[#d5c8b5]">
							Registro visual ausente
						</p>
						<p className="mt-2 font-serif text-xl text-[#e5ddd0]">{name}</p>
					</div>
				</div>
			)}
			{visual && (
				<span
					aria-hidden="true"
					className="absolute inset-x-0 bottom-0 h-12 bg-linear-to-t from-black/20 to-transparent"
				/>
			)}
		</div>
	);
}
