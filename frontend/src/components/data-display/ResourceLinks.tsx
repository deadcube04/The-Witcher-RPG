import { Link } from "@tanstack/react-router";
import { RpgEmptyState } from "../feedback/RemoteState";

export function ResourceLinks({
	items,
	kind,
}: {
	items: readonly { id: string; name: string; updatedAt: string }[];
	kind: "campaigns" | "characters";
}) {
	if (!items.length)
		return (
			<RpgEmptyState title="Seu arquivo começa aqui">
				<Link to={`/${kind}/new`} className="text-(--accent) underline">
					Criar {kind === "campaigns" ? "campanha" : "ficha"}
				</Link>
			</RpgEmptyState>
		);
	return (
		<ul className="divide-y divide-(--edge)">
			{items.map((item, index) => (
				<li key={item.id}>
					<Link
						to={`/${kind}/${item.id}`}
						className="flex min-h-20 items-center justify-between gap-4 py-5 hover:text-(--accent) focus-visible:outline-2"
					>
						<span className="flex items-center gap-4">
							<span aria-hidden="true" className="font-mono text-xs opacity-50">
								0{index + 1}
							</span>
							<span className="text-lg">{item.name}</span>
						</span>
						<span aria-hidden="true">↗</span>
					</Link>
				</li>
			))}
		</ul>
	);
}
