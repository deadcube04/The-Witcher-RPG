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
function record(value: unknown): Record<string, unknown> | null {
	return value !== null && typeof value === "object" && !Array.isArray(value) ? value as Record<string, unknown> : null;
}
function normalizeLegacy(value: unknown): unknown {
	const data = record(value);
	if (!data) return value;
	const systems = Array.isArray(data.systems) ? data.systems.map((entry: unknown) => {
		const system = record(entry);
		return system?.slug === "dnd" ? { ...system, slug: "dungeons-and-dragons" } : entry;
	}) : data.systems;
	const characters = Array.isArray(data.characters) ? data.characters.map((entry: unknown) => {
		const character = record(entry);
		const systemData = record(character?.systemData);
		if (!character || !systemData) return entry;
		if (systemData.kind === "dnd") return { ...character, systemData: { kind: "dungeons-and-dragons" } };
		if (systemData.kind !== "ordem-paranormal") return entry;
		const resources = record(systemData.resources);
		const normalizeResource = (resource: unknown) => {
			const r = record(resource);
			if (!r) return resource;
			return { ...r, baseMaximum: r.baseMaximum ?? r.maximum ?? 0, maxAdjustment: r.maxAdjustment ?? 0 };
		};
		return { ...character, systemData: { ...systemData, peLimit: systemData.peLimit ?? 0, resources: resources ? { health: normalizeResource(resources.health), effort: normalizeResource(resources.effort), sanity: normalizeResource(resources.sanity) } : systemData.resources } };
	}) : data.characters;
	return { ...data, systems, characters };
}
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
		const data: unknown = normalizeLegacy(JSON.parse(saved));
		const current = databaseSchema.safeParse(data);
		if (current.success) {
			if (JSON.stringify(data) !== saved) this.storage.setItem(persistenceKey, JSON.stringify(current.data));
			return current.data;
		}
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
