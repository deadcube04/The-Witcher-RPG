export function matchesName(name: string, search: string): boolean {
  const normalize = (value: string) => value.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLocaleLowerCase('pt-BR')
  return normalize(name).includes(normalize(search).trim())
}
