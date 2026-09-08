import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.tsx'
import { bootstrap } from './app/bootstrap/bootstrap'

const root = document.getElementById('root')
if (!root) throw new Error('Elemento raiz não encontrado')
bootstrap().then(() => createRoot(root).render(
  <StrictMode>
    <App />
  </StrictMode>,
)).catch(() => { root.textContent = 'Não foi possível iniciar o ambiente local. Atualize a página para tentar novamente.' })
