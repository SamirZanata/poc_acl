# 🏢 POC - Sistema ACL PostgreSQL V2

## 📋 Visão Geral

Este repositório contém uma **Proof of Concept (POC)** completa de um sistema de **Controle de Acesso Baseado em Lista (ACL)** usando PostgreSQL, com uma estrutura avançada que inclui workflows, formulários, assinaturas digitais e sistema financeiro.

## 🎯 Objetivo

Demonstrar um sistema completo de permissões granulares para múltiplas organizações (multi-tenant) com isolamento total de dados entre empresas, incluindo funcionalidades avançadas como workflows, formulários e assinaturas.

## 🏗️ Estrutura do Projeto

```
postgres-ltree-poc/
├── database/                          # Scripts SQL
│   ├── create-tables-v2.sql          # Criação das tabelas V2
│   ├── acl-setup-v2.sql              # Configuração ACL + RLS V2
│   └── insert-basic-data.sql         # Dados básicos para teste
├── database-diagram-v2.dbml          # Diagrama completo V2
├── setup-poc-v2.ps1                  # Setup automático Vtratamos nas permissoes de perfil 

├── test-acl-final.sql                # Teste final do sistema ACL funcionando
└── README-V2.md                      # Este arquivo
```

## 🚀 Como Executar

### Pré-requisitos
- PostgreSQL 12+ rodando na porta **5433**
- Usuário `postgres` com permissões de administrador

### 1. Setup Automático (Recomendado)
```powershell
.\setup-poc-v2.ps1
```

### 2. Setup Manual
```powershell
# Executar todos os scripts em ordem
psql -h localhost -p 5433 -U postgres -d acl_poc_v2 -f database/create-tables-v2.sql
psql -h localhost -p 5433 -U postgres -d acl_poc_v2 -f database/acl-setup-v2.sql
psql -h localhost -p 5433 -U postgres -d acl_poc_v2 -f database/insert-basic-data.sql
```

### 3. Verificar Setup
```sql
-- Conectar ao banco
\c acl_poc_v2

-- Verificar dados
SELECT 'Organizações: ' || COUNT(*) FROM organizations;
SELECT 'Áreas: ' || COUNT(*) FROM areas;
SELECT 'Usuários: ' || COUNT(*) FROM users;
SELECT 'ACLs: ' || COUNT(*) FROM acls;
```

## 📊 Cenário Implementado

### 🏢 Organizações (3)
- **TechCorp** - Empresa de tecnologia
- **GlobalCorp** - Empresa de consultoria
- **StartupXYZ** - Startup fintech

### 🏢 Áreas por Organização (9 total)
- **TI** - Tecnologia da Informação
- **RH** - Recursos Humanos  
- **Financeiro** - Área Financeira

### 👥 Usuários por Organização (39 total)
- **1 Owner** - Administrador da organização
- **6 Managers** - 2 gerentes por área
- **6 Users** - 2 usuários normais por área

### 🔐 Permissões (43 ACLs)
- **Owners**: Acesso total (31 = todas as permissões)
- **Managers**: Leitura + Escrita + Aprovação (7)
- **Users**: Leitura + Escrita (3)

## 🛡️ Sistema de Permissões

### Bitmask de Permissões
- **1** = READ (Leitura)
- **2** = WRITE (Escrita)
- **4** = APPROVE (Aprovação)
- **8** = SHARE (Compartilhamento)
- **16** = DELETE (Exclusão)
- **31** = FULL (Todas as permissões)

### Hierarquia de Acesso
1. **Organization** → **Area** → **Folder** → **Document**
2. Permissões herdam da hierarquia superior
3. Isolamento total entre organizações

## 🆕 Funcionalidades V2

### 📋 Formulários (Intake)
- Criação de formulários dinâmicos
- Perguntas e opções configuráveis
- Respostas e validações

### 🔄 Workflows Avançados
- Etapas de aprovação
- Aprovadores múltiplos
- Cards de workflow
- Lembretes automáticos

### ✍️ Assinaturas Digitais
- Integração com provedores externos
- Signatários ordenados
- Controle de status

