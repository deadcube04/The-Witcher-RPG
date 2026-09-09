import { expect, test } from "vitest";
import { characterSheetRegistry } from "./registry";

test("definição desconhecida não herda regras de outro sistema", () => {
	expect(characterSheetRegistry.get("unknown")).toBeUndefined();
});
test("cada sistema cria dados válidos para a própria definição", () => {
	for (const slug of ["ordem-paranormal", "dnd", "witcher"]) {
		const definition = characterSheetRegistry.get(slug);
		expect(definition?.schema.safeParse(definition.createData()).success).toBe(
			true,
		);
	}
});
