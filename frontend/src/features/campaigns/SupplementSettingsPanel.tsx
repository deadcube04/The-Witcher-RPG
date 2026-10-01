import { RpgCheckbox } from "@/components/primitives/RpgControls";
import type { SupplementSettings } from "@/shared/contracts/campaign";
import type { Supplement } from "@/shared/contracts/supplement";
import { selectableSupplementRules, toggleSupplementRule } from "@/shared/lib/supplement-rules";

const categoryLabels: Record<SupplementSettings["categories"][number], string> = {
	survivor: "Sobrevivente",
	trails: "Trilhas",
	powers: "Poderes",
	rituals: "Rituais",
	items: "Itens",
	modifications: "Modificações",
	threats: "Ameaças",
};

type Props = {
	supplements: Supplement[];
	systemId: string;
	value: SupplementSettings | null;
	onChange: (value: SupplementSettings | null) => void;
};

export function SupplementSettingsPanel({ supplements, systemId, value, onChange }: Props) {
	const available = supplements.filter((entry) => entry.systemId === systemId);
	return <section aria-labelledby="supplement-title" className="rounded-[2rem] bg-(--edge)/35 p-1.5">
		<div className="space-y-6 rounded-[calc(2rem-0.375rem)] bg-(--surface) p-5 md:p-8">
			<div className="max-w-2xl space-y-2">
				<p className="font-mono text-[10px] uppercase tracking-[0.18em] text-(--accent)">Expansões da história</p>
				<h3 id="supplement-title" className="font-serif text-3xl tracking-tight md:text-4xl">Suplementos</h3>
				<p className="text-sm leading-6 text-(--muted)">Escolha quais recursos entram em jogo. As fichas desta campanha seguirão estas escolhas.</p>
			</div>
			{available.length === 0 ? <p className="text-sm text-(--muted)">Nenhum suplemento disponível para este sistema.</p> : available.map((supplement) => {
			const active = value?.id === supplement.id;
			const selected = active ? value : null;
			const optionalRules = selectableSupplementRules(supplement.rules);
			const toggleCategory = (category: SupplementSettings["categories"][number]) => {
				if (!selected) return;
				const enabled = selected.categories.includes(category);
				let categories = enabled ? selected.categories.filter((entry) => entry !== category) : [...selected.categories, category];
				if (category === "survivor") categories = enabled ? categories : Array.from(new Set([...categories, "trails" as const]));
				if (category === "trails" && enabled) categories = categories.filter((entry) => entry !== "survivor");
				onChange({ ...selected, categories });
			};
			const toggleRule = (id: string) => {
				if (!selected) return;
				onChange({ ...selected, ruleIds: toggleSupplementRule(supplement.rules, selected.ruleIds, id) });
			};
			return <div key={supplement.id} className="space-y-6">
				<div className="flex flex-wrap items-center justify-between gap-4 rounded-2xl bg-(--canvas) px-5 py-5">
					<div><h4 className="font-serif text-2xl">{supplement.name}</h4><p className="mt-1 text-xs text-(--muted)">Conteúdo oficial de Ordem Paranormal</p></div>
					<RpgCheckbox label="Ativar suplemento" checked={active} onChange={() => onChange(active ? null : { id: supplement.id, categories: [...supplement.categories] as SupplementSettings["categories"], ruleIds: [] })} />
				</div>
				{selected && <div className="grid gap-8 lg:grid-cols-[minmax(0,0.8fr)_minmax(0,1.2fr)]">
					<div className="space-y-3"><h5 className="font-semibold">Conteúdo permitido</h5><p className="text-xs leading-5 text-(--muted)">Classes e origens seguem as seleções individuais acima.</p><div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-1">{(Object.keys(categoryLabels) as SupplementSettings["categories"]).map((category) => <RpgCheckbox key={category} label={categoryLabels[category]} checked={selected.categories.includes(category)} onChange={() => toggleCategory(category)} />)}</div></div>
					<div className="space-y-3"><h5 className="font-semibold">Regras opcionais</h5><p className="text-xs leading-5 text-(--muted)">Escolha as regras principais. As regras filhas são incluídas automaticamente.</p><div className="max-h-[32rem] space-y-2 overflow-y-auto pr-2">{optionalRules.map((rule) => <div key={rule.id} className="rounded-xl bg-(--canvas) px-4 py-3"><RpgCheckbox label={rule.name} checked={selected.ruleIds.includes(rule.id)} onChange={() => toggleRule(rule.id)} /><details className="mt-2 text-xs leading-5 text-(--muted)"><summary className="cursor-pointer text-(--accent)">Ler regra · página {rule.sourcePage}</summary><p className="mt-2 whitespace-pre-wrap">{rule.text}</p></details></div>)}</div></div>
				</div>}
			</div>;
		})}
		</div>
	</section>;
}
