import { test, expect } from 'vitest'
import { rollDice } from './roll'

test.each([4, 6, 8, 10, 12, 20, 100])('D%i respeita limites inferior e superior', (sides) => {
  expect(rollDice({ sides, quantity: 2, modifier: 0 }, () => 0).individual).toEqual([1, 1])
  expect(rollDice({ sides, quantity: 2, modifier: 0 }, () => 0.999999).individual).toEqual([sides, sides])
})
test('aplica o modificador uma vez ao total', () => {
  expect(rollDice({ sides: 20, quantity: 3, modifier: -2 }, () => 0.5)).toMatchObject({ individual: [11, 11, 11], total: 31 })
})
test.each([{ sides: 3, quantity: 1, modifier: 0 }, { sides: 20, quantity: 0, modifier: 0 }, { sides: 20, quantity: 101, modifier: 0 }, { sides: 20, quantity: 1.5, modifier: 0 }])('rejeita entrada inválida %j', (input) => {
  expect(() => rollDice(input)).toThrow()
})
