import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { RpgButton, RpgInput } from "@/components/primitives/RpgControls";
import { RpgErrorState, RpgSkeleton } from "@/components/feedback/RemoteState";
import { characterApi } from "@/shared/api/domains";
import { keys, queries, useDomainMutation } from "@/shared/api/queries";
import type { OrdemData } from "@/shared/contracts/character-sheet";

const typeLabel: Record<string, string> = { CLASS_POWER: "Poder de classe", TRAIL_ABILITY: "Habilidade de trilha", GENERAL_POWER: "Poder geral", PARANORMAL_POWER: "Poder paranormal" };

export function PowersPanel({ characterId, progression }: { characterId: string; progression: OrdemData }) {
	const [search, setSearch] = useState("");
	const powers = useQuery(queries.powers(characterId));
	const mutation = useDomainMutation((value: { id: string; selected: boolean }) => characterApi.setPower(characterId, value.id, value.selected), [keys.powers(characterId)]);
	if (powers.isPending) return <RpgSkeleton />;
	if (powers.error) return <RpgErrorState error={powers.error} retry={() => void powers.refetch()} />;
	const current = progression.progressionMode === "level-nex" ? (progression.level ?? 1) * 5 : progression.nex;
	const visible = powers.data.filter((entry) => entry.name.toLocaleLowerCase("pt-BR").includes(search.toLocaleLowerCase("pt-BR")));
	return <section className="space-y-5" aria-label="Poderes do suplemento">
		<div className="grid gap-3 border-b border-(--edge)/60 pb-5 sm:grid-cols-[1fr_18rem] sm:items-end"><div><p className="font-mono text-[10px] uppercase tracking-[0.18em] text-(--accent)">Sobrevivendo ao Horror</p><h3 className="mt-1 font-serif text-3xl">Poderes e trilhas</h3><p className="mt-2 text-sm text-(--muted)">Selecione os poderes conhecidos. Confira pré requisitos e efeitos antes de adicioná-los.</p></div><RpgInput label="Buscar poder" value={search} onChange={setSearch} /></div>
		{mutation.error && <p role="alert" className="text-sm text-(--danger)">{mutation.error.message}</p>}
		{visible.length === 0 && <p className="rounded-2xl bg-(--panel) p-6 text-sm text-(--muted)">Nenhum poder disponível para as opções atuais da ficha.</p>}
		<div className="grid gap-3 md:grid-cols-2">{visible.map((power) => { const locked = power.requiredProgression !== null && current < power.requiredProgression; return <article key={power.id} className="flex flex-col rounded-2xl border border-(--edge)/55 bg-(--panel) p-5"><div className="flex items-start justify-between gap-3"><div><p className="font-mono text-[10px] uppercase tracking-wider text-(--accent)">{typeLabel[power.abilityType] ?? power.abilityType} · p. {power.sourcePage}</p><h4 className="mt-2 font-serif text-xl">{power.name}</h4></div><span className="rounded-full border border-(--edge) px-2 py-1 text-[10px] uppercase tracking-wide">{power.selected ? "Na ficha" : "Disponível"}</span></div><p className="mt-3 whitespace-pre-wrap text-sm leading-6 text-(--muted)">{power.effectText}</p>{power.prerequisiteText && <p className="mt-3 text-xs leading-5">Pré requisito: {power.prerequisiteText}</p>}{power.affinityEffect && <details className="mt-3 text-xs"><summary className="cursor-pointer text-(--accent)">Efeito com afinidade</summary><p className="mt-2 leading-5">{power.affinityEffect}</p></details>}<div className="mt-auto pt-5"><RpgButton secondary disabled={mutation.isPending || (locked && !power.selected)} onClick={() => mutation.mutate({ id: power.id, selected: !power.selected })}>{power.selected ? "Remover da ficha" : locked ? `Exige progressão ${power.requiredProgression}` : "Adicionar à ficha"}</RpgButton></div></article>; })}</div>
	</section>;
}
