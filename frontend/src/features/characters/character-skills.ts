export type ModifierAttribute = 'Agilidade' | 'Força' | 'Intelecto' | 'Presença' | 'Vigor'
export type CharacterSkill = {
  id: string
  name: string
  atributoModificador: ModifierAttribute
  treino: number
  outros: number
}

export const modifierOptions = ['Agilidade', 'Força', 'Intelecto', 'Presença', 'Vigor'].map((value) => ({ value, label: value }))
const mockSkills = [
  ['investigacao', 'Investigação', 'Intelecto'], ['intimidacao', 'Intimidação', 'Presença'], ['conducao', 'Condução', 'Agilidade'],
  ['medicina', 'Medicina', 'Intelecto'], ['arqueologia', 'Arqueologia', 'Intelecto'], ['ocultismo', 'Ocultismo', 'Intelecto'],
  ['percepcao', 'Percepção', 'Presença'], ['furtividade', 'Furtividade', 'Agilidade'], ['atletismo', 'Atletismo', 'Vigor'],
  ['historia', 'História', 'Intelecto'], ['persuasao', 'Persuasão', 'Presença'], ['sobrevivencia', 'Sobrevivência', 'Vigor'],
  ['tecnologia', 'Tecnologia', 'Intelecto'], ['enganacao', 'Enganação', 'Presença'],
] satisfies readonly (readonly [string, string, ModifierAttribute])[]

export function createMockSkills(): CharacterSkill[] {
  return mockSkills.map(([id, name, atributoModificador]) => ({ id, name, atributoModificador, treino: 0, outros: 0 }))
}
