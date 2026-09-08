import { useQuery } from '@tanstack/react-query'
import { keys, queries, useDomainMutation } from '../../shared/api/queries'
import { preferencesApi } from '../../shared/api/domains'
import { RpgButton } from '../../components/primitives/RpgControls'
import { RpgCard } from '../../components/data-display/RpgCard'
import { PageHeader } from '../../components/navigation/PageHeader'
import { RpgErrorState, RpgSkeleton, MutationFeedback } from '../../components/feedback/RemoteState'

export function SystemsPage() {
  const systems = useQuery(queries.systems)
  const preferences = useQuery(queries.preferences)
  const mutation = useDomainMutation(preferencesApi.update, [keys.preferences])
  if (systems.isPending || preferences.isPending) return <RpgSkeleton />
  if (systems.isError) return <RpgErrorState error={systems.error} retry={() => void systems.refetch()} />
  if (preferences.isError) return <RpgErrorState error={preferences.error} retry={() => void preferences.refetch()} />
  return <><PageHeader eyebrow="04 / Universos" title="Escolha sua próxima história" description="Seu sistema ativo define o contexto da aplicação. Campanhas e fichas existentes mantêm seu próprio universo." />
    <div className="grid gap-5 md:grid-cols-3">{systems.data.map((system, index) => <RpgCard key={system.id}>
      <p className="mb-12 font-mono text-xs text-(--accent)">UNIVERSO / 0{index + 1}</p>
      <h3 className="text-2xl font-semibold">{system.name}</h3><p className="my-5 min-h-12 text-sm opacity-75">{system.description}</p>
      <p className="mb-6 text-xs">{system.status === 'available' ? 'Ficha completa disponível' : 'Cadastro básico · ficha específica em breve'}</p>
      <RpgButton secondary={preferences.data.activeSystemId !== system.id} disabled={mutation.isPending || preferences.data.activeSystemId === system.id}
        onClick={() => mutation.mutate({ activeSystemId: system.id })}>{preferences.data.activeSystemId === system.id ? 'Sistema ativo' : 'Selecionar ' + system.name}</RpgButton>
    </RpgCard>)}</div><div className="mt-5"><MutationFeedback error={mutation.error} success={mutation.isSuccess} /></div></>
}
