import { describe, expect, test } from 'vitest'
import { createSeed } from '../../mocks/seed/seed'
import { resolveTheme, themes } from './definitions'

describe('temas da aplicação', () => {
  test('Energia usa a identidade roxa do elemento', () => {
    const energy = themes.find((theme) => theme.id === 'ordem-energia')

    expect(energy?.palette).toEqual({
      accent: '#c77dff',
      background: '#100817',
      panel: '#20102b',
      ink: '#f5e9ff',
      edge: '#70418c',
    })
  })

  test('tema padrão preserva a antiga identidade de Energia', () => {
    expect(resolveTheme(null)).toMatchObject({
      id: 'neutral',
      name: 'Arquivo',
      palette: {
        accent: '#9fe87b',
        background: '#0b1217',
        panel: '#14212a',
        ink: '#e1f2f6',
        edge: '#335967',
      },
    })
    expect(createSeed().preferences.activeThemeId).toBeNull()
  })
})
