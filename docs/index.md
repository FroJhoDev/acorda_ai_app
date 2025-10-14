# AcordaAI - Aplicativo de Alarmes Baseados em Localização

## 📱 Visão Geral

O **AcordaAI** é um aplicativo mobile inteligente que permite aos usuários criar alarmes baseados em localização geográfica. O aplicativo utiliza geolocalização para detectar quando o usuário está próximo a um local específico e dispara alarmes personalizados automaticamente.

## 🎯 Funcionalidades Principais

### Sistema de Alarmes por Localização
- **Marcação de Pontos**: Usuários podem marcar localizações específicas no mapa
- **Detecção Automática**: Sistema detecta quando o usuário entra na área do alarme
- **Ativação Inteligente**: Alarmes são disparados automaticamente ao chegar no local

### Gestão de Múltiplos Alarmes
- **Alarmes Ilimitados**: Suporte para múltiplos alarmes simultâneos
- **Descrições Personalizadas**: Cada alarme possui descrição única e identificável
- **Configurações Individuais**: Personalização de som, vibração e alertas por alarme

### Interface de Alarme
- **Alerta Visual**: Notificação em tela com informações do alarme
- **Alerta Sonoro**: Reprodução de som personalizado ou padrão
- **Controles Intuitivos**: Opções para pausar, adiar ou desativar o alarme

## 🔧 Especificações Técnicas

### Recursos de Geolocalização
- Utilização de GPS/GNSS para precisão de localização
- Monitoramento em background para detecção contínua

### Arquitetura do Sistema
- **Frontend**: Interface mobile nativa/híbrida
- **Backend**: Serviços de geolocalização e notificações
- **Banco de Dados**: Armazenamento local

## 📋 Casos de Uso

### 🚌 Caso Principal: Alarme de Chegada ao Destino
**Cenário**: Usuário está viajando (ônibus, trem, carona) e quer dormir durante o trajeto
- **Ação**: Marca o local de destino no mapa antes de dormir
- **Funcionamento**: Sistema monitora localização continuamente em background
- **Resultado**: Alarme desperta o usuário automaticamente ao chegar próximo ao destino
- **Benefício**: Permite descansar durante viagens longas sem perder o ponto de descida

### 🚗 Outros Casos de Uso
1. **Viagens de Transporte Público**: Alarme para descer no ponto correto
2. **Caronas e Viagens**: Despertar ao chegar no destino durante trajetos longos
3. **Lembretes de Chegada**: Alertas ao chegar no trabalho, escola ou compromissos

### 💤 Funcionamento Durante o Sono
- **Monitoramento Contínuo**: GPS ativo em background mesmo com tela bloqueada
- **Alarme Eficaz**: Som alto e vibração intensa para despertar o usuário
- **Precisão de Local**: Detecção precisa para evitar alarmes falsos ou tardios

## 🚀 Fluxo de Funcionamento

1. **Configuração**: Usuário seleciona local no mapa e configura alarme
2. **Monitoramento**: Sistema monitora localização em background
3. **Detecção**: Aplicativo identifica entrada na área do alarme
4. **Ativação**: Disparo automático do alarme com notificações configuradas
5. **Interação**: Usuário pode pausar, adiar ou desativar o alarme

## 🎨 Interface do Usuário

### Tela Principal
- Mapa interativo com marcadores de alarmes
- Lista de alarmes ativos e inativos
- Controles de configuração rápida

### Configuração de Alarmes
- Seletor de localização no mapa
- Campos de descrição e personalização
- Teste de alarme e configurações de som