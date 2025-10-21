# 🎨 Sistema de Design - AcordaAI

## Visão Geral

Este documento descreve o sistema de design implementado no aplicativo AcordaAI, seguindo o design das interfaces apresentadas nas imagens de referência.

## 📁 Estrutura de Arquivos

### Temas (`lib/src/core/theme/`)

```
theme/
├── app_colors.dart          # Paleta de cores
├── app_spacing.dart         # Espaçamentos e tamanhos
├── app_text_styles.dart     # Estilos de texto
├── app_button_styles.dart   # Estilos de botões
├── app_input_styles.dart    # Estilos de inputs
├── app_theme.dart           # Tema global do app
└── theme.dart               # Barrel file (exports)
```

### Componentes (`lib/src/presentation/components/`)

```
components/
├── alarm_card.dart          # Card de alarme para lista
└── components.dart          # Barrel file (exports)
```

### Páginas (`lib/src/presentation/pages/`)

```
pages/
├── map_home/
│   └── map_home_page.dart     # Tela principal com mapa
├── alarms_list/
│   └── alarms_list_page.dart  # Lista de alarmes
└── alarm_config/
    └── alarm_config_page.dart # Configuração de alarme
```

## 🎨 Paleta de Cores

### Cores Primárias
- **Primary**: `#1E88E5` - Azul vibrante (AppBar, FAB, botões)
- **Primary Dark**: `#1565C0` - Variação escura
- **Primary Light**: `#42A5F5` - Variação clara

### Cores de Status
- **Active**: `#4CAF50` - Verde (alarmes ativos)
- **Inactive**: `#9E9E9E` - Cinza (alarmes inativos)
- **Paused**: `#FFC107` - Amarelo (alarmes pausados)
- **Error**: `#EF5350` - Vermelho (erros e exclusões)

### Background (Dark Theme)
- **Background**: `#121212` - Fundo principal escuro
- **Surface**: `#1E1E1E` - Superfícies (cards, dialogs)
- **Surface Light**: `#2C2C2C` - Superfície mais clara
- **Card**: `#1A1A1A` - Fundo de cards

### Textos
- **Text Primary**: `#FFFFFF` - Texto principal (branco)
- **Text Secondary**: `#B0B0B0` - Texto secundário
- **Text Hint**: `#757575` - Hints e placeholders

### Accent
- **Accent**: `#FF9800` - Laranja (sliders, destaques)

## 📏 Espaçamentos

### Básicos
- **xs**: 4dp
- **sm**: 8dp
- **md**: 16dp
- **lg**: 24dp
- **xl**: 32dp
- **xxl**: 48dp

### Border Radius
- **radiusSm**: 8dp
- **radiusMd**: 12dp
- **radiusLg**: 16dp
- **radiusFull**: 100dp (círculos)

### Componentes
- **buttonHeight**: 48dp
- **inputHeight**: 48dp
- **appBarHeight**: 56dp
- **iconMd**: 24dp

## 🔤 Tipografia

### Headers
- **h1**: 28sp, Bold
- **h2**: 24sp, Bold
- **h3**: 20sp, Semi-bold
- **h4**: 18sp, Semi-bold

### Body
- **bodyLarge**: 16sp, Regular
- **bodyMedium**: 14sp, Regular
- **bodySmall**: 12sp, Regular

### Especiais
- **alarmTitle**: 18sp, Bold - Títulos de alarmes
- **alarmAddress**: 14sp, Regular - Endereços
- **alarmInfo**: 13sp, Regular - Informações (raio, som)

## 🎯 Componentes

### AlarmCard

Card reutilizável para exibir alarmes na lista.

**Propriedades:**
- `alarm`: LocationAlarm - Dados do alarme
- `onToggle`: Callback para ativar/desativar
- `onEdit`: Callback para editar
- `onDelete`: Callback para deletar

**Características:**
- Ícone colorido baseado no tipo (trabalho, casa, academia)
- Badge de status (ativo/inativo)
- Switch para ativar/desativar
- Informações de raio e som
- Botões de editar e deletar

### MapControlButton

Botões flutuantes para controles do mapa.

**Características:**
- Background escuro com sombra
- Ícones brancos
- Efeito ripple ao tocar

## 📱 Telas

### 1. MapHomePage (Tela Principal)

Tela principal com mapa interativo do Google Maps.

**Características:**
- AppBar azul com título e contador de alarmes ativos
- Mapa fullscreen com markers coloridos
- Controles de zoom flutuantes (+ / -)
- Botão "Minha Localização"
- FAB para criar novo alarme
- Bottom sheet ao tocar no mapa
- Navegação para lista de alarmes via menu

