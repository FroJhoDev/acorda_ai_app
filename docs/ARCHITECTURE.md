# Arquitetura do AcordaAI App

## Visão Geral

Este documento descreve os padrões arquiteturais e decisões de design utilizados no AcordaAI App. A aplicação segue os princípios da Clean Architecture com uma abordagem em camadas para manter a separação de responsabilidades e testabilidade.

## Padrões Arquiteturais

### Clean Architecture

A aplicação está estruturada seguindo os princípios da Clean Architecture, com separação clara entre as seguintes camadas:

1. **Camada de Apresentação** (`/lib/src/presentation/`)

   - Contém todos os componentes de UI (widgets, páginas)
   - Implementa o padrão MVVM (Model-View-ViewModel)
   - Usa ViewModels para gerenciar estado da UI e lógica de negócio
   - Comunica com a camada de domínio através de repositórios

2. **Camada de Domínio** (`/lib/src/domain/`)

   - Contém a lógica de negócio e regras
   - Define interfaces de repositórios
   - Implementa casos de uso
   - Código Dart puro sem dependências do Flutter ou pacotes externos

3. **Camada de Dados** (`/lib/src/data/`)
   - Implementa interfaces de repositórios da camada de domínio
   - Gerencia persistência de dados e comunicação com APIs externas
   - Contém modelos de dados e seus mapeamentos
   - Gerencia armazenamento local usando banco de dados Isar

### Padrões de Design

#### 1. Repository Pattern

- Abstrai fontes de dados por trás de interfaces
- Fornece API limpa para operações de dados
- Implementado no diretório `data/repositories`

#### 2. Injeção de Dependência

- Usa GetIt para injeção de dependência
- Centralizado em `core/injections.dart`
- Permite baixo acoplamento e testabilidade

#### 3. Abstração de Banco de Dados

- Interface genérica `Database<T>` para persistência de dados
- Implementação específica para banco de dados Isar
- Permite fácil troca de soluções de armazenamento

## Tratamento de Erros

- Usa tipo Either do pacote dartz para tratamento de erros
- Classes de exceção customizadas para diferentes tipos de erro
- Relatórios de erro consistentes através das camadas

## Gerenciamento de Estado

- ViewModels extendem ChangeNotifier
- Usa ListenableBuilder para atualizações reativas da UI
- Mantém estado da UI na camada de apresentação

## Dependências

- **Armazenamento Local**: Banco de Dados Local
- **Injeção de Dependência**: GetIt
- **Programação Funcional**: dartz
- **Componentes de UI**: Widgets customizados e Material Design

## Estratégia de Testes

- Testes unitários para lógica de domínio
- Testes de repositório com fontes de dados mockadas
- Testes de ViewModel para lógica da UI
- Testes de widget para componentes da UI

## Considerações Futuras

- Implementação de analytics
- Monitoramento de performance
- Estratégias de cache
