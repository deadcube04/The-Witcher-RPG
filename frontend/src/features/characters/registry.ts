import { z } from 'zod'
import type { ComponentType } from 'react'
import { ordemDataSchema, type CharacterInput } from '../../shared/contracts/character-sheet'
import { createOrdemData } from '../../shared/contracts/defaults'
import { OrdemEditor } from './ordem/OrdemEditor'
import { OrdemView } from './ordem/OrdemView'

export type SheetEditorProps = { value: CharacterInput['systemData']; onChange: (value: CharacterInput['systemData']) => void; disabled?: boolean }
export type CharacterSheetDefinition = {
  slug: string; sections: readonly string[]; fields: readonly string[];
  schema: z.ZodType<CharacterInput['systemData']>;
  createData: () => CharacterInput['systemData']; Editor?: ComponentType<SheetEditorProps>;
  View?: ComponentType<{ value: CharacterInput['systemData'] }>;
}
const definitions: CharacterSheetDefinition[] = [
  { slug: 'ordem-paranormal', sections: ['Identidade', 'Atributos', 'Recursos'], fields: ['nex', 'classId', 'originId', 'creditLimit', 'attributes', 'resources'], schema: ordemDataSchema, createData: createOrdemData, Editor: OrdemEditor, View: OrdemView },
  { slug: 'dnd', sections: ['Identidade'], fields: [], schema: z.strictObject({ kind: z.literal('dnd') }), createData: () => ({ kind: 'dnd' }) },
  { slug: 'witcher', sections: ['Identidade'], fields: [], schema: z.strictObject({ kind: z.literal('witcher') }), createData: () => ({ kind: 'witcher' }) },
]
export const characterSheetRegistry = { get: (slug: string) => definitions.find((definition) => definition.slug === slug) }
