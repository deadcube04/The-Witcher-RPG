import type { SheetEditorProps } from "../registry";
import { OrdemAttributes } from "./OrdemAttributes";
import { OrdemIdentity } from "./OrdemIdentity";
import { OrdemResources } from "./OrdemResources";
import { useQuery } from "@tanstack/react-query";
import { queries } from "@/shared/api/queries";

export function OrdemEditor({ value, onChange, disabled, campaign, supplementId, onSupplementChange, supplementRuleIds, onSupplementRulesChange }: SheetEditorProps) {
	const supplements = useQuery(queries.supplements);
	if (value.kind !== "ordem-paranormal") return null;
	const activeID = campaign ? campaign.settings.supplement?.id : supplementId;
	const selectedRuleIDs = campaign ? campaign.settings.supplement?.ruleIds ?? [] : supplementRuleIds ?? [];
	const determinationEnabled = value.progressionMode === "patent" || Boolean(supplements.data?.find((item) => item.id === activeID)?.rules.some((rule) => rule.slug === "jogando-sem-sanidade" && selectedRuleIDs.includes(rule.id)));
	return (
		<div className="space-y-8">
			<OrdemIdentity value={value} onChange={onChange} disabled={disabled} campaign={campaign} supplementId={supplementId} onSupplementChange={onSupplementChange} supplementRuleIds={supplementRuleIds} onSupplementRulesChange={onSupplementRulesChange} />
			<OrdemAttributes
				value={value.attributes}
				onChange={(attributes) => onChange({ ...value, attributes })}
				disabled={disabled}
			/>
			<OrdemResources
				value={value.resources}
				determinationEnabled={determinationEnabled}
				onChange={(resources) => onChange({ ...value, resources })}
				disabled={disabled}
			/>
		</div>
	);
}