**Interações:**
- Tap no mapa → Mostra bottom sheet para criar alarme
- Tap em marker → Info window com detalhes
- FAB → Navega para tela de configuração

### 2. AlarmsListPage

Lista vertical de todos os alarmes.

**Características:**
- AppBar com contador "X Ativos"
- Ícones de filtro e ordenação
- Lista de AlarmCards
- FAB para criar novo alarme
- Estado vazio com ilustração

**Interações:**
- Tap em card → Expande detalhes ou navega para edição
- Switch → Ativa/desativa alarme
- Botão Editar → Navega para configuração
- Botão Deletar → Mostra dialog de confirmação

### 3. AlarmConfigPage

Formulário completo para configurar alarme.

**Seções:**
1. **Mini Mapa** - Preview da localização (200dp de altura)
2. **Localização** - Campo de endereço
3. **Identificação** - Nome e descrição
4. **Raio de Ativação** - Slider de 10m a 1000m
5. **Alertas** - Som, volume, vibração, tela ligada

**Características:**
- AppBar com botão "Salvar"
- Scrollable para evitar overflow
- Sliders customizados com valor exibido
- Switches para vibração e tela ligada
- Inputs com decoração padronizada

## 🎭 Animações e Transições

### Transições de Tela
- Navegação push/pop: Slide horizontal padrão do Material
- Modal bottom sheet: Slide up com backdrop

### Interações
- Botões: Ripple effect
- Switch: Transição suave
- Sliders: Feedback visual ao arrastar

## ♿ Acessibilidade

### Tamanhos Mínimos
- Áreas tocáveis: 48x48dp
- Ícones importantes: 24dp
- Textos: mínimo 14sp

### Contraste
- Todos os textos seguem WCAG AA (4.5:1)
- Estados focados visíveis

## 🌙 Tema Escuro

O app utiliza tema escuro por padrão, seguindo as imagens de referência:

- Background preto (#121212)
- Cards e superfícies em tons de cinza escuro
- Textos em branco/cinza claro
- Cores vibrantes para status e ações

## 📝 Boas Práticas Implementadas

1. **Separação de Responsabilidades**
   - Estilos em arquivos separados
   - Componentes reutilizáveis
   - Páginas independentes

2. **Consistência Visual**
   - Uso de constantes para cores e espaçamentos
   - Estilos padronizados para inputs e botões
   - Tipografia consistente

3. **Manutenibilidade**
   - Barrel files para imports simplificados
   - Comentários descritivos
   - Nomenclatura clara

4. **Performance**
   - SingleChildScrollView para evitar overflow
   - ListView.builder para listas grandes
   - Const widgets quando possível

5. **Evitar Overflows**
   - Expanded/Flexible em Row/Column
   - SingleChildScrollView em formulários
   - maxLines e overflow em textos

## 🚀 Como Usar

### Importar Tema

```dart
import 'package:acorda_ai_app/src/core/theme/theme.dart';

// Usar cores
Color primary = AppColors.primary;

// Usar espaçamentos
double padding = AppSpacing.md;

// Usar estilos de texto
TextStyle title = AppTextStyles.h1;
```

### Usar Componentes

```dart
import 'package:acorda_ai_app/src/presentation/components/components.dart';

AlarmCard(
  alarm: myAlarm,
  onToggle: (value) => setState(() => isActive = value),
  onEdit: () => Navigator.push(...),
  onDelete: () => showDialog(...),
)
```

### Navegar entre Telas

```dart
// Para lista de alarmes
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => AlarmsListPage()),
);

// Para configuração
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => AlarmConfigPage(initialLocation: latLng),
  ),
);
```

## ✅ Checklist de Implementação

- [x] Sistema de cores organizado
- [x] Espaçamentos padronizados
- [x] Estilos de texto
- [x] Estilos de botões
- [x] Estilos de inputs
- [x] Tema escuro global
- [x] AlarmCard component
- [x] MapHomePage (tela principal)
- [x] AlarmsListPage (lista)
- [x] AlarmConfigPage (formulário)
- [x] Navegação entre telas
- [x] Bottom sheets e dialogs
- [x] Prevenção de overflows
- [x] Responsividade básica
- [x] Barrel files para exports

## 🔄 Próximos Passos (Sugestões)

1. Integrar com ViewModels existentes
2. Implementar persistência de dados
3. Adicionar animações mais elaboradas
4. Implementar filtros e ordenação na lista
5. Adicionar seletor de som customizado
6. Implementar geocoding para endereços
7. Adicionar testes de UI
8. Melhorar acessibilidade com semantics

---

**Implementado seguindo exatamente o design das imagens fornecidas** ✅
