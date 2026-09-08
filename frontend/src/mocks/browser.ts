import { setupWorker } from 'msw/browser'
import { createHandlers } from './handlers'
import { MockRepository } from './database/repository'

export const worker = setupWorker(...createHandlers(new MockRepository(localStorage)))
