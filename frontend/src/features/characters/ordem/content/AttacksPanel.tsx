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
import {
	parseDiceExpression,
	rollDice,
	rollOrdemTest,
} from "@/features/dice/roll";
import { attackApi } from "@/shared/api/domains";
import { keys, queries, useDomainMutation } from "@/shared/api/queries";
import type {
	OrdemAttackDefinition,
	OrdemAttackInput,
} from "@/shared/contracts/ordem-attack";
import { AttackCard } from "@/features/characters/ordem/content/AttackCard";
import { AttackForm } from "@/features/characters/ordem/content/AttackForm";
import { emptyAttackInput } from "@/features/characters/ordem/content/content-defaults";
import { CatalogPickerModal } from "@/features/characters/ordem/content/CatalogPickerModal";
import { ContentPanelHeader } from "@/features/characters/ordem/content/ContentPanelHeader";
import { matchesName } from "@/shared/lib/search";

type EditorState = {
	definition: OrdemAttackDefinition;
	entryId: string | null;
	mode: "edit" | "duplicate";
};

function toInput(definition: OrdemAttackDefinition): OrdemAttackInput {
	return {
		name: definition.name,
		description: definition.description,
		skillId: definition.skillId ?? null,
		skillName: definition.skillName,
		testExpression: definition.testExpression ?? "",
		damageExpression: definition.damageExpression,
		damageType: definition.damageType,
		criticalThreshold: definition.criticalThreshold ?? 20,
		criticalMultiplier: definition.criticalMultiplier ?? 2,
		rangeText: definition.rangeText,
		special: definition.special,
		sourceItemDefinitionId: definition.sourceItemDefinitionId,
	};
}

const sourceOptions = [
	{ value: "all", label: "Todas as origens" },
	{ value: "linked", label: "Vinculados a armas" },
	{ value: "independent", label: "Independentes" },
	{ value: "homebrew", label: "Homebrew" },
];

export function AttacksPanel({ characterId }: { characterId: string }) {
	const reduced = useReducedMotion();
	const feedback = useRpgRollFeedback();
	const [query, setQuery] = useState("");
	const [source, setSource] = useState("all");
	const [catalogQuery, setCatalogQuery] = useState("");
	const [catalogOpen, setCatalogOpen] = useState(false);
	const [expandedId, setExpandedId] = useState<string | null>(null);
	const [editor, setEditor] = useState<EditorState | null>(null);
	const [deleteDefinition, setDeleteDefinition] =
		useState<OrdemAttackDefinition | null>(null);
	const attacks = useQuery(queries.attacks(characterId));
	const catalog = useQuery({
		...queries.attackCatalog(catalogQuery),
		enabled: catalogOpen,
	});
	const domains = [
		keys.attacks(characterId),
		["ordem", "catalog", "attacks"] as const,
	];
	const add = useDomainMutation(
		(definitionId: string) => attackApi.add(characterId, definitionId),
		domains,
	);
	const updateEntry = useDomainMutation(
		(input: { entryId: string; definitionId?: string; notes?: string }) =>
			attackApi.updateEntry(characterId, input.entryId, {
				definitionId: input.definitionId,
				notes: input.notes,
			}),
		[keys.attacks(characterId)],
	);
	const removeEntry = useDomainMutation(
		(entryId: string) => attackApi.removeEntry(characterId, entryId),
		[keys.attacks(characterId), keys.inventory(characterId)],
	);
	const createHomebrew = useDomainMutation(attackApi.createHomebrew, domains);
	const updateHomebrew = useDomainMutation(
		(input: { id: string; value: OrdemAttackInput }) =>
			attackApi.updateHomebrew(input.id, input.value),
		domains,
	);
	const removeHomebrew = useDomainMutation(attackApi.removeHomebrew, domains);
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
	const visible = (attacks.data ?? []).filter((attack) => {
		const matchesSource =
			source === "all" ||
			(source === "linked" && attack.sourceInventory !== null) ||
			(source === "independent" && attack.sourceInventory === null) ||
			(source === "homebrew" && attack.definition.source.kind === "homebrew");
		return matchesName(attack.definition.name, query) && matchesSource;
	});
	const roll = (label: string, expression: string) => {
		const input = parseDiceExpression(expression);
		if (input) feedback.show(label, rollDice(input));
	};
	const saveNew = async (input: OrdemAttackInput) => {
		const definition = await createHomebrew.mutateAsync(input);
		await add.mutateAsync(definition.id);
		setCatalogOpen(false);
	};
	const saveEditor = async (input: OrdemAttackInput) => {
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

	if (attacks.isPending) return <RpgSkeleton />;
	if (attacks.isError)
		return (
			<RpgErrorState
				error={attacks.error}
				retry={() => void attacks.refetch()}
			/>
		);
	return (
		<div>
			{feedback.holder}
			<ContentPanelHeader
				count={attacks.data.length}
				query={query}
				onQueryChange={setQuery}
				filter={source}
				onFilterChange={setSource}
				filterLabel="Origem"
				filterOptions={sourceOptions}
				onAdd={() => setCatalogOpen(true)}
			/>
			{mutationError ? (
				<p
					role="alert"
					className="mb-4 border-l-2 border-(--danger) pl-3 text-sm"
				>
					{mutationError.message}
				</p>
			) : null}
			{visible.length === 0 ? (
				<RpgEmptyState
					title={
						attacks.data.length === 0
							? "Nenhum ataque preparado"
							: "Nenhum ataque encontrado"
					}
				>
					<p className="text-sm opacity-70">
						Adicione um ataque do catálogo ou crie um homebrew.
					</p>
				</RpgEmptyState>
			) : (
				<motion.div layout={!reduced} className="space-y-3">
					<AnimatePresence initial={false}>
						{visible.map((attack) => (
							<motion.div
								key={attack.entry.id}
								layout={!reduced}
								initial={reduced ? false : { opacity: 0, x: 16 }}
								animate={{ opacity: 1, x: 0 }}
								exit={reduced ? undefined : { opacity: 0, x: 16 }}
							>
								<AttackCard
									attack={attack}
									expanded={expandedId === attack.entry.id}
									pending={pending}
									onToggle={() =>
										setExpandedId((current) =>
											current === attack.entry.id ? null : attack.entry.id,
										)
									}
									onRoll={roll}
									onTestRoll={() => {
										if (attack.test)
											feedback.show(
												`Ataque · ${attack.definition.name}`,
												rollOrdemTest(attack.test),
											);
									}}
									onNotesChange={(notes) =>
										updateEntry.mutate({ entryId: attack.entry.id, notes })
									}
									onEditDefinition={() =>
										setEditor({
											definition: attack.definition,
											entryId: attack.entry.id,
											mode:
												attack.definition.source.kind === "official"
													? "duplicate"
													: "edit",
										})
									}
									onRemove={() => removeEntry.mutate(attack.entry.id)}
								/>
							</motion.div>
						))}
					</AnimatePresence>
				</motion.div>
			)}
			<CatalogPickerModal
				open={catalogOpen}
				title="Adicionar ataque"
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
					`${definition.skillName} · ${definition.damageExpression}`
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
					<AttackForm
						initial={emptyAttackInput}
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
								: "A cópia será adicionada ao seu catálogo pessoal e substituirá apenas este ataque da ficha."}
						</p>
						<AttackForm
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
				description={`“${deleteDefinition?.name ?? "Este ataque"}” deixará de aparecer no seu catálogo pessoal. A exclusão será bloqueada se alguma ficha ainda usar o conteúdo.`}
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
