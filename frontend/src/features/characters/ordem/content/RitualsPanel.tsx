import { AnimatePresence, motion, useReducedMotion } from "motion/react";
import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import {
	RpgEmptyState,
	RpgErrorState,
	RpgSkeleton,
} from "@/components/feedback/RemoteState";
import { useRpgRollFeedback } from "@/components/feedback/RpgRollFeedback";
import { RpgModal } from "@/components/overlay/RpgModal";
import { RpgConfirmDialog } from "@/components/overlay/RpgConfirmDialog";
import { RpgButton } from "@/components/primitives/RpgControls";
import { parseDiceExpression, rollDice } from "@/features/dice/roll";
import { ritualApi } from "@/shared/api/domains";
import { keys, queries, useDomainMutation } from "@/shared/api/queries";
import type {
	OrdemRitualDefinition,
	OrdemRitualInput,
} from "@/shared/contracts/ordem-ritual";
import { CatalogPickerModal } from "@/features/characters/ordem/content/CatalogPickerModal";
import { ContentPanelHeader } from "@/features/characters/ordem/content/ContentPanelHeader";
import { RitualCard } from "@/features/characters/ordem/content/RitualCard";
import { RitualForm } from "@/features/characters/ordem/content/RitualForm";
import { emptyRitualInput } from "@/features/characters/ordem/content/content-defaults";
import {
	ritualElementLabel,
	ritualElementOptions,
} from "@/features/characters/ordem/content/content-options";
import { matchesName } from "@/shared/lib/search";

type EditorState = {
	definition: OrdemRitualDefinition;
	entryId: string | null;
	mode: "edit" | "duplicate";
};

function toInput(definition: OrdemRitualDefinition): OrdemRitualInput {
	return {
		name: definition.name,
		description: definition.description,
		element: definition.element,
		circle: definition.circle,
		execution: definition.execution,
		rangeText: definition.rangeText,
		targetText: definition.targetText,
		areaText: definition.areaText,
		durationText: definition.durationText,
		resistanceText: definition.resistanceText,
		tiers: definition.tiers,
	};
}

