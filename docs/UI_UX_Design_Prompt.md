# 🎨 Prompt de Design UI/UX - AcordaAI App

## 📋 Contexto do Projeto

**AcordaAI** é um aplicativo móvel Flutter que permite criar alarmes baseados em localização geográfica. O app monitora continuamente a posição do usuário e dispara alarmes automáticos quando ele chega ao destino marcado, ideal para despertar em pontos específicos durante viagens em transporte público, caronas ou qualquer deslocamento.

### Objetivo Principal
Criar uma interface moderna, elegante e intuitiva que facilite a criação e gestão de alarmes por localização, com foco em usabilidade durante situações de sono/sonolência e visualização eficiente de múltiplos pontos no mapa.

---

## 🎯 Princípios de Design

### Design Philosophy
- **Simplicidade Funcional**: Interface limpa focada na tarefa principal (marcar pontos e gerenciar alarmes)
- **Clareza Visual**: Informações críticas devem ser imediatamente compreensíveis
- **Eficiência de Interação**: Mínimo de toques para realizar tarefas comuns
- **Feedback Imediato**: Toda ação deve ter resposta visual/tátil instantânea
- **Acessibilidade**: Controles grandes e legíveis, adequados para uso sonolento

### Paleta de Cores Sugerida
- **Primária**: Azul vibrante (#2196F3) - Confiança e tecnologia
- **Secundária**: Verde menta (#4CAF50) - Ação positiva e confirmação
- **Acento**: Laranja energético (#FF9800) - Alertas e ativação
- **Fundo**: Cinza claro/escuro adaptativo (#F5F5F5 light / #121212 dark)
- **Superfícies**: Branco/cinza escuro com elevação (#FFFFFF / #1E1E1E)
- **Estados**:
  - Ativo: Verde (#4CAF50)
  - Pausado: Amarelo âmbar (#FFC107)
  - Desabilitado: Cinza (#9E9E9E)
  - Alerta: Vermelho (#F44336)

### Tipografia
- **Fonte Principal**: Roboto/Inter (legibilidade em múltiplos tamanhos)
- **Títulos**: Semi-bold, 24-32sp
- **Corpo**: Regular, 16-18sp
- **Labels**: Medium, 14sp
- **Botões**: Medium, 16sp

---

## 📱 Telas e Componentes

## 1. 🏠 Tela Principal - Mapa Interativo

### Descrição
Tela principal do app focada em um mapa interativo full-screen que mostra todos os alarmes como pins coloridos e a localização atual do usuário.

### Elementos Visuais

#### Header (Transparente sobre mapa)
- **AppBar Flutuante**: 
  - Fundo semi-transparente com blur effect
  - Título "AcordaAI" centralizado ou logo (opcional)
  - Ícone de configurações (⚙️) à direita
  - Ícone de perfil/conta (👤) à esquerda (opcional)
  - Altura: 56dp com elevação suave

#### Mapa Interativo
- **Google Maps Flutter** ocupando toda tela
- Estilo do mapa: Customizado com cores do tema
- Controles de zoom flutuantes (+ / -)
- Botão "Minha Localização" (🎯) no canto inferior direito
- Pins/Markers customizados por status:
  - **Ativo**: Pin verde com ícone de alarme
  - **Pausado**: Pin amarelo com ícone de pausa
  - **Desabilitado**: Pin cinza semi-transparente
  - **Selecionado**: Animação de pulso/destaque

#### Interação de Criação de Alarme
- **Toque no mapa**: Coloca pin temporário (laranja) com animação de "drop"
- **Bottom Sheet de Confirmação** (slide-up):
  - Aparece automaticamente após colocar pin
  - Endereço aproximado (geocoding)
  - Botão primário: "Criar Alarme Aqui" (verde)
  - Botão secundário: "Cancelar" (outline)
  - Possibilidade de arrastar pin antes de confirmar

#### FAB (Floating Action Button)
- **Posição**: Canto inferior direito, acima do botão de localização
- **Ícone**: + (adicionar) ou 📍 (pin)
- **Cor**: Primária (azul) com elevação pronunciada
- **Ação**: Ativa modo de colocação de pin no mapa
- **Tooltip**: "Adicionar Alarme"

#### Bottom Navigation Bar
- **Três abas**:
  1. **Mapa** (🗺️): Visualização atual
  2. **Lista** (📋): Lista de alarmes
  3. **Estatísticas** (📊): Histórico e insights (opcional)
- Ícones com labels
- Indicador de aba ativa (cor primária)

#### Overlay de Pin Selecionado
- **Card Flutuante** acima do bottom nav quando pin é tocado:
  - Nome/descrição do alarme
  - Endereço
  - Status (badge colorido)
  - Ações rápidas: Editar, Pausar/Ativar, Excluir
  - Animação de entrada smooth

### Comportamentos
- **Long press no mapa**: Cria pin rapidamente
- **Tap em pin existente**: Mostra card de detalhes
- **Pinch to zoom**: Navegação fluida
- **Arrastar pin**: Reposiciona alarme
- **Double tap**: Zoom in rápido

---

## 2. 📋 Tela de Lista de Alarmes

### Descrição
Visualização em lista de todos os alarmes criados, com ações rápidas e status claro.

### Elementos Visuais

#### Header
- **AppBar padrão**:
  - Título "Meus Alarmes"
  - Contador de alarmes ativos (badge)
  - Ícone de filtro (🔍) para buscar
  - Ícone de ordenação (⇅)

#### Lista de Alarmes
- **Cards de Alarme** (Material Design 3):
  - **Layout**:
    ```
    [Status Badge] [Nome do Alarme]
    📍 [Endereço]
    ⚙️ Raio: [X]m | 🔔 [Som]
    [Switch Ativar/Desativar] [Botão Editar] [Botão Deletar]
    ```
  - Elevation suave (2dp)
  - Padding interno generoso
  - Dividers sutis entre cards
  - Swipe gestures:
    - **Swipe direita**: Ativar/Desativar (verde/cinza)
    - **Swipe esquerda**: Deletar (vermelho)

#### Status Badge
- **Posição**: Canto superior esquerdo do card
- **Estilos**:
  - Ativo: Chip verde com "✓ Ativo"
  - Pausado: Chip amarelo com "⏸ Pausado"
  - Desabilitado: Chip cinza com "○ Desabilitado"

#### Ações Rápidas
- **Switch Toggle**: Ativar/Desativar alarme
- **IconButton Editar**: Navega para tela de edição
- **IconButton Deletar**: Confirmação via dialog

#### Estado Vazio
- **Ilustração**: Mapa vazio com pin
- **Texto**: "Nenhum alarme criado"
- **Botão**: "Criar Primeiro Alarme" (primário)

### Comportamentos
- **Tap no card**: Expande detalhes ou navega para mapa centralizado no pin
- **Long press**: Seleção múltipla para ações em batch
- **Pull to refresh**: Atualiza lista
- **Animação de entrada**: Cards aparecem com fade + slide

---

## 3. ➕ Tela de Criação/Edição de Alarme

### Descrição
Formulário detalhado para configurar todos os aspectos do alarme baseado em localização.

### Elementos Visuais

#### Header
- **AppBar**:
  - Título: "Novo Alarme" ou "Editar Alarme"
  - Botão voltar (←)
  - Botão salvar (✓) à direita

#### Seções do Formulário

##### 1. Localização
- **Mini-mapa Preview**:
  - Altura: 200dp
  - Mostra pin do alarme centralizado
  - Tap para abrir mapa fullscreen e ajustar
  - Label de endereço abaixo

##### 2. Informações Básicas
- **TextField - Nome do Alarme**:
  - Placeholder: "Ex: Parada do trabalho"
  - Ícone: 🏷️
  - Máximo de caracteres visível
  
- **TextField - Descrição (Opcional)**:
  - Placeholder: "Adicione observações..."
  - Ícone: 📝
  - Multiline (2-3 linhas)

##### 3. Configurações de Ativação
- **Slider - Raio de Ativação**:
  - Label: "Distância para Alarme"
  - Range: 10m - 1000m
  - Indicador visual do valor atual
  - Preview visual do raio no mini-mapa
  - Marcações: 10m, 50m, 100m, 500m, 1000m

##### 4. Configurações de Alerta
- **Dropdown - Som do Alarme**:
  - Lista de sons disponíveis
  - Botão de preview (▶️) para testar
  - Opção "Som Padrão"

- **Slider - Volume**:
  - 0-100%
  - Ícone de volume dinâmico (🔇 → 🔊)

- **Switch - Vibração**:
  - "Ativar Vibração Intensa"
  - Descrição: "Recomendado para despertar"

- **Switch - Tela Sempre Ligada**:
  - "Manter tela acesa durante alarme"

##### 5. Ações
- **Botões Finais**:
  - Botão Primário: "Salvar Alarme" (largura completa, verde)
  - Botão Secundário: "Cancelar" (outline)

### Comportamentos
- **Validação em tempo real**: Feedback visual em campos obrigatórios
- **Preview instantâneo**: Alterações no raio refletem no mini-mapa
- **Teste de som**: Permite ouvir alarme antes de salvar
- **Confirmação ao sair**: Se houver mudanças não salvas

---

## 4. 🚨 Tela de Alarme Ativo (Disparado)

### Descrição
Tela fullscreen exibida quando o alarme é disparado ao chegar no destino. Deve ser extremamente eficaz em despertar e informar o usuário.

### Elementos Visuais

#### Background Dinâmico
- **Gradiente Animado**: Vermelho-laranja pulsante
- **Efeito de Ondas**: Círculos concêntricos expandindo do centro
- **Brilho Máximo**: Tela com luminosidade máxima

#### Conteúdo Central
- **Ícone Grande**: 🚨 ou ⏰ (128dp) animado (rotação/pulse)
- **Título Principal**: 
  - "VOCÊ CHEGOU!" (36sp, bold, branco)
  - Animação de fade in/out suave

- **Nome do Alarme**:
  - (24sp, medium, branco)
  - Ex: "Parada do Trabalho"

- **Informações de Localização**:
  - 📍 Endereço atual (16sp)
  - ⏱️ Hora atual grande (18sp)

#### Ações Principais
- **Botão PARAR (Gigante)**:
  - Posição: Centro-inferior
  - Tamanho: 80% da largura, 64dp altura
  - Cor: Branco com texto vermelho
  - Label: "PARAR ALARME" (20sp, bold)
  - Ícone: ✋
  - Feedback tátil forte ao tocar

- **Botão Soneca (Secundário)**:
  - Posição: Abaixo do botão parar
  - Tamanho: Médio
  - Label: "Adiar 5 min" (outline)
  - Ícone: ⏰

#### Indicadores
- **Intensidade Visual**: Barras ou círculo mostrando intensidade do alarme
- **Contador**: Tempo desde que disparou

### Comportamentos
- **Som Crescente**: Volume aumenta progressivamente
- **Vibração Contínua**: Padrão intenso e persistente
- **Animações Chamativos**: Movimento constante para atrair atenção
- **Bloqueio de Gestures**: Evita dismissal acidental
- **Wake Lock**: Mantém tela sempre ligada
- **Sobreposição**: Aparece sobre todas as apps (com permissão)

---

## 5. ⚙️ Tela de Configurações

### Descrição
Central de configurações globais do app e preferências do usuário.

### Elementos Visuais

#### Header
- **AppBar**: 
  - Título "Configurações"
  - Botão voltar

#### Seções Organizadas

##### 🗺️ Mapa
- **Estilo do Mapa**: Dropdown (Normal, Satélite, Híbrido, Terreno)
- **Tema do Mapa**: Switch (Claro/Escuro/Automático)

##### 🔔 Notificações
- **Som Padrão**: Seletor de som padrão para novos alarmes
- **Volume Padrão**: Slider
- **Vibração Padrão**: Switch
- **Notificações Push**: Switch

##### 📍 Localização
- **Precisão**: Radio buttons (Alta/Média/Econômica)
- **Atualização em Background**: Switch
- **Otimização de Bateria**: Switch

##### 🎨 Aparência
- **Tema**: Radio buttons (Claro/Escuro/Sistema)
- **Cor Primária**: Seletor de cores
- **Tamanho da Fonte**: Slider (Pequeno/Médio/Grande)

##### 🔒 Privacidade
- **Histórico de Localizações**: Switch para salvar histórico
- **Analytics**: Switch para permitir analytics

##### ℹ️ Sobre
- **Versão do App**: Texto (ex: 1.0.0)
- **Termos de Uso**: Link
- **Política de Privacidade**: Link
- **Licenças**: Link para tela de licenças

### Comportamentos
- **Salvar Automático**: Mudanças aplicadas imediatamente
- **Feedback Visual**: Indicação de quando configuração é alterada
- **Validações**: Avisos sobre permissões necessárias

---

## 6. 📊 Tela de Estatísticas/Histórico (Opcional)

### Descrição
Dashboard visual com insights sobre uso do app e histórico de alarmes disparados.

### Elementos Visuais

#### Cards de Estatísticas
- **Alarmes Criados**: Contador total
- **Alarmes Disparados**: Contador com tendência
- **Taxa de Sucesso**: Percentual
- **Destino Mais Usado**: Nome do local

#### Gráficos
- **Linha do Tempo**: Gráfico de alarmes por dia/semana
- **Horários Comuns**: Gráfico circular de horários de disparo
- **Locais Frequentes**: Mapa de calor dos destinos

#### Lista de Histórico
- **Cards Históricos**:
  - Data e hora de disparo
  - Local e nome do alarme
  - Status (disparado/cancelado)

---

## 🎨 Componentes Reutilizáveis

### 1. AlarmCard
**Descrição**: Card padrão para exibir alarme na lista.
- Status badge colorido
- Título e descrição
- Endereço com ícone
- Switch de ativação
- Botões de ação (editar/deletar)

### 2. MapMarker (Custom Marker)
**Descrição**: Pin customizado para o mapa.
- Ícone de alarme personalizado
- Cor baseada em status
- Badge com número (se múltiplos no mesmo local)
- Animação de pulso quando selecionado

### 3. RadiusSlider
**Descrição**: Slider especializado para configurar raio.
- Marcações visuais em pontos chave
- Label com valor atual + unidade
- Preview visual no mapa
- Haptic feedback ao mudar valor

### 4. SoundPicker
**Descrição**: Seletor de som com preview.
- Lista expansível de sons
- Botão play/pause por item
- Indicador de som selecionado
- Suporte a sons customizados

### 5. StatusBadge
**Descrição**: Badge de status do alarme.
- Cores semânticas (verde/amarelo/cinza/vermelho)
- Ícone + texto
- Tamanho compacto
- Animação de mudança de estado

### 6. LocationPreviewCard
**Descrição**: Card com mini-mapa de preview.
- Mapa estático ou interativo
- Pin centralizado
- Endereço abaixo
- Botão "Ajustar" para abrir fullscreen

### 7. AlertDialog Custom
**Descrição**: Dialogs padronizados para confirmações.
- Ícone contextual (warning, info, error)
- Título claro
- Mensagem descritiva
- Botões com cores semânticas

### 8. EmptyState
**Descrição**: Estado vazio para listas/telas vazias.
- Ilustração SVG contextual
- Título e descrição
- Call-to-action button
- Animação sutil

---

## 🎭 Animações e Transições

### Transições de Tela
- **Navegação entre abas**: Crossfade suave (300ms)
- **Push/Pop de páginas**: Slide horizontal com fade (350ms)
- **Modals/Bottom Sheets**: Slide up com backdrop fade (300ms)

### Micro-interações
- **Botões**: Scale down + ripple effect ao tocar
- **Cards**: Elevation aumenta ao tocar (hover effect)
- **Switches**: Slide suave com bounce sutil
- **Sliders**: Thumb aumenta ao arrastar
- **FAB**: Rotation + scale ao expandir menu

### Animações de Feedback
- **Sucesso**: Checkmark animado com verde
- **Erro**: Shake horizontal com vermelho
- **Loading**: Spinner circular ou skeleton screens
- **Pull to refresh**: Indicador circular com rotation

### Animações de Lista
- **Entrada**: Staggered fade + slide up (50ms delay entre items)
- **Remoção**: Slide out + fade out + collapse height
- **Reordenação**: Smooth position transition

### Animações do Mapa
- **Pin Drop**: Bounce effect ao colocar no mapa
- **Pin Seleção**: Pulse + scale up
- **Zoom em Local**: Animated camera movement
- **Raio de Ativação**: Círculo expandindo/contraindo suavemente

---

## 📐 Layout e Responsividade

### Breakpoints
- **Mobile Portrait**: 0-600dp (layout principal)
- **Mobile Landscape**: 600-840dp (ajustes de layout)
- **Tablet**: 840dp+ (layout de 2 colunas)

### Adaptações
- **Tablets**: Mapa + lista lado a lado
- **Landscape**: Bottom navigation → Side navigation rail
- **Telas grandes**: Formulários limitados a 600dp de largura, centralizados

### Espaçamentos Consistentes
- **Tiny**: 4dp
- **Small**: 8dp
- **Medium**: 16dp
- **Large**: 24dp
- **XLarge**: 32dp

### Grid System
- Margem externa: 16dp (mobile), 24dp (tablet)
- Gutter: 16dp
- Columns: 4 (mobile), 8 (tablet), 12 (desktop)

---

## ♿ Acessibilidade

### Contraste
- Todos os textos devem ter contraste mínimo WCAG AA (4.5:1)
- Elementos interativos: contraste mínimo AAA (7:1)

### Tamanhos Mínimos
- Botões e áreas tocáveis: mínimo 48x48dp
- Ícones importantes: 24dp+
- Textos: mínimo 14sp

### Semântica
- Labels descritivos em todos os campos
- Textos alternativos em ícones
- Estados focados visíveis (outline)
- Ordem de foco lógica

### Suporte
- Screen readers (TalkBack/VoiceOver)
- Navegação por teclado (quando aplicável)
- Modos de alto contraste
- Escalabilidade de fontes (até 200%)

---

## 🌙 Modo Dark/Light

### Implementação
- Suporte completo a tema claro e escuro
- Alternância automática baseada no sistema
- Opção manual nas configurações

### Cores Dark Mode
- **Background**: #121212
- **Surface**: #1E1E1E
- **Primary**: #90CAF9 (azul mais claro)
- **Secondary**: #81C784 (verde mais claro)
- **Error**: #EF5350
- **Text Primary**: #FFFFFF (87% opacity)
- **Text Secondary**: #FFFFFF (60% opacity)

### Ajustes
- Elevações mais pronunciadas no dark mode
- Ícones com stroke mais fino
- Redução de brilho em imagens/ilustrações

---

## 🎯 Fluxos de Usuário Principais

### Fluxo 1: Criar Primeiro Alarme
1. **Onboarding** (primeira vez) → Explicação do app
2. **Tela Principal (Mapa)** → Vazia com dica
3. **Tap no mapa** → Pin aparece
4. **Bottom Sheet** → Confirmação rápida
5. **Criado com sucesso** → Snackbar + pin no mapa

### Fluxo 2: Configurar Alarme Detalhado
1. **Tela Principal** → FAB "+"
2. **Escolher Localização** → Tap no mapa
3. **Formulário Completo** → Preencher detalhes
4. **Preview** → Testar som/configurações
5. **Salvar** → Retorna ao mapa com pin criado

### Fluxo 3: Gerenciar Alarmes Existentes
1. **Lista de Alarmes** → Ver todos os alarmes
2. **Swipe em card** → Ações rápidas (ativar/deletar)
3. **Tap em card** → Ver detalhes/editar
4. **Editar** → Modificar configurações
5. **Salvar** → Atualização confirmada

### Fluxo 4: Alarme Disparado
1. **Chegada no destino** → Notificação push
2. **Tela de Alarme** → Fullscreen chamativo
3. **Som + Vibração** → Intensidade crescente
4. **Usuário acorda** → Toca "Parar"
5. **Alarme desativado** → Retorna ao app normalmente

---

## 🚀 Considerações Técnicas Flutter

### Widgets Principais Sugeridos
- **Mapa**: `google_maps_flutter` com customização
- **Bottom Navigation**: `NavigationBar` (Material 3)
- **Cards**: `Card` com `Material` para elevation
- **Forms**: `TextFormField` com validação
- **Sliders**: `Slider` customizado
- **Switches**: `Switch.adaptive`
- **Animações**: `AnimatedContainer`, `Hero`, `PageRouteBuilder`
- **Listas**: `ListView.builder` com `AnimatedList`

### Performance
- **Lazy loading**: Carregar pins do mapa sob demanda
- **Image caching**: Usar `CachedNetworkImage` se houver imagens
- **Debouncing**: Em campos de busca/texto
- **Efficient rebuilds**: Usar `const` widgets sempre que possível

### Testes
- **Golden tests**: Para garantir consistência visual
- **Snapshot tests**: Validar layouts em diferentes tamanhos
- **Accessibility tests**: Validar semântica e contraste

---

## 📝 Notas Finais para o Designer

### Prioridades
1. **Clareza na tela de mapa**: Principal interface do app
2. **Eficácia da tela de alarme**: Deve despertar efetivamente
3. **Simplicidade na criação**: Mínimo de passos para criar alarme
4. **Feedback constante**: Usuário sempre sabe o que está acontecendo

### Restrições
- Foco em mobile (portrait primary)
- Suporte a Android e iOS
- Widgets nativos do Flutter (evitar dependências pesadas)
- Performance em dispositivos de entrada

### Recursos de Referência
- **Material Design 3**: https://m3.material.io/
- **Flutter Widget Catalog**: https://flutter.dev/docs/development/ui/widgets
- **Human Interface Guidelines (iOS)**: Para consistência cross-platform

### Entregáveis Esperados
1. Wireframes de baixa fidelidade (estrutura)
2. Mockups de alta fidelidade (visual completo)
3. Protótipo interativo (fluxos principais)
4. Design system (cores, tipografia, componentes)
5. Assets (ícones, ilustrações, pins customizados)
6. Especificações para desenvolvimento (espaçamentos, animações)

---

## 🎨 Inspirações de Design

### Referências de Apps
- **Google Maps**: Interação com mapa, pins, bottom sheets
- **Alarme do iOS**: Interface de alarme ativo, sons
- **Sleep Cycle**: Design de sono, estatísticas
- **Waze**: Feedback visual, navegação, alertas

### Estilos Visuais
- **Moderno**: Uso de glassmorphism em overlays
- **Limpo**: Muito whitespace, hierarquia clara
- **Vibrante**: Cores para indicar estados e ações
- **Amigável**: Ilustrações, mensagens humanizadas

---

**Este prompt foi criado para guiar a criação de um design completo, moderno e funcional para o app AcordaAI, seguindo as melhores práticas de UI/UX e aproveitando as capacidades dos widgets Flutter. O design deve priorizar usabilidade, clareza e eficácia na função principal: despertar o usuário no local correto!** 🚨✨
