# Experiência, responsividade e motion

## Shell

- Desktop a partir de `lg`: rail fixa de 72px e barra contextual acima do conteúdo.
- Tablet: rail compacta e conteúdo com margens reduzidas.
- Mobile: barra contextual superior e dock inferior; conteúdo recebe espaço para safe area.
- Navegação ativa combina forma, contraste e `aria-current`; cor nunca é o único indicador.
- Perfil e sistema ativo permanecem acessíveis sem hover.

## Hierarquia operacional

- A home oferece “Retomar sessão” como primeira ação.
- Coleções mostram um registro protagonista e um índice compacto.
- Formulários mantêm todas as seções visíveis e permitem leitura contínua.
- Na ficha, vida, sanidade e esforço precedem perícias, gavetas e narrativa.
- Ações destrutivas nunca dividem o mesmo peso visual da ação principal.

## Motion

- Implementação exclusiva com Motion.
- Transição de página: 420–600ms, usando opacidade e deslocamento vertical curto.
- Revelação de grupos: stagger de 40–70ms, limitado aos primeiros elementos visíveis.
- Gavetas: mola com amortecimento alto e sem overshoot excessivo.
- Feedback de pressão: escala mínima em botões, sem mover layout.
- Nenhuma animação altera `top`, `left`, `width` ou `height`; exceções existentes que animam altura serão migradas para composição por presença e transform quando tocadas.
- `prefers-reduced-motion` remove deslocamentos, escalonamentos e stagger, mantendo apenas mudança imediata de opacidade quando necessária.

## Acessibilidade

- Alvos interativos mínimos de 44px.
- Foco visível com token próprio e contraste de pelo menos 3:1.
- Texto normal com contraste WCAG AA.
- Scrim sólido ou tonalidade suficiente sobre fotografia.
- Ordem de tabulação acompanha a ordem visual e documental.
- Zoom de 200% não perde ações nem cria sobreposição.
- Skeletons, erros e feedbacks preservam `role`, `aria-live` e rótulos existentes.

## Responsividade das páginas

- Layouts assimétricos colapsam para uma coluna abaixo de 768px.
- Mídia nunca força altura de viewport; usar proporções estáveis e `min-height` apenas quando necessário.
- Tabelas densas mantêm rolagem horizontal e cabeçalhos legíveis.
- Gavetas da ficha viram sheets sobrepostos no mobile sem bloquear fechamento por teclado.
- CTAs não quebram linha em desktop; no mobile podem ocupar toda a largura.
