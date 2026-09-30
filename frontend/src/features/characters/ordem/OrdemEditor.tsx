import type { SheetEditorProps } from "../registry";
import { OrdemAttributes } from "./OrdemAttributes";
import { OrdemIdentity } from "./OrdemIdentity";
import { OrdemResources } from "./OrdemResources";

export function OrdemEditor({ value, onChange, disabled, campaign }: SheetEditorProps) {
	if (value.kind !== "ordem-paranormal") return null;
	return (
		<div className="space-y-8">
			<OrdemIdentity value={value} onChange={onChange} disabled={disabled} campaign={campaign} />
			<OrdemAttributes
				value={value.attributes}
				onChange={(attributes) => onChange({ ...value, attributes })}
				disabled={disabled}
			/>
			<OrdemResources
				value={value.resources}
				onChange={(resources) => onChange({ ...value, resources })}
				disabled={disabled}
			/>
		</div>
	);
}
