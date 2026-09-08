import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { expect, test } from 'vitest'
import { useState } from 'react'
import { RpgInput, RpgButton } from './RpgControls'

function Harness() {
  const [value, setValue] = useState('')
  return <><RpgInput label="Nome" value={value} onChange={setValue} /><RpgButton disabled={!value}>Salvar</RpgButton></>
}
test('campo acessível por label habilita a ação ao editar', async () => {
  render(<Harness />)
  expect(screen.getByRole('button', { name: 'Salvar' })).toBeDisabled()
  await userEvent.type(screen.getByLabelText('Nome'), 'Agente')
  expect(screen.getByRole('button', { name: 'Salvar' })).toBeEnabled()
})
