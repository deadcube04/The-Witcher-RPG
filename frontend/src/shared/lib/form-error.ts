export function fieldError(errors: readonly unknown[]): string | undefined {
	return (
		errors
			.map((error) =>
				typeof error === "string"
					? error
					: error &&
							typeof error === "object" &&
							"message" in error &&
							typeof error.message === "string"
						? error.message
						: "",
			)
			.filter(Boolean)
			.join(" ") || undefined
	);
}
