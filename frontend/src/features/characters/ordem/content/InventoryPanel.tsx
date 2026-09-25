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
import { attackApi, inventoryApi } from "@/shared/api/domains";
import { keys, queries, useDomainMutation } from "@/shared/api/queries";
import type {
	CharacterInventoryItem,
	InventoryEntryPatch,
	OrdemInventoryDefinition,
	OrdemInventoryInput,
} from "@/shared/contracts/ordem-inventory";
import { CatalogPickerModal } from "@/features/characters/ordem/content/CatalogPickerModal";
import { ContentPanelHeader } from "@/features/characters/ordem/content/ContentPanelHeader";
import { InventoryCard } from "@/features/characters/ordem/content/InventoryCard";
import { InventoryForm } from "@/features/characters/ordem/content/InventoryForm";
import { emptyInventoryInput } from "@/features/characters/ordem/content/content-defaults";
import {
	inventoryKindLabel,
	inventoryKindOptions,
} from "@/features/characters/ordem/content/content-options";
import { parseDiceExpression, rollDice } from "@/features/dice/roll";
import { matchesName } from "@/shared/lib/search";

type EditorState = {
	definition: OrdemInventoryDefinition;
	entryId: string | null;
	mode: "edit" | "duplicate";
};

function toInput(definition: OrdemInventoryDefinition): OrdemInventoryInput {
	const base = {
		name: definition.name,
		description: definition.description,
		category: definition.category,
		spaces: definition.spaces,
	};
	if (definition.kind === "weapon") {
		return {
			...base,
			kind: "weapon",
			damageExpression: definition.damageExpression,
			criticalThreshold: definition.criticalThreshold,
			criticalMultiplier: definition.criticalMultiplier,
			rangeText: definition.rangeText,
			damageType: definition.damageType,
		};
	}
	return { ...base, kind: definition.kind };
}

