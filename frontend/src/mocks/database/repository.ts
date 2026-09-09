import { z } from "zod";
import { campaignSchema } from "../../shared/contracts/campaign";
import { characterSchema } from "../../shared/contracts/character-sheet";
import { preferencesSchema } from "../../shared/contracts/preferences";
import { systemSchema } from "../../shared/contracts/rpg-system";
import { userSchema } from "../../shared/contracts/user";
import { createSeed } from "../seed/seed";

const databaseSchema = z.strictObject({
	version: z.literal(1),
	user: userSchema,
	preferences: preferencesSchema,
	systems: z.array(systemSchema),
	campaigns: z.array(campaignSchema),
	characters: z.array(characterSchema),
});
export type MockDatabase = z.infer<typeof databaseSchema>;
type Persistence = Pick<Storage, "getItem" | "setItem">;
export const persistenceKey = "rpg-manager:mock:v1";
export class MockRepository {
	private readonly storage: Persistence;
	constructor(storage: Persistence) {
		this.storage = storage;
	}
	read(): MockDatabase {
		const saved = this.storage.getItem(persistenceKey);
		if (saved === null) {
			const seed = databaseSchema.parse(createSeed());
			this.storage.setItem(persistenceKey, JSON.stringify(seed));
			return seed;
		}
		const data: unknown = JSON.parse(saved);
		return databaseSchema.parse(data);
	}
	update(change: (state: MockDatabase) => MockDatabase): MockDatabase {
		const next = databaseSchema.parse(change(this.read()));
		this.storage.setItem(persistenceKey, JSON.stringify(next));
		return next;
	}
}
