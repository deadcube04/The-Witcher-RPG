import { z } from "zod";
import type { CampaignSelection } from "@/shared/contracts/campaign";

const storageKey = "campaign-creation-draft-v1";
const databaseName = "nexus-campaign-drafts";
const objectStore = "covers";

const selectionSchema = z.strictObject({
	mode: z.enum(["all", "selected"]),
	allowedIds: z.array(z.uuid()),
});
const draftSchema = z.strictObject({
	id: z.uuid(),
	step: z.enum(["core", "settings"]),
	systemId: z.string(),
	name: z.string(),
	description: z.string(),
	sheetMode: z.enum(["", "guided", "free"]),
	classes: selectionSchema,
	origins: selectionSchema,
	uploadedCoverUrl: z.string(),
});

export type CampaignDraft = {
	id: string;
	step: "core" | "settings";
	systemId: string;
	name: string;
	description: string;
	sheetMode: "" | "guided" | "free";
	classes: CampaignSelection;
	origins: CampaignSelection;
	uploadedCoverUrl: string;
};

export function newCampaignDraft(systemId: string): CampaignDraft {
	return {
		id: crypto.randomUUID(), step: "core", systemId, name: "", description: "",
		sheetMode: "", classes: { mode: "all", allowedIds: [] },
		origins: { mode: "all", allowedIds: [] }, uploadedCoverUrl: "",
	};
}

export function readCampaignDraft(): CampaignDraft | null {
	try {
		const raw = sessionStorage.getItem(storageKey);
		if (!raw) return null;
		const parsed = draftSchema.safeParse(JSON.parse(raw));
		return parsed.success ? parsed.data : null;
	} catch { return null; }
}

export function saveCampaignDraft(draft: CampaignDraft): void {
	try { sessionStorage.setItem(storageKey, JSON.stringify(draft)); } catch { /* Storage may be unavailable. */ }
}

export function clearCampaignDraft(): void {
	try { sessionStorage.removeItem(storageKey); } catch { /* Storage may be unavailable. */ }
}

function openCoverStore(): Promise<IDBDatabase> {
	return new Promise((resolve, reject) => {
		const request = indexedDB.open(databaseName, 1);
		request.onupgradeneeded = () => request.result.createObjectStore(objectStore);
		request.onsuccess = () => resolve(request.result);
		request.onerror = () => reject(request.error);
	});
}

export async function readDraftCover(id: string): Promise<Blob | null> {
	const db = await openCoverStore();
	try {
		return await new Promise<Blob | null>((resolve, reject) => {
			const request = db.transaction(objectStore, "readonly").objectStore(objectStore).get(id);
			request.onsuccess = () => resolve(request.result instanceof Blob ? request.result : null);
			request.onerror = () => reject(request.error);
		});
	} finally { db.close(); }
}

export async function saveDraftCover(id: string, cover: Blob | null): Promise<void> {
	const db = await openCoverStore();
	try {
		await new Promise<void>((resolve, reject) => {
			const transaction = db.transaction(objectStore, "readwrite");
			if (cover) transaction.objectStore(objectStore).put(cover, id);
			else transaction.objectStore(objectStore).delete(id);
			transaction.oncomplete = () => resolve();
			transaction.onerror = () => reject(transaction.error);
		});
	} finally { db.close(); }
}
