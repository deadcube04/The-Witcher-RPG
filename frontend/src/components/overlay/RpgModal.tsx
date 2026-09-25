import { Modal } from "antd";
import type { ReactNode } from "react";

export function RpgModal({
	open,
	title,
	onClose,
	children,
	width = 720,
	footer = null,
	pending = false,
	afterClose,
}: {
	open: boolean;
	title: string;
	onClose: () => void;
	children: ReactNode;
	width?: number;
	footer?: ReactNode;
	pending?: boolean;
	afterClose?: () => void;
}) {
	return (
		<Modal
			open={open}
			title={title}
			width={width}
			footer={footer}
			destroyOnHidden
			focusTriggerAfterClose
			closable={!pending}
			keyboard={!pending}
			mask={{ closable: !pending }}
			onCancel={pending ? undefined : onClose}
			afterOpenChange={(nextOpen) => {
				if (!nextOpen) afterClose?.();
			}}
		>
			<div className="max-h-[72vh] overflow-y-auto py-4 pr-1">{children}</div>
		</Modal>
	);
}
