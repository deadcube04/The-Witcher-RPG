import { screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { expect, test, vi } from "vitest";
import { ordemId, systems } from "../../mocks/seed/seed";
import { renderFeature } from "../../test/render";
import { CampaignForm } from "./CampaignForm";

test("valida nome antes de entregar uma campanha para gravação", async () => {
	const save = vi.fn(async () => undefined);
	renderFeature(
		<CampaignForm
			initial={{
				name: "",
				description: "",
				systemId: ordemId,
				status: "active",
			}}
			systems={systems}
			pending={false}
			error={null}
			onSave={save}
		/>,
	);
	await userEvent.click(
		screen.getByRole("button", { name: "Salvar campanha" }),
	);
	expect(save).not.toHaveBeenCalled();
	await userEvent.type(screen.getByLabelText("Nome da campanha"), "Novo caso");
	await userEvent.click(
		screen.getByRole("button", { name: "Salvar campanha" }),
	);
	expect(save).toHaveBeenCalledWith({
		name: "Novo caso",
		description: "",
		systemId: ordemId,
		status: "active",
	});
});
