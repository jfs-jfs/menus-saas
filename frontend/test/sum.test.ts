import { describe, it, expect } from 'vitest'

function sum(a: number, b: number) {
  return a+b;
}

describe('basic arithmetic checks', () => {
  it('1 + 1 equals 2', () => {
    expect(sum(1 , 1)).toBe(2)
  })

  it('2 * 2 equals 4', () => {
    expect(2 * 2).toBe(4)
  })
})