### 💰 Sistema Financeiro
- Categorias de entradas
- Controle de receitas/despesas
- Vinculação com documentos

### 📊 Auditoria Completa
- Log de todas as ações
- Estados antes/depois
- Rastreabilidade total

## 🧪 Testes Práticos

### Teste Final do Sistema ACL
```powershell
psql -h localhost -p 5433 -U postgres -d acl_poc_v2 -f test-acl-final.sql
```

## 📚 Documentação

- **[Diagrama V2](database-diagram-v2.dbml)** - Diagrama completo da estrutura V2
- **[README V2](README-V2.md)** - Este arquivo com instruções completas

## 🔧 Configuração do Banco

- **Host**: localhost
- **Porta**: 5433
- **Banco**: acl_poc_v2
- **Usuário**: postgres

## ✅ Funcionalidades Implementadas

- ✅ Multi-tenancy com isolamento total
- ✅ Hierarquia de permissões (Owner > Manager > User)
- ✅ Row Level Security (RLS)
- ✅ Sistema de perfis e ações
- ✅ Workflows com etapas avançadas
- ✅ Hierarquia de pastas
- ✅ Formulários dinâmicos (intake)
- ✅ Assinaturas digitais
- ✅ Sistema financeiro
- ✅ Auditoria completa
- ✅ Controle de acesso granular
- ✅ Funções PL/pgSQL para verificação de permissões

## 🎯 Casos de Uso

1. **Isolamento entre empresas**: Usuários de uma organização não veem dados de outras
2. **Controle granular**: Permissões específicas por recurso
3. **Hierarquia de acesso**: Permissões herdam da estrutura organizacional
4. **Workflows de aprovação**: Documentos seguem fluxos configuráveis
5. **Formulários dinâmicos**: Coleta de dados estruturada
6. **Assinaturas digitais**: Contratos e documentos assinados eletronicamente
7. **Controle financeiro**: Entradas e saídas vinculadas a documentos
8. **Auditoria completa**: Rastreabilidade de todas as ações

## 📊 Estrutura de Tabelas (V2)

### 🏢 Organizações & Tenant
- `organizations` - Empresas
- `organization_whitelabel_setup` - Configurações de marca
- `organization_limits` - Limites por organização
- `organization_api_key` - Chaves de API

### 👥 Usuários & Associações
- `users` - Usuários do sistema
- `users_organizations` - Associação usuário-organização
- `user_accounts` - Contas de usuário
- `users_areas` - Associação usuário-área

### 🔐 Perfis & Ações
- `profiles` - Perfis de usuário
- `system_actions` - Ações do sistema
- `profile_system_actions` - Associação perfil-ação

### 📁 Arquivos & Documentos
- `folders` - Pastas (hierárquicas)
- `documents` - Documentos
- `dependent_document_types` - Tipos de documentos
- `document_models` - Modelos de documentos
- `document_attachments` - Anexos

### 📋 Formulários
- `forms` - Formulários
- `questions` - Perguntas
- `question_options` - Opções de resposta
- `form_requests` - Solicitações de formulário
- `form_request_answers` - Respostas

### 🔄 Workflows
- `workflows` - Fluxos de trabalho
- `workflow_steps` - Etapas do workflow
- `document_workflows` - Documentos em workflow
- `workflow_steps_approvers` - Aprovadores
- `workflow_card` - Cards de workflow
- `workflow_card_external_accesses` - Acessos externos
- `workflow_reminders` - Lembretes

### ✅ Checklists & Tarefas
- `checklist_models` - Modelos de checklist
- `task_models` - Modelos de tarefa
- `checklist_card_workflow_step` - Checklists por etapa
- `tasks_checklist_card` - Tarefas do checklist

### ✍️ Assinaturas
- `signatures` - Assinaturas
- `signers` - Signatários

### 💰 Financeiro
- `financial_entry_categories` - Categorias financeiras
- `financial_entries` - Entradas financeiras

### 🛡️ ACL & Auditoria
- `acls` - Controle de acesso
- `log_actions` - Log de ações

---

**🎉 Sistema ACL V2 completo com funcionalidades avançadas!**
