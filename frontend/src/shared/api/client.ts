import type { ZodType } from "zod";
import { apiErrorSchema, type ErrorCode } from "../contracts/api-error";

const messages: Record<ErrorCode, string> = {
	INVALID_REQUEST: "Confira os campos informados.",
	USER_NOT_FOUND: "Perfil não encontrado.",
	CAMPAIGN_NOT_FOUND: "Campanha não encontrada.",
	CHARACTER_NOT_FOUND: "Ficha não encontrada.",
	RPG_SYSTEM_NOT_FOUND: "Sistema não encontrado.",
	SYSTEM_MISMATCH: "A ficha e a campanha precisam usar o mesmo sistema.",
	CONFLICT: "Esta alteração conflita com os dados existentes.",
	INTERNAL_ERROR: "Não foi possível concluir a operação.",
};
export class ApiError extends Error {
	readonly code: ErrorCode;
	constructor(code: ErrorCode) {
		super(messages[code]);
		this.name = "ApiError";
		this.code = code;
	}
}
export async function request<T>(
	path: string,
	schema: ZodType<T>,
	init: RequestInit = {},
): Promise<T> {
	const response = await fetch(
		new URL(`/api/v1${path}`, window.location.origin),
		{
			...init,
			headers: {
				Accept: "application/json",
				...(init.body ? { "Content-Type": "application/json" } : {}),
				...init.headers,
			},
		},
	);
	const payload: unknown =
		response.status === 204
			? undefined
			: await response.json().catch(() => undefined);
	if (!response.ok) {
		const parsed = apiErrorSchema.safeParse(payload);
		throw new ApiError(
			parsed.success ? parsed.data.error.code : "INTERNAL_ERROR",
		);
	}
	const parsed = schema.safeParse(payload);
	if (!parsed.success) throw new Error("Resposta inválida. Tente novamente.");
	return parsed.data;
}
