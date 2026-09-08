import { AppProviders } from './app/providers/AppProviders'
import { RouterProvider } from '@tanstack/react-router'
import { createAppRouter } from './app/router/router'

const router = createAppRouter()

export default function App() {
  return <AppProviders><RouterProvider router={router} /></AppProviders>
}
