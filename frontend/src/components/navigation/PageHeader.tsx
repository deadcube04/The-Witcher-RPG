import type { ReactNode } from "react";
import { PageMasthead } from "@/components/layout/ArchiveSurface";

export function PageHeader({
	eyebrow,
	title,
	description,
	actions,
}: {
	eyebrow: string;
	title: string;
	description?: string;
	actions?: ReactNode;
}) {
	return <PageMasthead eyebrow={eyebrow} title={title} description={description} actions={actions} />;
}
