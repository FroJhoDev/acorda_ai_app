![Dart Version](https://img.shields.io/static/v1?label=dart&message=4.0.9&color=00579d)
![Flutter Version](https://img.shields.io/static/v1?label=flutter&message=3.24.0&color=42a5f5)
![Null Safety](https://img.shields.io/static/v1?label=null-safety&message=done&color=success)

# **🍼 Vem Bebê: Lista de Enxoval**

## 📃 Sobre

> **Vem Bebê** é o aplicativo ideal para pais e mães que desejam organizar o enxoval de seus bebês de maneira prática e personalizada. Com listas pré-definidas, recursos de personalização e acompanhamento de progresso, o app torna o planejamento do enxoval simples e eficiente, mesmo offline.

### **Principais Recursos**

- 📋 **Listas de Enxoval Prontas**: Comece com sugestões organizadas por categoria.
- ✏️ **Personalização**: Crie, edite e ajuste suas listas conforme suas necessidades.
- ✅ **Controle de Progresso**: Marque itens como comprados e acompanhe o status do enxoval.
- 🌐 **Uso Offline**: Acesse e gerencie suas listas sem precisar de internet.

### **Screenshots**

<p align="middle">
    <img src="https://github.com/FroJhoDev/vem_bebe_app/blob/develop/assets/docs/01.png" width="23%">
    <img src="https://github.com/FroJhoDev/vem_bebe_app/blob/develop/assets/docs/02.png" width="23%">
    <img src="https://github.com/FroJhoDev/vem_bebe_app/blob/develop/assets/docs/03.png" width="23%">
    <img src="https://github.com/FroJhoDev/vem_bebe_app/blob/develop/assets/docs/04.png" width="23%">
</p>

---

## 🚀 Configurando para Utilizar

### **Instalação do Flutter**

Antes de iniciar, certifique-se de que o Flutter SDK está instalado e configurado corretamente em sua máquina. Verifique com o comando:

```bash
flutter doctor
```

Caso não tenha o Flutter instalado, siga as instruções detalhadas na [Documentação Oficial do Flutter](https://docs.flutter.dev/get-started/install).

### **Inicializando o Projeto**

1. Clone o repositório:
   ```bash
   git clone git@github.com:seu-repositorio/vem-bebe.git
   ```
2. Acesse a pasta do projeto:
   ```bash
   cd vem-bebe
   ```
3. Instale as dependências:
   ```bash
   flutter pub get
   ```
4. Abra o projeto no editor de sua preferência:
   ```bash
   code .
   ```

---

## 🧩 Guinde Lines

### **Commits Pattern**

- **feat:** Adição de novas funcionalidades.
- **fix:** Correções de bugs.
- **style:** Alterações de estilo ou formatação sem impacto funcional.
- **refactor:** Melhorias na estrutura do código sem alterar funcionalidades.
- **docs:** Atualizações ou adições de documentação.
- **perf:** Otimizações de desempenho.
- **test:** Alterações ou adições em testes automatizados.
- **chore:** Alterações em configurações ou dependências.

Exemplo:

```bash
git commit -m "feat: adiciona funcionalidade de personalização de listas"
```

### **Branch Pattern**

- **main:** Versão estável do código.
- **develop:** Ambiente de integração para novas funcionalidades.
- **task-specific:** Branchs criadas a partir de _develop_.

Exemplo:

```bash
git checkout -b feature/list-customization
```

---

## 📐 Arquitetura Geral

### **Princípios**

- **SOC (Separation of Concerns):** Separação de responsabilidades no código.
- **DRY (Don't Repeat Yourself):** Evite redundâncias.
- **KISS (Keep It Simple, Silly):** Mantenha as soluções simples.

### **Metodologias e Design**

- **Clean Architecture**
- **MVVM**
- **Repositórios e Componentização**
- **Gerenciamento de Estado com BloC**

### **Gerenciamento de Estado**

<p align="middle">  
    <img src="https://via.placeholder.com/800x400.png?text=State+Management+Flow" alt="Fluxo de Gerenciamento de Estado" />  
</p>

---

## 🗃️ Definition

### **Pacotes e Ferramentas**

- **go_router**: Navegação declarativa e flexível.
- **flutter_bloc**: Gerenciamento de estado baseado em eventos.
- **intl**: Suporte a internacionalização.
- **get_it**: Injeção de dependência simplificada.
- **equatable**: Comparação de objetos eficiente.
- **freezed_annotation**: Geração de código para classes imutáveis.
- **json_annotation**: Serialização de JSON.
- **fpdart**: Utilitários funcionais para Dart.
- **sqflite**: Banco de dados local SQLite.
- **path_provider**: Acesso a diretórios no dispositivo.
- **path**: Manipulação de caminhos.
- **gap**: Layouts espaçados.
- **lottie**: Animações vetoriais.
- **toastification**: Exibição de notificações internas.
- **package_info_plus**: Informações do app e do dispositivo.

### **Princípios Básicos**

- Pequenos Commits para rastreabilidade.
- Separação de responsabilidades claras.
- Boas práticas como DRY e KISS.

### **Funcionalidades Dart/Flutter**

- Null Safety
- Widgets Stateless e Stateful
- Async/Await para operações assíncronas.
- Estrutura modular com repositórios e cubits.

---
