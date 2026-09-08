import { useForm } from '@tanstack/react-form'
import { profileInputSchema, type User } from '../../shared/contracts/user'
import { userApi } from '../../shared/api/domains'
import { keys, useDomainMutation } from '../../shared/api/queries'
import { RpgForm } from '../../components/forms/RpgForm'
import { RpgInput, RpgButton } from '../../components/primitives/RpgControls'
import { MutationFeedback } from '../../components/feedback/RemoteState'
import { fieldError } from '../../shared/lib/form-error'

export function ProfileForm({ user }: { user: User }) {
  const mutation = useDomainMutation(userApi.update, [keys.user])
  const form = useForm({
    defaultValues: { name: user.name, username: user.username, avatarUrl: user.avatarUrl },
    validators: { onSubmit: profileInputSchema },
    onSubmit: async ({ value }) => { await mutation.mutateAsync(value).catch(() => undefined) },
  })
  return <RpgForm onSubmit={() => form.handleSubmit()}>
    <div className="grid gap-6 md:grid-cols-2">
      <form.Field name="name">{(field) => <RpgInput label="Nome" value={field.state.value} onChange={field.handleChange} onBlur={field.handleBlur} disabled={mutation.isPending} error={fieldError(field.state.meta.errors)} />}</form.Field>
      <form.Field name="username">{(field) => <RpgInput label="Nome de usuário" value={field.state.value} onChange={field.handleChange} onBlur={field.handleBlur} disabled={mutation.isPending} error={fieldError(field.state.meta.errors)} />}</form.Field>
    </div>
    <form.Field name="avatarUrl">{(field) => <RpgInput label="URL do avatar" hint="Opcional. Informe uma URL HTTPS." value={field.state.value} onChange={field.handleChange} onBlur={field.handleBlur} disabled={mutation.isPending} error={fieldError(field.state.meta.errors)} />}</form.Field>
    <MutationFeedback error={mutation.error} success={mutation.isSuccess} /><RpgButton submit loading={mutation.isPending}>Salvar perfil</RpgButton>
  </RpgForm>
}