export function RitualsPanel({ characterId }: { characterId: string }) {
	const reduced = useReducedMotion();
	const feedback = useRpgRollFeedback();
	const [query, setQuery] = useState("");
	const [element, setElement] = useState("all");
	const [catalogQuery, setCatalogQuery] = useState("");
	const [catalogOpen, setCatalogOpen] = useState(false);
	const [expandedId, setExpandedId] = useState<string | null>(null);
	const [editor, setEditor] = useState<EditorState | null>(null);
	const [deleteDefinition, setDeleteDefinition] =
		useState<OrdemRitualDefinition | null>(null);
	const rituals = useQuery(queries.rituals(characterId));
	const catalog = useQuery({
		...queries.ritualCatalog(catalogQuery),
		enabled: catalogOpen,
	});
	const domains = [
		keys.rituals(characterId),
		["ordem", "catalog", "rituals"] as const,
	];
	const add = useDomainMutation(
		(definitionId: string) => ritualApi.add(characterId, definitionId),
		domains,
	);
	const updateEntry = useDomainMutation(
		(input: { entryId: string; definitionId?: string; notes?: string }) =>
			ritualApi.updateEntry(characterId, input.entryId, {
				definitionId: input.definitionId,
				notes: input.notes,
			}),
		[keys.rituals(characterId)],
	);
	const removeEntry = useDomainMutation(
		(entryId: string) => ritualApi.removeEntry(characterId, entryId),
		[keys.rituals(characterId)],
	);
	const createHomebrew = useDomainMutation(ritualApi.createHomebrew, domains);
	const updateHomebrew = useDomainMutation(
		(input: { id: string; value: OrdemRitualInput }) =>
			ritualApi.updateHomebrew(input.id, input.value),
		domains,
	);
	const removeHomebrew = useDomainMutation(ritualApi.removeHomebrew, domains);
	const pending =
		add.isPending ||
		updateEntry.isPending ||
		removeEntry.isPending ||
		createHomebrew.isPending ||
		updateHomebrew.isPending ||
		removeHomebrew.isPending;
	const mutationError =
		add.error ??
		updateEntry.error ??
		removeEntry.error ??
		createHomebrew.error ??
		updateHomebrew.error ??
		removeHomebrew.error;
	const visible = (rituals.data ?? []).filter((ritual) => {
		return (
			matchesName(ritual.definition.name, query) &&
			(element === "all" || ritual.definition.element === element)
		);
	});
	const roll = (label: string, expression: string) => {
		const input = parseDiceExpression(expression);
		if (input) feedback.show(label, rollDice(input));
	};
	const saveNew = async (input: OrdemRitualInput) => {
		const definition = await createHomebrew.mutateAsync(input);
		await add.mutateAsync(definition.id);
		setCatalogOpen(false);
	};
	const saveEditor = async (input: OrdemRitualInput) => {
		if (!editor) return;
		if (editor.mode === "edit") {
			await updateHomebrew.mutateAsync({
				id: editor.definition.id,
				value: input,
			});
		} else {
			const definition = await createHomebrew.mutateAsync(input);
			if (editor.entryId)
				await updateEntry.mutateAsync({
					entryId: editor.entryId,
					definitionId: definition.id,
				});
		}
		setEditor(null);
	};

	if (rituals.isPending) return <RpgSkeleton />;
	if (rituals.isError)
		return (
			<RpgErrorState
				error={rituals.error}
				retry={() => void rituals.refetch()}
			/>
		);
	return (
		<div>
			{feedback.holder}
			<ContentPanelHeader
				count={rituals.data.length}
				query={query}
				onQueryChange={setQuery}
				filter={element}
				onFilterChange={setElement}
				filterLabel="Elemento"
				filterOptions={ritualElementOptions}
				onAdd={() => setCatalogOpen(true)}
			/>
			{mutationError ? (
				<p role="alert" className="mb-4 border-l-2 border-red-400 pl-3 text-sm">
					{mutationError.message}
				</p>
			) : null}
			{visible.length === 0 ? (
				<RpgEmptyState
					title={
						rituals.data.length === 0
							? "Nenhum ritual conhecido"
							: "Nenhum ritual encontrado"
					}
				>
					<p className="text-sm opacity-70">
						Adicione um ritual do catálogo ou registre um homebrew.
					</p>
				</RpgEmptyState>
			) : (
				<motion.div layout={!reduced} className="space-y-3">
					<AnimatePresence initial={false}>
						{visible.map((ritual) => (
							<motion.div
								key={ritual.entry.id}
								layout={!reduced}
								initial={reduced ? false : { opacity: 0, x: 16 }}
								animate={{ opacity: 1, x: 0 }}
								exit={reduced ? undefined : { opacity: 0, x: 16 }}
							>
								<RitualCard
									ritual={ritual}
									expanded={expandedId === ritual.entry.id}
									pending={pending}
									onToggle={() =>
										setExpandedId((current) =>
											current === ritual.entry.id ? null : ritual.entry.id,
										)
									}
									onRoll={roll}
									onNotesChange={(notes) =>
										updateEntry.mutate({ entryId: ritual.entry.id, notes })
									}
									onEditDefinition={() =>
										setEditor({
											definition: ritual.definition,
											entryId: ritual.entry.id,
											mode:
												ritual.definition.source.kind === "official"
													? "duplicate"
													: "edit",
										})
									}
									onRemove={() => removeEntry.mutate(ritual.entry.id)}
								/>
							</motion.div>
						))}
					</AnimatePresence>
				</motion.div>
			)}
			<CatalogPickerModal
				open={catalogOpen}
				title="Adicionar ritual"
				query={catalogQuery}
				onQueryChange={setCatalogQuery}
				items={catalog.data ?? []}
				loading={catalog.isPending}
				error={catalog.error}
				actionError={add.error ?? removeHomebrew.error}
				pending={pending}
				onRetry={() => void catalog.refetch()}
				onAdd={(definition) =>
					add.mutate(definition.id, { onSuccess: () => setCatalogOpen(false) })
				}
				renderMeta={(definition) =>
					`${definition.circle}º círculo · ${ritualElementLabel(definition.element)}`
				}
				renderActions={(definition) => (
					<>
						<RpgButton
							secondary
							disabled={pending}
							onClick={() => {
								setCatalogOpen(false);
								setEditor({ definition, entryId: null, mode: "edit" });
							}}
						>
							Editar
						</RpgButton>
						<RpgButton
							danger
							disabled={pending}
							onClick={() => setDeleteDefinition(definition)}
						>
							Excluir do catálogo
						</RpgButton>
					</>
				)}
				createForm={
					<RitualForm
						initial={emptyRitualInput}
						pending={pending}
						error={createHomebrew.error}
						onSave={saveNew}
					/>
				}
				onClose={() => setCatalogOpen(false)}
			/>
			<RpgModal
				open={editor !== null}
				title={
					editor?.mode === "duplicate"
						? "Duplicar como homebrew"
						: "Editar homebrew"
				}
				onClose={() => setEditor(null)}
				pending={pending}
			>
				{editor ? (
					<>
						<p className="mb-5 border-l-2 border-(--accent) pl-3 text-sm">
							{editor.mode === "edit"
								? "Esta alteração será refletida em todas as fichas que usam este homebrew."
								: "A cópia será adicionada ao seu catálogo pessoal e substituirá apenas este ritual da ficha."}
						</p>
						<RitualForm
							initial={toInput(editor.definition)}
							pending={pending}
							error={mutationError}
							onSave={saveEditor}
							submitLabel={
								editor.mode === "duplicate"
									? "Criar cópia"
									: "Salvar alterações"
							}
						/>
					</>
				) : null}
			</RpgModal>
			<RpgConfirmDialog
				open={deleteDefinition !== null}
				title="Excluir homebrew do catálogo?"
				description={`“${deleteDefinition?.name ?? "Este ritual"}” deixará de aparecer no seu catálogo pessoal. A exclusão será bloqueada se alguma ficha ainda usar o conteúdo.`}
				pending={removeHomebrew.isPending}
				onCancel={() => setDeleteDefinition(null)}
				onConfirm={() => {
					if (!deleteDefinition) return;
					removeHomebrew.mutate(deleteDefinition.id, {
						onSuccess: () => setDeleteDefinition(null),
					});
				}}
				error={removeHomebrew.error?.message}
			/>
		</div>
	);
}
