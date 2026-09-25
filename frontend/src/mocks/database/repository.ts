import { z } from "zod";
import { campaignSchema } from "@/shared/contracts/campaign";
import { characterSchema } from "@/shared/contracts/character-sheet";
import { characterAttackEntrySchema, ordemAttackDefinitionSchema } from "@/shared/contracts/ordem-attack";
import { characterInventoryEntrySchema, ordemInventoryDefinitionSchema } from "@/shared/contracts/ordem-inventory";
import { characterRitualEntrySchema, ordemRitualDefinitionSchema } from "@/shared/contracts/ordem-ritual";
import { preferencesSchema } from "@/shared/contracts/preferences";
import { systemSchema } from "@/shared/contracts/rpg-system";
import { userSchema } from "@/shared/contracts/user";
import { createSeed } from "@/mocks/seed/seed";

const sharedDatabaseFields = {
	user: userSchema,
	preferences: preferencesSchema,
	systems: z.array(systemSchema),
	campaigns: z.array(campaignSchema),
	characters: z.array(characterSchema),
};

const databaseV1Schema = z.strictObject({
	version: z.literal(1),
	...sharedDatabaseFields,
});

const databaseSchema = z.strictObject({
	version: z.literal(2),
	...sharedDatabaseFields,
	inventoryDefinitions: z.array(ordemInventoryDefinitionSchema),
	ritualDefinitions: z.array(ordemRitualDefinitionSchema),
	attackDefinitions: z.array(ordemAttackDefinitionSchema),
	characterInventoryEntries: z.array(characterInventoryEntrySchema),
	characterRitualEntries: z.array(characterRitualEntrySchema),
	characterAttackEntries: z.array(characterAttackEntrySchema),
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
		const current = databaseSchema.safeParse(data);
		if (current.success) return current.data;
		const previous = databaseV1Schema.safeParse(data);
		if (!previous.success) return databaseSchema.parse(data);
		const seed = createSeed();
		const migrated = databaseSchema.parse({
			...seed,
			version: 2,
			user: previous.data.user,
			preferences: previous.data.preferences,
			systems: previous.data.systems,
			campaigns: previous.data.campaigns,
			characters: previous.data.characters,
		});
		this.storage.setItem(persistenceKey, JSON.stringify(migrated));
		return migrated;
	}
	update(change: (state: MockDatabase) => MockDatabase): MockDatabase {
		const next = databaseSchema.parse(change(this.read()));
		this.storage.setItem(persistenceKey, JSON.stringify(next));
		return next;
	}
}