export function InventoryPanel({ characterId }: { characterId: string }) {
	const reduced = useReducedMotion();
	const feedback = useRpgRollFeedback();
	const [query, setQuery] = useState("");
	const [kind, setKind] = useState("all");
	const [catalogQuery, setCatalogQuery] = useState("");
	const [catalogOpen, setCatalogOpen] = useState(false);
	const [expandedId, setExpandedId] = useState<string | null>(null);
	const [editor, setEditor] = useState<EditorState | null>(null);
	const [removeTarget, setRemoveTarget] =
		useState<CharacterInventoryItem | null>(null);
	const [deleteDefinition, setDeleteDefinition] =
		useState<OrdemInventoryDefinition | null>(null);
	const inventory = useQuery(queries.inventory(characterId));
	const catalog = useQuery({
		...queries.inventoryCatalog(catalogQuery),
		enabled: catalogOpen,
	});
	const domains = [
		keys.inventory(characterId),
		["ordem", "catalog", "inventory"] as const,
	];
	const add = useDomainMutation(
		(definitionId: string) => inventoryApi.add(characterId, definitionId),
		domains,
	);
	const updateEntry = useDomainMutation(
		(input: { entryId: string; patch: InventoryEntryPatch }) =>
			inventoryApi.updateEntry(characterId, input.entryId, input.patch),
		[keys.inventory(characterId), keys.attacks(characterId)],
	);
	const removeEntry = useDomainMutation(
		(input: { entryId: string; attackPolicy?: "detach" | "remove" }) =>
			inventoryApi.removeEntry(characterId, input.entryId, input.attackPolicy),
		[keys.inventory(characterId), keys.attacks(characterId)],
	);
	const createHomebrew = useDomainMutation(
		inventoryApi.createHomebrew,
		domains,
	);
	const updateHomebrew = useDomainMutation(
		(input: { id: string; value: OrdemInventoryInput }) =>
			inventoryApi.updateHomebrew(input.id, input.value),
		domains,
	);
	const removeHomebrew = useDomainMutation(
		inventoryApi.removeHomebrew,
		domains,
	);
	const addAttack = useDomainMutation(
		(entryId: string) => attackApi.addFromInventory(characterId, entryId),
		[keys.attacks(characterId), keys.inventory(characterId)],
	);

	const pending =
		add.isPending ||
		updateEntry.isPending ||
		removeEntry.isPending ||
		createHomebrew.isPending ||
		updateHomebrew.isPending ||
		removeHomebrew.isPending ||
		addAttack.isPending;
	const mutationError =
		add.error ??
		updateEntry.error ??
		removeEntry.error ??
		createHomebrew.error ??
		updateHomebrew.error ??
		removeHomebrew.error ??
		addAttack.error;
	const visible = (inventory.data ?? []).filter((item) => {
		return (
			matchesName(item.definition.name, query) &&
			(kind === "all" || item.definition.kind === kind)
		);
	});

	const saveNew = async (input: OrdemInventoryInput) => {
		const definition = await createHomebrew.mutateAsync(input);
		await add.mutateAsync(definition.id);
		setCatalogOpen(false);
	};
	const saveEditor = async (input: OrdemInventoryInput) => {
		if (!editor) return;
		if (editor.mode === "edit") {
			await updateHomebrew.mutateAsync({
				id: editor.definition.id,
				value: input,
			});
		} else {
			const definition = await createHomebrew.mutateAsync(input);
			if (editor.entryId) {
				await updateEntry.mutateAsync({
					entryId: editor.entryId,
					patch: { definitionId: definition.id },
				});
			}
		}
		setEditor(null);
	};

	if (inventory.isPending) return <RpgSkeleton />;
	if (inventory.isError)
		return (
			<RpgErrorState
				error={inventory.error}
				retry={() => void inventory.refetch()}
			/>
		);
	return (
		<div>
			{feedback.holder}
			<ContentPanelHeader
				count={inventory.data.length}
				query={query}
				onQueryChange={setQuery}
				filter={kind}
				onFilterChange={setKind}
				filterLabel="Tipo"
				filterOptions={inventoryKindOptions}
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
						inventory.data.length === 0
							? "Inventário vazio"
							: "Nenhum item encontrado"
					}
				>
					<p className="text-sm opacity-70">
						Adicione conteúdo do catálogo ou crie um item homebrew.
					</p>
				</RpgEmptyState>
			) : (
				<motion.div layout={!reduced} className="space-y-3">
					<AnimatePresence initial={false}>
						{visible.map((item) => (
							<motion.div
								key={item.entry.id}
								layout={!reduced}
								initial={reduced ? false : { opacity: 0, x: 16 }}
								animate={{ opacity: 1, x: 0 }}
								exit={reduced ? undefined : { opacity: 0, x: 16 }}
							>
								<InventoryCard
									item={item}
									expanded={expandedId === item.entry.id}
									pending={pending}
									onToggle={() =>
										setExpandedId((current) =>
											current === item.entry.id ? null : item.entry.id,
										)
									}
									onUpdate={(patch) =>
										updateEntry.mutate({ entryId: item.entry.id, patch })
									}
									onRemove={() =>
										item.linkedAttackCount > 0
											? setRemoveTarget(item)
											: removeEntry.mutate({ entryId: item.entry.id })
									}
									onCreateAttack={() => addAttack.mutate(item.entry.id)}
									onEditDefinition={() =>
										setEditor({
											definition: item.definition,
											entryId: item.entry.id,
											mode:
												item.definition.source.kind === "official"
													? "duplicate"
													: "edit",
										})
									}
									onRoll={(label, expression) => {
										const input = parseDiceExpression(expression);
										if (input) feedback.show(label, rollDice(input));
									}}
								/>
							</motion.div>
						))}
					</AnimatePresence>
				</motion.div>
			)}
			<CatalogPickerModal
				open={catalogOpen}
				title="Adicionar item"
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
					`${inventoryKindLabel(definition.kind)} · ${definition.spaces} espaço(s)`
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
					<InventoryForm
						initial={emptyInventoryInput}
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
								: "A cópia será adicionada ao seu catálogo pessoal e substituirá apenas este registro da ficha."}
						</p>
						<InventoryForm
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
			<RpgModal
				open={removeTarget !== null}
				title="Remover arma vinculada"
				onClose={() => setRemoveTarget(null)}
				pending={removeEntry.isPending}
			>
				<p className="mb-5 text-sm leading-6">
					Esta arma possui ataque vinculado. Escolha o que fazer com esse
					ataque.
				</p>
				<div className="flex flex-wrap gap-3">
					<RpgButton
						secondary
						disabled={removeEntry.isPending}
						onClick={() => {
							if (!removeTarget) return;
							removeEntry.mutate(
								{ entryId: removeTarget.entry.id, attackPolicy: "detach" },
								{ onSuccess: () => setRemoveTarget(null) },
							);
						}}
					>
						Manter ataque sem vínculo
					</RpgButton>
					<RpgButton
						danger
						disabled={removeEntry.isPending}
						onClick={() => {
							if (!removeTarget) return;
							removeEntry.mutate(
								{ entryId: removeTarget.entry.id, attackPolicy: "remove" },
								{ onSuccess: () => setRemoveTarget(null) },
							);
						}}
					>
						Remover arma e ataque
					</RpgButton>
				</div>
			</RpgModal>
			<RpgConfirmDialog
				open={deleteDefinition !== null}
				title="Excluir homebrew do catálogo?"
				description={`“${deleteDefinition?.name ?? "Este item"}” deixará de aparecer no seu catálogo pessoal. A exclusão será bloqueada se alguma ficha ainda usar o conteúdo.`}
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
