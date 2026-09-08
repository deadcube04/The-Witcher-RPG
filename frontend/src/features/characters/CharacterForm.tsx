import { useForm } from '@tanstack/react-form'
import type { Campaign } from '../../shared/contracts/campaign'
import type { RpgSystem } from '../../shared/contracts/rpg-system'
import { characterInputSchema, type CharacterInput } from '../../shared/contracts/character-sheet'
import { characterSheetRegistry } from './registry'
import { CharacterAssociation } from './CharacterAssociation'
import { RpgForm } from '../../components/forms/RpgForm'
import { RpgButton, RpgInput } from '../../components/primitives/RpgControls'
import { MutationFeedback } from '../../components/feedback/RemoteState'
import { fieldError } from '../../shared/lib/form-error'

const narrativeFields = [
  { name: 'description', label: 'Descrição' }, { name: 'appearance', label: 'Aparência' }, { name: 'personality', label: 'Personalidade' },
  { name: 'background', label: 'Histórico' }, { name: 'objective', label: 'Objetivo' },
] as const
export function CharacterForm({ initial, systems, campaigns, pending, error, onSave, systemLocked = false }: {
  initial: CharacterInput; systems: RpgSystem[]; campaigns: Campaign[]; pending: boolean; error: Error | null;
  onSave: (input: CharacterInput) => Promise<void>; systemLocked?: boolean
}) {
  const schema = characterInputSchema.refine((input) => input.campaignId === null || campaigns.some((campaign) => campaign.id === input.campaignId && campaign.systemId === input.systemId), { message: 'Escolha uma campanha do mesmo sistema.', path: ['campaignId'] })
  const form = useForm({ defaultValues: initial, validators: { onSubmit: schema }, onSubmit: async ({ value }) => onSave(value) })
  return <RpgForm onSubmit={() => form.handleSubmit()}>
    <section className="space-y-6"><h3 className="border-b border-(--edge) pb-3 text-xl">01 / Identidade</h3>
      <form.Field name="name">{(field) => <RpgInput label="Nome do personagem" value={field.state.value} onChange={field.handleChange} onBlur={field.handleBlur} disabled={pending} error={fieldError(field.state.meta.errors)} />}</form.Field>
      <form.Subscribe selector={(state) => state.values}>{(values) => <CharacterAssociation systemId={values.systemId} campaignId={values.campaignId} systems={systems} campaigns={campaigns} disabled={pending} systemLocked={systemLocked}
        onCampaignChange={(id) => form.setFieldValue('campaignId', id)} onSystemChange={(id) => {
          const system = systems.find((entry) => entry.id === id)
          const definition = system && characterSheetRegistry.get(system.slug)
          if (!definition) return
          form.setFieldValue('systemId', id); form.setFieldValue('campaignId', null); form.setFieldValue('systemData', definition.createData())
        }} />}</form.Subscribe>
      <form.Field name="campaignId">{(field) => field.state.meta.errors.length ? <p role="alert">{fieldError(field.state.meta.errors)}</p> : null}</form.Field>
    </section>
    <form.Field name="systemData">{(field) => {
      const definition = characterSheetRegistry.get(field.state.value.kind)
      const Editor = definition?.Editor
      return <><section>{Editor ? <Editor value={field.state.value} onChange={field.handleChange} disabled={pending} />
        : <p className="border border-(--edge) p-5 text-sm">Cadastro narrativo disponível. As regras específicas deste sistema serão adicionadas em uma próxima edição.</p>}</section>
        {field.state.meta.errors.length > 0 && <p role="alert">{fieldError(field.state.meta.errors)}</p>}</>
    }}</form.Field>
    <section className="space-y-5"><h3 className="border-b border-(--edge) pb-3 text-xl">História do personagem</h3><div className="grid gap-5 md:grid-cols-2">
      {narrativeFields.map(({ name, label }) => <form.Field key={name} name={name}>{(field) => <RpgInput label={label} multiline value={field.state.value} onChange={field.handleChange} onBlur={field.handleBlur} disabled={pending} error={fieldError(field.state.meta.errors)} />}</form.Field>)}
    </div></section>
    <MutationFeedback error={error} success={false} /><RpgButton submit loading={pending}>Salvar ficha</RpgButton>
  </RpgForm>
}
