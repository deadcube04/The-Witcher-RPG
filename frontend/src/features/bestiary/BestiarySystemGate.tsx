import archiveHero from "@/assets/archive/archive-hero.webp";
import type { ReactNode } from "react";
import { useQuery } from "@tanstack/react-query";
import { RpgButton } from "@/components/primitives/RpgControls";
import { MutationFeedback } from "@/components/feedback/RemoteState";
import { BestiaryError, BestiaryLoading } from "@/features/bestiary/BestiaryRemoteState";
import { keys, queries, useDomainMutation } from "@/shared/api/queries";
import { preferencesApi } from "@/shared/api/domains";

export function BestiarySystemGate({ children }: { children: ReactNode }) {
	const preferences = useQuery(queries.preferences);
	const systems = useQuery(queries.systems);
	const selectSystem = useDomainMutation(preferencesApi.update, [keys.preferences]);
	if (preferences.isPending || systems.isPending) return <BestiaryLoading variant="gallery" />;
	if (preferences.isError) return <BestiaryError error={preferences.error} retry={() => void preferences.refetch()} />;
	if (systems.isError) return <BestiaryError error={systems.error} retry={() => void systems.refetch()} />;
	const activeSystem = systems.data.find((system) => system.id === preferences.data.activeSystemId);
	const ordem = systems.data.find((system) => system.slug === "ordem-paranormal");
	if (activeSystem?.slug === "ordem-paranormal") return children;
	return (
		<section className="relative isolate mx-auto min-h-[60dvh] max-w-[1480px] overflow-hidden border border-(--edge) bg-[#11120f] p-7 text-[#fff8eb] md:p-12">
			<img src={archiveHero} alt="" className="absolute inset-0 size-full object-cover opacity-65" />
			<div aria-hidden="true" className="absolute inset-0 bg-linear-to-r from-black/95 via-black/75 to-black/30" />
			<div className="relative max-w-2xl">
			<p className="font-mono text-[10px] uppercase tracking-[0.2em] text-[#efd4b1]">Arquivo reservado / Ordem Paranormal</p>
			<h1 className="mt-5 font-serif text-5xl leading-tight md:text-6xl">Este universo ainda não tem bestiário</h1>
			<p className="mt-5 leading-7 text-[#e8ded1]">Os registros de ameaças deste arquivo pertencem a Ordem Paranormal. Selecione esse sistema para abrir o caderno.</p>
			<div className="mt-7 flex flex-wrap items-center gap-4">
				<RpgButton disabled={!ordem || selectSystem.isPending} loading={selectSystem.isPending} onClick={() => ordem && selectSystem.mutate({ activeSystemId: ordem.id })}>Selecionar Ordem Paranormal</RpgButton>
				{!ordem && <p role="alert" className="text-sm text-[#ffd0c8]">O sistema Ordem Paranormal não está cadastrado.</p>}
			</div>
			<div className="mt-5"><MutationFeedback error={selectSystem.error} success={selectSystem.isSuccess} /></div>
			</div>
		</section>
	);
}

