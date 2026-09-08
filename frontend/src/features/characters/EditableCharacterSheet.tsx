import { useState, type ReactNode } from 'react'
import { Link } from '@tanstack/react-router'
import { LuArrowLeft } from 'react-icons/lu'
import type { CharacterInput, CharacterSheet } from '../../shared/contracts/character-sheet'
import { AutoSaveIndicator } from './AutoSaveIndicator'
import { CharacterDeleteAction } from './CharacterDeleteAction'
import { CharacterIdentity } from './CharacterIdentity'
import { CharacterPanels } from './CharacterPanels'
import { createMockSkills, type CharacterSkill } from './character-skills'
import { useAutoSaveIndicator } from './useAutoSaveIndicator'

type Props = { character: CharacterSheet; systemName: string; campaignReference: ReactNode }

function createDraft(character: CharacterSheet): CharacterInput {
  return {
    name: character.name, systemId: character.systemId, campaignId: character.campaignId,
    description: character.description, appearance: character.appearance, personality: character.personality,
    background: character.background, objective: character.objective, systemData: character.systemData,
  }
}

export function EditableCharacterSheet({ character, systemName, campaignReference }: Props) {
  const [draft, setDraft] = useState<CharacterInput>(() => createDraft(character))
  const [skills, setSkills] = useState<CharacterSkill[]>(createMockSkills)
  const { status, markChanged } = useAutoSaveIndicator()
  const updateDraft = (next: CharacterInput) => { setDraft(next); markChanged() }
  const updateSkills = (next: CharacterSkill[]) => { setSkills(next); markChanged() }
  return <div className="font-sans">
    <div className="mb-8 flex flex-wrap items-center justify-between gap-4 border-b border-(--edge) pb-5">
      <Link to="/characters" className="inline-flex min-h-11 items-center gap-2 text-sm"><LuArrowLeft aria-hidden="true" />Todas as fichas</Link>
      <div className="flex flex-wrap gap-3"><AutoSaveIndicator status={status} /><CharacterDeleteAction character={character} /></div>
    </div>
    <div className="grid min-w-0 gap-8 xl:grid-cols-[minmax(240px,300px)_minmax(0,1fr)]">
      <div className="min-w-0 xl:border-r xl:border-(--edge) xl:pr-7"><CharacterIdentity character={draft} systemName={systemName} onChange={updateDraft} />
        <p className="mt-6 text-xs leading-6 opacity-70">{campaignReference}</p>
      </div>
      <div className="relative min-w-0"><CharacterPanels character={draft} skills={skills} onCharacterChange={updateDraft} onSkillsChange={updateSkills} /></div>
    </div>
  </div>
}
