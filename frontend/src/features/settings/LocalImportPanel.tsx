import { useQuery, useQueryClient } from "@tanstack/react-query";
import { useState } from "react";
import { RpgButton, RpgCheckbox } from "@/components/primitives/RpgControls";
import { queries } from "@/shared/api/queries";
import { importKey, localImportApi, readLocalImportItems, selectedImportItems, type ImportItem, type ImportResult } from "@/shared/api/local-import";

const labels: Record<string, string> = {
	campaign: "Campanha", character: "Ficha", "inventory-definition": "Item homebrew",
	"ritual-definition": "Ritual homebrew", "attack-definition": "Ataque homebrew",
	"official-inventory": "Referência a item oficial", "official-ritual": "Referência a ritual oficial",
	"official-attack": "Referência a ataque oficial", "inventory-entry": "Item da ficha",
	"ritual-entry": "Ritual da ficha", "attack-entry": "Ataque da ficha",
};

export function LocalImportPanel() {
	const systems = useQuery(queries.systems);
	const queryClient = useQueryClient();
	const [items, setItems] = useState<ImportItem[] | null>(null);
	const [selected, setSelected] = useState<Set<string>>(new Set());
	const [preview, setPreview] = useState<ImportResult | null>(null);
	const [busy, setBusy] = useState(false);
	const [error, setError] = useState("");
	const [done, setDone] = useState(() => window.localStorage.getItem("rpg-manager:local-import:done") === "1");
	if (import.meta.env.VITE_API_MODE === "mock") return null;
	const load = async () => {
		if (!systems.data) return;
		setBusy(true); setError("");
		try {
			const candidates = readLocalImportItems(systems.data);
			setItems(candidates); setSelected(new Set(candidates.map(importKey)));
			setPreview(candidates.length ? await localImportApi.preview(candidates) : null);
		} catch { setError("Não foi possível ler ou validar os dados locais do mock."); }
		finally { setBusy(false); }
	};
	const refreshPreview = async () => {
		if (!items) return;
		setBusy(true); setError("");
		try { setPreview(await localImportApi.preview(selectedImportItems(items, selected))); }
		catch { setError("Não foi possível conferir a seleção com a API."); }
		finally { setBusy(false); }
	};
	const apply = async () => {
		if (!items || selected.size === 0) return;
		setBusy(true); setError("");
		try {
			const chosen = selectedImportItems(items, selected);
			const checked = await localImportApi.preview(chosen);
			setPreview(checked);
			if (checked.issues.length) { setError("Resolva os problemas da prévia ou desmarque os itens afetados."); return; }
			const result = await localImportApi.apply(chosen);
			setPreview(result);
			window.localStorage.setItem("rpg-manager:local-import:done", "1");
			setDone(true);
			await queryClient.invalidateQueries();
		} catch { setError("A importação foi cancelada. Nenhum item da seleção foi gravado."); }
		finally { setBusy(false); }
	};
	return <section className="mt-8 space-y-5 rounded-2xl border border-(--edge)/60 bg-(--surface) p-6" aria-label="Importação local">
		<h2 className="font-serif text-3xl">Importar dados do mock</h2>
		<p className="text-sm leading-6 text-(--muted)">A prévia inclui dados criados ou alterados no modo mock. Referências necessárias acompanham a seleção. O conteúdo local permanece no navegador.</p>
		{done && <p className="text-sm text-(--accent)">Uma importação local já foi concluída. A API reconhece itens repetidos.</p>}
		<RpgButton onClick={() => void load()} disabled={busy || systems.isPending || !!systems.error} secondary>Carregar prévia</RpgButton>
		{items && <div className="space-y-4">
			{items.length === 0 ? <p className="text-sm">Nenhum dado criado ou alterado foi encontrado no mock.</p> : <ul className="max-h-80 space-y-3 overflow-y-auto border-t border-(--edge)/60 pt-4">{items.map((item) => <li key={importKey(item)}><RpgCheckbox label={`${labels[item.kind] ?? item.kind}: ${item.name}`} checked={selected.has(importKey(item))} disabled={busy} onChange={(checked) => { const next = new Set(selected); if (checked) next.add(importKey(item)); else next.delete(importKey(item)); setSelected(next); setPreview(null); }} /></li>)}</ul>}
			{items.length > 0 && <div className="flex flex-wrap gap-3"><RpgButton onClick={() => void refreshPreview()} disabled={busy || selected.size === 0} secondary>Atualizar prévia</RpgButton><RpgButton onClick={() => void apply()} disabled={busy || selected.size === 0} loading={busy}>Importar seleção</RpgButton></div>}
		</div>}
		{preview && <div role="status" className="space-y-2 text-sm"><p>{preview.ready} pronto(s), {preview.alreadyImported} já importado(s), {preview.issues.length} problema(s).</p>{preview.issues.map((issue) => <p key={`${issue.kind}:${issue.sourceId}`} className="text-red-400">{labels[issue.kind] ?? issue.kind} ({issue.sourceId}): {issue.code}</p>)}</div>}
		{error && <p role="alert" className="text-sm text-red-400">{error}</p>}
	</section>;
}
