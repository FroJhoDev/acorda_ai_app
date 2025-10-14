# Estrutura do Projeto AcordaAI App

## Organização de Diretórios

```
lib/
├── initialization.dart      # Inicialização e configuração do app
├── main.dart               # Ponto de entrada
└── src/
    ├── app.dart           # Widget principal do app
    ├── src.dart           # Arquivo barrel para exports
    ├── core/             # Funcionalidades e utilitários centrais
    │   ├── config/       # Configuração do app
    │   ├── constants/    # Constantes e enums
    │   ├── error/        # Tratamento de erros
    │   ├── injections/   # Configuração de injeção de dependência
    │   ├── services/     # Serviços centrais
    │   │   └── database/ # Implementações de serviços de banco de dados
    │   ├── theme/        # Tema do app
    │   └── utils/        # Funções utilitárias
    │
    ├── data/            # Camada de dados
    │   ├── datasources/ # Implementações de fontes de dados
    │   ├── models/      # Modelos de dados
    │   └── repositories/ # Implementações de repositórios
    │
    ├── domain/         # Camada de domínio
    │   ├── entities/   # Entidades de negócio
    │   ├── repositories/ # Interfaces de repositórios
    │   └── usecases/   # Casos de uso
    │
    └── presentation/   # Camada de apresentação
        ├── components/ # Componentes de UI reutilizáveis
        ├── pages/     # Páginas/telas do app
        └── viewmodels/ # ViewModels para gerenciamento de estado

assets/               # Assets estáticos
├── fonts/           # Fontes customizadas
└── images/         # Assets de imagem

docs/               # Documentação do projeto
├── ARCHITECTURE.md # Documentação da arquitetura
└── STRUCTURE.md    # Documentação da estrutura do projeto

test/              # Arquivos de teste
├── unit/          # Testes unitários
├── widget/        # Testes de widget
└── integration/   # Testes de integração
```

## Diretórios e Arquivos Principais

### `lib/`

- Diretório principal do código fonte
- Contém a lógica central da aplicação
- Organizado em módulos baseados em features

### `src/core/`

- Contém utilitários e serviços da aplicação
- Lida com preocupações transversais
- Implementa funcionalidades centrais usadas em todas as features

### `src/data/`

- Implementa acesso e persistência de dados
- Contém implementações de repositórios
- Gerencia modelos de dados e transformações

### `src/domain/`

- Contém lógica de negócio
- Define interfaces de repositórios
- Implementa casos de uso

### `src/presentation/`

- Contém todo o código relacionado à UI
- Organiza telas em páginas
- Gerencia ViewModels e estado

### `assets/`

- Armazena recursos estáticos
- Organizado por tipo de recurso (fontes, imagens, etc.)

### `test/`

- Contém todos os arquivos de teste
- Organizado por tipo de teste
- Espelha a estrutura do código fonte

## Convenções de Nomenclatura

### Arquivos Dart

- Use snake_case para nomes de arquivos
- Sufixe arquivos baseado no seu tipo:
  - `*_page.dart` para páginas
  - `*_viewmodel.dart` para ViewModels
  - `*_repository.dart` para repositórios
  - `*_service.dart` para serviços

### Arquivos de Teste

- Espelhe o nome do arquivo sendo testado
- Adicione `_test` ao nome do arquivo
- Exemplo: `home_page_test.dart`

## Organização de Imports

1. Imports do Dart/Flutter
2. Imports de pacotes
3. Imports da aplicação
4. Imports relativos

## Arquivos de Export

- Cada diretório contém um arquivo barrel (ex: `src.dart`)
- Exporta todas as APIs públicas do diretório
- Simplifica imports em outras partes da aplicação
