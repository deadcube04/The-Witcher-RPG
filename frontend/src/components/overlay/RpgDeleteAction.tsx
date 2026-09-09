import { Button, Dropdown } from "antd";
import { useState } from "react";
import { RpgButton } from "../primitives/RpgControls";
import { RpgConfirmDialog } from "./RpgConfirmDialog";

export function RpgDeleteAction({
	name,
	description,
	onDelete,
	menuLabel,
}: {
	name: string;
	description: string;
	onDelete: () => Promise<void>;
	menuLabel?: string;
}) {
	const [open, setOpen] = useState(false);
	const [menuOpen, setMenuOpen] = useState(false);
	const [pending, setPending] = useState(false);
	const [error, setError] = useState<string | null>(null);
	async function confirm() {
		setPending(true);
		setError(null);
		try {
			await onDelete();
			setOpen(false);
		} catch (cause: unknown) {
			setError(
				cause instanceof Error ? cause.message : "Não foi possível excluir.",
			);
		} finally {
			setPending(false);
		}
	}
	return (
		<>
			{menuLabel ? (
				<Dropdown
					trigger={["click"]}
					placement="bottomRight"
					open={menuOpen}
					onOpenChange={setMenuOpen}
					menu={{
						items: [{ key: "delete", label: "Excluir", danger: true }],
						onClick: () => {
							setMenuOpen(false);
							setOpen(true);
						},
					}}
				>
					<Button
						type="text"
						aria-label={menuLabel}
						aria-haspopup="menu"
						aria-expanded={menuOpen}
						className="size-11! shrink-0! rounded-sm! text-xl! text-(--ink)! focus-visible:outline-2! focus-visible:outline-(--accent)!"
					>
						⋯
					</Button>
				</Dropdown>
			) : (
				<RpgButton secondary danger onClick={() => setOpen(true)}>
					Excluir
				</RpgButton>
			)}
			<RpgConfirmDialog
				open={open}
				title={`Excluir ${name}?`}
				description={description}
				pending={pending}
				onCancel={() => setOpen(false)}
				onConfirm={() => void confirm()}
				error={error}
			/>
		</>
	);
}
