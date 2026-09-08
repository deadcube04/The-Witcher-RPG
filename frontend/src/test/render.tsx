import { render } from '@testing-library/react'
import { QueryClientProvider } from '@tanstack/react-query'
import { createQueryClient } from '../app/providers/query-client'
import type { ReactNode } from 'react'
import { setupServer } from 'msw/node'
import { createHandlers } from '../mocks/handlers'
import { MockRepository } from '../mocks/database/repository'

export const testServer = setupServer(...createHandlers(new MockRepository(localStorage)))
export function renderFeature(children: ReactNode) {
  const client = createQueryClient()
  client.setDefaultOptions({ queries: { retry: false } })
  return { ...render(<QueryClientProvider client={client}>{children}</QueryClientProvider>), client }
}
