# 🏢 Sistema ACL PostgreSQL - POC Multi-tenant

## 📋 Descrição

**POC (Proof of Concept)** de um sistema de controle de acesso granular baseado em **ACL (Access Control List)** e **RLS (Row Level Security)** do PostgreSQL, implementando arquitetura multi-tenant com isolamento total entre organizações.

## 🎯 Objetivo

Demonstrar um modelo de arquitetura simples que controla acessos por **Role** e **Perfil de usuário**, criando políticas **RLS** baseadas na tabela `acls` para garantir segurança e isolamento de dados.

## 🏗️ Arquitetura

- **Multi-tenancy** com isolamento total entre organizações
- **Row Level Security (RLS)** nativo do PostgreSQL
- **Sistema de permissões por bitmask** (READ, WRITE, APPROVE, SHARE, DELETE)
- **Herança de permissões em cascata** (Organization → Area → Folder → Document)
- **Controle granular por recurso** via tabela ACL

## 🚀 Funcionalidades

- ✅ **Controle de Acesso Granular** - Permissões específicas por recurso
- ✅ **Multi-tenant** - Isolamento total entre organizações
- ✅ **Workflows** - Etapas de aprovação configuráveis
- ✅ **Formulários Dinâmicos** - Intake com perguntas configuráveis
- ✅ **Assinaturas Digitais** - Integração com provedores externos
- ✅ **Sistema Financeiro** - Controle de receitas/despesas
- ✅ **Auditoria Completa** - Log de todas as ações
- ✅ **RLS Automático** - Filtragem transparente de dados

## 📊 Estrutura de Dados

- **3 Organizações** (TechCorp, GlobalCorp, StartupXYZ)
- **9 Áreas** (3 por organização: TI, RH, Financeiro)
- **39 Usuários** (13 por organização: 1 Owner + 6 Managers + 6 Users)
- **43 ACLs** (permissões granulares configuradas)

## 🔐 Sistema de Permissões

### Perfis de Usuário
- **Owner** - Acesso total (31) - Administrador da organização
- **Manager** - READ+WRITE+APPROVE (7) - Gerente de área específica
- **User** - READ+WRITE (3) - Usuário com permissões específicas

### Bitmask de Permissões
- **1** = READ (Leitura)
- **2** = WRITE (Escrita)
- **4** = APPROVE (Aprovação)
- **8** = SHARE (Compartilhamento)
- **16** = DELETE (Exclusão)
- **31** = FULL (Todas as permissões)

## 🛠️ Como Executar

### Pré-requisitos
- PostgreSQL 12+ rodando na porta **5433**
- Usuário `postgres` com permissões de administrador

### Setup Automático
```powershell
.\setup-poc-v2.ps1
```

### Setup Manual
```bash
# 1. Criar banco
psql -h localhost -p 5433 -U postgres -d postgres -c "CREATE DATABASE acl_poc_v2;"

# 2. Executar scripts em ordem
psql -h localhost -p 5433 -U postgres -d acl_poc_v2 -f database/create-tables-v2.sql
psql -h localhost -p 5433 -U postgres -d acl_poc_v2 -f database/acl-setup-v2.sql
psql -h localhost -p 5433 -U postgres -d acl_poc_v2 -f database/insert-basic-data.sql
psql -h localhost -p 5433 -U postgres -d acl_poc_v2 -f config/add-workflows-and-acls.sql
psql -h localhost -p 5433 -U postgres -d acl_poc_v2 -f config/fix-user-permissions.sql

# 3. Executar testes
psql -h localhost -p 5433 -U postgres -d acl_poc_v2 -f tests/test-acl-completo-todas-empresas.sql
```

## 🧪 Testes

O sistema inclui **9 cenários de teste** que demonstram:

- ✅ Isolamento total entre organizações
- ✅ Herança de permissões em cascata
- ✅ Controle granular por recurso
- ✅ Funcionamento do RLS automático
- ✅ Diferentes níveis de acesso (Owner/Manager/User)

## 📁 Estrutura do Projeto

```
postgres-ltree-poc/
├── database/                          # Scripts SQL
│   ├── create-tables-v2.sql          # Criação das tabelas
│   ├── acl-setup-v2.sql              # Configuração ACL + RLS
│   └── insert-basic-data.sql         # Dados de teste
├── config/                           # Configurações
│   ├── add-workflows-and-acls.sql    # Workflows e ACLs
│   └── fix-user-permissions.sql      # Ajustes de permissões
├── tests/                            # Testes
│   └── test-acl-completo-todas-empresas.sql
├── setup-poc-v2.ps1                  # Setup automático
├── diagrama-banco-dados.dbml         # Diagrama do banco
├── documentacao-sistema-acl.html     # Documentação completa
└── explicacao-rls-acl.html          # Explicação técnica
```

## 🔍 Como Funciona o RLS + ACL

1. **Usuário faz consulta** → `SELECT * FROM documents`
2. **PostgreSQL aplica RLS** → Executa políticas automaticamente
3. **Política consulta ACL** → Verifica permissões na tabela `acls`
4. **Retorna apenas dados permitidos** → Filtragem transparente

### Exemplo de Política RLS
```sql
CREATE POLICY document_read_policy ON documents
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM acls
            WHERE subject_id = current_setting('app.current_user_id')::UUID
              AND object_type = 'document'
              AND object_id = documents.id
              AND (perms & 1) = 1  -- Verifica permissão de leitura
        )
    );
```

## 📚 Documentação

- **[Documentação Completa](documentacao-sistema-acl.html)** - Visão geral do sistema
- **[Explicação RLS+ACL](explicacao-rls-acl.html)** - Como funciona tecnicamente
- **[Diagrama do Banco](diagrama-banco-dados.dbml)** - Estrutura visual (use em dbdiagram.io)

## 🎯 Casos de Uso

- **Sistemas corporativos** com múltiplas organizações
- **Aplicações SaaS** com isolamento de dados
- **Sistemas de documentos** com controle granular
- **Workflows de aprovação** com permissões específicas
- **Auditoria e compliance** com rastreabilidade total

## ⚡ Performance

- **RLS nativo** - Filtragem no nível do banco (muito eficiente)
- **Índices otimizados** - Consultas rápidas na tabela ACL
- **Herança inteligente** - Permissões em cascata sem overhead
- **Multi-tenant** - Isolamento sem impacto na performance

## 🔒 Segurança

- **Row Level Security** - Filtragem automática de dados
- **Isolamento total** - Organizações não veem dados de outras
- **Permissões granulares** - Controle específico por recurso
- **Auditoria completa** - Log de todas as ações
- **Bitmask eficiente** - Sistema de permissões otimizado

## 🚀 Próximos Passos

- [ ] Integração com aplicação frontend
- [ ] Testes de performance com volumes maiores
- [ ] Implementação em ambiente de produção
- [ ] Monitoramento e métricas de uso
- [ ] Treinamento da equipe

## 📄 Licença

Este projeto é uma POC para demonstração de conceitos de controle de acesso com PostgreSQL.

## 👨‍💻 Autor

**Samir Zanata** - Desenvolvido como Proof of Concept para demonstrar arquitetura de controle de acesso granular com PostgreSQL RLS + ACL.

---

**🎉 Sistema ACL PostgreSQL V2 - POC Multi-tenant com controle granular de acesso!**

