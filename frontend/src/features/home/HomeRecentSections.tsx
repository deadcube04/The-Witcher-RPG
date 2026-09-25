import { Link } from "@tanstack/react-router";

type RecentItem = {
	id: string;
	name: string;
	updatedAt: string;
};

const updatedAtFormatter = new Intl.DateTimeFormat("pt-BR", {
	day: "2-digit",
	month: "short",
});

function formatUpdatedAt(value: string): string {
	return updatedAtFormatter.format(new Date(value)).replace(" de ", " ");
}

function EmptyRecent({ kind }: { kind: "campaigns" | "characters" }) {
	const isCampaign = kind === "campaigns";
	return (
		<div className="mt-5 border-l border-(--edge) py-3 pl-4 text-sm opacity-70">
			<p>
				{isCampaign ? "Nenhuma campanha criada." : "Nenhum personagem criado."}
			</p>
			<Link
				to={`/${kind}/new`}
				className="mt-2 inline-flex min-h-11 items-center text-(--accent) underline underline-offset-4"
			>
				{isCampaign ? "Criar campanha" : "Criar personagem"}
			</Link>
		</div>
	);
}

export function RecentCampaigns({ items }: { items: readonly RecentItem[] }) {
	return (
		<section aria-labelledby="recent-campaigns-title">
			<div className="flex items-baseline justify-between gap-4 border-b border-(--edge) pb-4">
				<h3
					id="recent-campaigns-title"
					className="text-2xl font-semibold tracking-tight"
				>
					Campanhas recentes
				</h3>
				<Link
					to="/campaigns"
					className="shrink-0 text-sm text-(--accent) underline underline-offset-4"
				>
					Ver campanhas
				</Link>
			</div>
			{items.length === 0 ? (
				<EmptyRecent kind="campaigns" />
			) : (
				<ul>
					{items.map((item) => (
						<li key={item.id} className="border-b border-(--edge)">
							<Link
								to={`/campaigns/${item.id}`}
								className="group grid min-h-24 grid-cols-[1fr_auto] items-center gap-5 py-5 focus-visible:outline-2 focus-visible:outline-(--accent)"
							>
								<span className="text-lg font-medium group-hover:text-(--accent)">
									{item.name}
								</span>
								<span className="flex items-center gap-5 text-xs opacity-60">
									<time dateTime={item.updatedAt}>
										{formatUpdatedAt(item.updatedAt)}
									</time>
									<span aria-hidden="true" className="text-base">
										→
									</span>
								</span>
							</Link>
						</li>
					))}
				</ul>
			)}
		</section>
	);
}

export function RecentCharacters({ items }: { items: readonly RecentItem[] }) {
	return (
		<section
			aria-labelledby="recent-characters-title"
			className="bg-(--panel) p-6 md:p-7"
		>
			<div className="flex items-baseline justify-between gap-4">
				<h3
					id="recent-characters-title"
					className="text-xl font-semibold tracking-tight"
				>
					Personagens
				</h3>
				<Link
					to="/characters"
					className="shrink-0 text-sm text-(--accent) underline underline-offset-4"
				>
					Ver fichas
				</Link>
			</div>
			{items.length === 0 ? (
				<EmptyRecent kind="characters" />
			) : (
				<ul className="mt-5 space-y-2">
					{items.map((item) => (
						<li key={item.id}>
							<Link
								to={`/characters/${item.id}`}
								className="group flex min-h-16 items-center justify-between gap-4 border-l-2 border-(--edge) py-3 pl-4 hover:border-(--accent) focus-visible:outline-2 focus-visible:outline-(--accent)"
							>
								<span className="font-medium group-hover:text-(--accent)">
									{item.name}
								</span>
								<time
									dateTime={item.updatedAt}
									className="shrink-0 text-xs opacity-60"
								>
									{formatUpdatedAt(item.updatedAt)}
								</time>
							</Link>
						</li>
					))}
				</ul>
			)}
		</section>
	);
}
