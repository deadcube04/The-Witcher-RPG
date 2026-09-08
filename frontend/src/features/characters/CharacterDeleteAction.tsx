import { useNavigate } from '@tanstack/react-router'
import { RpgDeleteAction } from '../../components/overlay/RpgDeleteAction'
import { characterApi } from '../../shared/api/domains'
import { keys, useDomainMutation } from '../../shared/api/queries'
import type { CharacterSheet } from '../../shared/contracts/character-sheet'

export function CharacterDeleteAction({ character }: { character: CharacterSheet }) {
  const navigate = useNavigate()
  const mutation = useDomainMutation(characterApi.remove, [keys.characters, keys.campaigns])
  return <RpgDeleteAction name={character.name} description="A ficha e seus dados serão excluídos. Esta ação não pode ser desfeita."
    onDelete={async () => { await mutation.mutateAsync(character.id); await navigate({ to: '/characters' }) }} />
}
