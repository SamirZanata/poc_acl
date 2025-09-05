-- =====================================================
-- POC DADOS REAIS - SISTEMA ACL V2
-- =====================================================
-- Script para inserir dados realistas e demonstrar o funcionamento

-- =====================================================
-- LIMPAR DADOS EXISTENTES
-- =====================================================
TRUNCATE TABLE acls, users_areas, users_organizations, users, profiles, system_actions, profile_system_actions CASCADE;

-- =====================================================
-- INSERIR PERFIS E AÇÕES
-- =====================================================
INSERT INTO profiles (id, name, description) VALUES
('11111111-1111-1111-1111-111111111111', 'Owner', 'Proprietário da organização - Acesso total'),
('22222222-2222-2222-2222-222222222222', 'Manager', 'Gerente de área - Acesso total à área específica'),
('33333333-3333-3333-3333-333333333333', 'User', 'Usuário comum - Acesso limitado por recurso');

INSERT INTO system_actions (id, name, description) VALUES
('11111111-1111-1111-1111-111111111111', 'read', 'Leitura de dados'),
('22222222-2222-2222-2222-222222222222', 'write', 'Escrita/Modificação'),
('33333333-3333-3333-3333-333333333333', 'approve', 'Aprovação de documentos'),
('44444444-4444-4444-4444-444444444444', 'share', 'Compartilhamento'),
('55555555-5555-5555-5555-555555555555', 'delete', 'Exclusão de dados');

-- Associar ações aos perfis
INSERT INTO profile_system_actions (profile_id, system_action_id) VALUES
-- Owner tem todas as ações
('11111111-1111-1111-1111-111111111111', '11111111-1111-1111-1111-111111111111'),
('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222'),
('11111111-1111-1111-1111-111111111111', '33333333-3333-3333-3333-333333333333'),
('11111111-1111-1111-1111-111111111111', '44444444-4444-4444-4444-444444444444'),
('11111111-1111-1111-1111-111111111111', '55555555-5555-5555-5555-555555555555'),
-- Manager tem read, write, approve
('22222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111'),
('22222222-2222-2222-2222-222222222222', '22222222-2222-2222-2222-222222222222'),
('22222222-2222-2222-2222-222222222222', '33333333-3333-3333-3333-333333333333'),
-- User tem read, write
('33333333-3333-3333-3333-333333333333', '11111111-1111-1111-1111-111111111111'),
('33333333-3333-3333-3333-333333333333', '22222222-2222-2222-2222-222222222222');

-- =====================================================
-- INSERIR ORGANIZAÇÕES REALISTAS
-- =====================================================
INSERT INTO organizations (id, name, cnpj, segment, sector) VALUES
('11111111-1111-1111-1111-111111111111', 'TechCorp Solutions', '12.345.678/0001-90', 'Tecnologia', 'Software'),
('22222222-2222-2222-2222-222222222222', 'GlobalCorp Consultoria', '98.765.432/0001-10', 'Consultoria', 'Serviços'),
('33333333-3333-3333-3333-333333333333', 'StartupXYZ Fintech', '11.222.333/0001-44', 'Fintech', 'Serviços Financeiros');

-- =====================================================
-- INSERIR ÁREAS REALISTAS
-- =====================================================
INSERT INTO areas (id, organization_id, name, description) VALUES
-- TechCorp
('a1111111-1111-1111-1111-111111111111', '11111111-1111-1111-1111-111111111111', 'Desenvolvimento', 'Equipe de desenvolvimento de software'),
('a1111111-1111-1111-1111-111111111112', '11111111-1111-1111-1111-111111111111', 'Vendas', 'Equipe comercial e vendas'),
('a1111111-1111-1111-1111-111111111113', '11111111-1111-1111-1111-111111111111', 'Suporte', 'Atendimento ao cliente e suporte técnico'),

-- GlobalCorp
('a2222222-2222-2222-2222-222222222221', '22222222-2222-2222-2222-222222222222', 'Contabilidade', 'Contabilidade e finanças'),
('a2222222-2222-2222-2222-222222222222', '22222222-2222-2222-2222-222222222222', 'Auditoria', 'Auditoria interna e externa'),
('a2222222-2222-2222-2222-222222222223', '22222222-2222-2222-2222-222222222222', 'Consultoria', 'Consultoria estratégica'),

-- StartupXYZ
('a3333333-3333-3333-3333-333333333331', '33333333-3333-3333-3333-333333333333', 'TI', 'Tecnologia da informação'),
('a3333333-3333-3333-3333-333333333332', '33333333-3333-3333-3333-333333333333', 'RH', 'Recursos humanos'),
('a3333333-3333-3333-3333-333333333333', '33333333-3333-3333-3333-333333333333', 'Financeiro', 'Área financeira e contábil');

-- =====================================================
-- INSERIR USUÁRIOS REALISTAS
-- =====================================================
INSERT INTO users (id, organization_id, name, email) VALUES
-- TechCorp
('11111111-1111-1111-1111-111111111111', '11111111-1111-1111-1111-111111111111', 'João Silva', 'joao.silva@techcorp.com'),
('11111111-1111-1111-1111-111111111112', '11111111-1111-1111-1111-111111111111', 'Maria Santos', 'maria.santos@techcorp.com'),
('11111111-1111-1111-1111-111111111113', '11111111-1111-1111-1111-111111111111', 'Pedro Costa', 'pedro.costa@techcorp.com'),

-- GlobalCorp
('22222222-2222-2222-2222-222222222221', '22222222-2222-2222-2222-222222222222', 'Ana Oliveira', 'ana.oliveira@globalcorp.com'),
('22222222-2222-2222-2222-222222222222', '22222222-2222-2222-2222-222222222222', 'Carlos Lima', 'carlos.lima@globalcorp.com'),
('22222222-2222-2222-2222-222222222223', '22222222-2222-2222-2222-222222222223', 'Lucia Ferreira', 'lucia.ferreira@globalcorp.com'),

-- StartupXYZ
('33333333-3333-3333-3333-333333333331', '33333333-3333-3333-3333-333333333333', 'Roberto Alves', 'roberto.alves@startupxyz.com'),
('33333333-3333-3333-3333-333333333332', '33333333-3333-3333-3333-333333333333', 'Fernanda Rocha', 'fernanda.rocha@startupxyz.com'),
('33333333-3333-3333-3333-333333333333', '33333333-3333-3333-3333-333333333333', 'Marcos Pereira', 'marcos.pereira@startupxyz.com');

-- =====================================================
-- ASSOCIAR USUÁRIOS ÀS ORGANIZAÇÕES
-- =====================================================
INSERT INTO users_organizations (user_id, organization_id, profile_id, is_owner) VALUES
-- TechCorp
('11111111-1111-1111-1111-111111111111', '11111111-1111-1111-1111-111111111111', '11111111-1111-1111-1111-111111111111', true),  -- Owner
('11111111-1111-1111-1111-111111111112', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', false), -- Manager
('11111111-1111-1111-1111-111111111113', '11111111-1111-1111-1111-111111111111', '33333333-3333-3333-3333-333333333333', false), -- User

-- GlobalCorp
('22222222-2222-2222-2222-222222222221', '22222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111', true),  -- Owner
('22222222-2222-2222-2222-222222222222', '22222222-2222-2222-2222-222222222222', '22222222-2222-2222-2222-222222222222', false), -- Manager
('22222222-2222-2222-2222-222222222223', '22222222-2222-2222-2222-222222222222', '33333333-3333-3333-3333-333333333333', false), -- User

-- StartupXYZ
('33333333-3333-3333-3333-333333333331', '33333333-3333-3333-3333-333333333333', '11111111-1111-1111-1111-111111111111', true),  -- Owner
('33333333-3333-3333-3333-333333333332', '33333333-3333-3333-3333-333333333333', '22222222-2222-2222-2222-222222222222', false), -- Manager
('33333333-3333-3333-3333-333333333333', '33333333-3333-3333-3333-333333333333', '33333333-3333-3333-3333-333333333333', false); -- User

-- =====================================================
-- ASSOCIAR USUÁRIOS ÀS ÁREAS
-- =====================================================
INSERT INTO users_areas (user_id, area_id, profile_id) VALUES
-- TechCorp - Desenvolvimento
('11111111-1111-1111-1111-111111111111', 'a1111111-1111-1111-1111-111111111111', '11111111-1111-1111-1111-111111111111'), -- Owner
('11111111-1111-1111-1111-111111111112', 'a1111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222'), -- Manager
('11111111-1111-1111-1111-111111111113', 'a1111111-1111-1111-1111-111111111111', '33333333-3333-3333-3333-333333333333'), -- User

-- GlobalCorp - Contabilidade
('22222222-2222-2222-2222-222222222221', 'a2222222-2222-2222-2222-222222222221', '11111111-1111-1111-1111-111111111111'), -- Owner
('22222222-2222-2222-2222-222222222222', 'a2222222-2222-2222-2222-222222222221', '22222222-2222-2222-2222-222222222222'), -- Manager
('22222222-2222-2222-2222-222222222223', 'a2222222-2222-2222-2222-222222222221', '33333333-3333-3333-3333-333333333333'), -- User

-- StartupXYZ - Financeiro
('33333333-3333-3333-3333-333333333331', 'a3333333-3333-3333-3333-333333333333', '11111111-1111-1111-1111-111111111111'), -- Owner
('33333333-3333-3333-3333-333333333332', 'a3333333-3333-3333-3333-333333333333', '22222222-2222-2222-2222-222222222222'), -- Manager
('33333333-3333-3333-3333-333333333333', 'a3333333-3333-3333-3333-333333333333', '33333333-3333-3333-3333-333333333333'); -- User

-- =====================================================
-- INSERIR PASTAS REALISTAS
-- =====================================================
INSERT INTO folders (id, area_id, name) VALUES
-- TechCorp - Desenvolvimento
('f1111111-1111-1111-1111-111111111111', 'a1111111-1111-1111-1111-111111111111', 'Projetos Ativos'),
('f1111111-1111-1111-1111-111111111112', 'a1111111-1111-1111-1111-111111111111', 'Documentação Técnica'),
('f1111111-1111-1111-1111-111111111113', 'a1111111-1111-1111-1111-111111111111', 'Contratos de Cliente'),

-- GlobalCorp - Contabilidade
('f2222222-2222-2222-2222-222222222221', 'a2222222-2222-2222-2222-222222222221', 'Demonstrativos Financeiros'),
('f2222222-2222-2222-2222-222222222222', 'a2222222-2222-2222-2222-222222222221', 'Relatórios Contábeis'),
('f2222222-2222-2222-2222-222222222223', 'a2222222-2222-2222-2222-222222222221', 'Auditoria Interna'),

-- StartupXYZ - Financeiro
('f3333333-3333-3333-3333-333333333331', 'a3333333-3333-3333-3333-333333333333', 'Relatórios Mensais'),
('f3333333-3333-3333-3333-333333333332', 'a3333333-3333-3333-3333-333333333333', 'Orçamentos'),
('f3333333-3333-3333-3333-333333333333', 'a3333333-3333-3333-3333-333333333333', 'Análises de Investimento');

-- =====================================================
-- INSERIR DOCUMENTOS REALISTAS
-- =====================================================
INSERT INTO documents (id, folder_id, name, mime, size, resume, value, effective_date, expiry_date) VALUES
-- TechCorp - Projetos
('d1111111-1111-1111-1111-111111111111', 'f1111111-1111-1111-1111-111111111111', 'Projeto E-commerce v2.0', 'application/pdf', 2048576, 'Especificações técnicas do novo sistema de e-commerce', 150000.00, '2024-01-15', '2024-12-31'),
('d1111111-1111-1111-1111-111111111112', 'f1111111-1111-1111-1111-111111111111', 'API REST Documentation', 'application/pdf', 1024000, 'Documentação completa da API REST', 0.00, '2024-02-01', '2025-02-01'),
('d1111111-1111-1111-1111-111111111113', 'f1111111-1111-1111-1111-111111111111', 'Contrato Cliente ABC Corp', 'application/pdf', 512000, 'Contrato de desenvolvimento para ABC Corp', 75000.00, '2024-01-01', '2024-06-30'),

-- GlobalCorp - Contabilidade
('d2222222-2222-2222-2222-222222222221', 'f2222222-2222-2222-2222-222222222221', 'Balanço Patrimonial 2023', 'application/pdf', 1536000, 'Demonstrativo financeiro anual', 0.00, '2024-01-01', '2024-12-31'),
('d2222222-2222-2222-2222-222222222222', 'f2222222-2222-2222-2222-222222222221', 'DRE 2023', 'application/pdf', 768000, 'Demonstração do Resultado do Exercício', 0.00, '2024-01-01', '2024-12-31'),
('d2222222-2222-2222-2222-222222222223', 'f2222222-2222-2222-2222-222222222221', 'Relatório de Auditoria Q1', 'application/pdf', 1024000, 'Relatório trimestral de auditoria', 0.00, '2024-03-31', '2024-12-31'),

-- StartupXYZ - Financeiro
('d3333333-3333-3333-3333-333333333331', 'f3333333-3333-3333-3333-333333333331', 'Relatório Financeiro Q1 2024', 'application/pdf', 1280000, 'Análise financeira do primeiro trimestre', 0.00, '2024-03-31', '2024-12-31'),
('d3333333-3333-3333-3333-333333333332', 'f3333333-3333-3333-3333-333333333331', 'Orçamento 2024', 'application/pdf', 896000, 'Planejamento orçamentário anual', 0.00, '2024-01-01', '2024-12-31'),
('d3333333-3333-3333-3333-333333333333', 'f3333333-3333-3333-3333-333333333331', 'Análise de Investimentos', 'application/pdf', 640000, 'Estudo de viabilidade de novos investimentos', 0.00, '2024-02-15', '2024-12-31');

-- =====================================================
-- INSERIR WORKFLOWS REALISTAS
-- =====================================================
INSERT INTO workflows (id, area_id, name, description, is_active) VALUES
-- TechCorp
('w1111111-1111-1111-1111-111111111111', 'a1111111-1111-1111-1111-111111111111', 'Aprovação de Projetos', 'Workflow para aprovação de novos projetos de desenvolvimento', true),
('w1111111-1111-1111-1111-111111111112', 'a1111111-1111-1111-1111-111111111111', 'Code Review', 'Processo de revisão de código', true),

-- GlobalCorp
('w2222222-2222-2222-2222-222222222221', 'a2222222-2222-2222-2222-222222222221', 'Aprovação Contábil', 'Workflow para aprovação de documentos contábeis', true),
('w2222222-2222-2222-2222-222222222222', 'a2222222-2222-2222-2222-222222222221', 'Auditoria Externa', 'Processo de auditoria externa', true),

-- StartupXYZ
('w3333333-3333-3333-3333-333333333331', 'a3333333-3333-3333-3333-333333333333', 'Aprovação Financeira', 'Workflow para aprovação de despesas e investimentos', true),
('w3333333-3333-3333-3333-333333333332', 'a3333333-3333-3333-3333-333333333333', 'Relatórios Mensais', 'Processo de geração e aprovação de relatórios', true);

-- =====================================================
-- INSERIR FORMULÁRIOS REALISTAS
-- =====================================================
INSERT INTO forms (id, area_id, name, description, form_schema) VALUES
-- TechCorp
('form1111-1111-1111-1111-111111111111', 'a1111111-1111-1111-1111-111111111111', 'Solicitação de Projeto', 'Formulário para solicitar novos projetos', '{"fields": [{"name": "nome_projeto", "type": "text", "required": true}, {"name": "descricao", "type": "textarea", "required": true}, {"name": "orcamento", "type": "number", "required": true}]}'),

-- GlobalCorp
('form2222-2222-2222-2222-222222222221', 'a2222222-2222-2222-2222-222222222221', 'Relatório Contábil', 'Formulário para relatórios contábeis', '{"fields": [{"name": "periodo", "type": "date", "required": true}, {"name": "tipo_relatorio", "type": "select", "options": ["Balanço", "DRE", "DFC"], "required": true}]}'),

-- StartupXYZ
('form3333-3333-3333-3333-333333333331', 'a3333333-3333-3333-3333-333333333333', 'Solicitação de Investimento', 'Formulário para solicitar investimentos', '{"fields": [{"name": "valor", "type": "number", "required": true}, {"name": "justificativa", "type": "textarea", "required": true}, {"name": "retorno_esperado", "type": "number", "required": true}]}');

-- =====================================================
-- INSERIR ACLs REALISTAS
-- =====================================================
INSERT INTO acls (subject_id, object_type, object_id, perms) VALUES
-- Owners têm acesso total às suas organizações
('11111111-1111-1111-1111-111111111111', 'organization', '11111111-1111-1111-1111-111111111111', 31), -- TechCorp Owner
('22222222-2222-2222-2222-222222222221', 'organization', '22222222-2222-2222-2222-222222222222', 31), -- GlobalCorp Owner
('33333333-3333-3333-3333-333333333331', 'organization', '33333333-3333-3333-3333-333333333333', 31), -- StartupXYZ Owner

-- Managers têm acesso às suas áreas
('11111111-1111-1111-1111-111111111112', 'area', 'a1111111-1111-1111-1111-111111111111', 7), -- TechCorp Desenvolvimento Manager
('22222222-2222-2222-2222-222222222222', 'area', 'a2222222-2222-2222-2222-222222222221', 7), -- GlobalCorp Contabilidade Manager
('33333333-3333-3333-3333-333333333332', 'area', 'a3333333-3333-3333-3333-333333333333', 7), -- StartupXYZ Financeiro Manager

-- Users têm acesso básico às suas áreas
('11111111-1111-1111-1111-111111111113', 'area', 'a1111111-1111-1111-1111-111111111111', 3), -- TechCorp Desenvolvimento User
('22222222-2222-2222-2222-222222222223', 'area', 'a2222222-2222-2222-2222-222222222221', 3), -- GlobalCorp Contabilidade User
('33333333-3333-3333-3333-333333333333', 'area', 'a3333333-3333-3333-3333-333333333333', 3), -- StartupXYZ Financeiro User

-- ACLs específicos para documentos (demonstração de controle granular)
('11111111-1111-1111-1111-111111111113', 'document', 'd1111111-1111-1111-1111-111111111111', 1), -- User pode ler Projeto E-commerce
('11111111-1111-1111-1111-111111111113', 'document', 'd1111111-1111-1111-1111-111111111112', 1), -- User pode ler API Documentation
('22222222-2222-2222-2222-222222222223', 'document', 'd2222222-2222-2222-2222-222222222221', 1), -- User pode ler Balanço 2023
('22222222-2222-2222-2222-222222222223', 'document', 'd2222222-2222-2222-2222-222222222222', 1), -- User pode ler DRE 2023
('33333333-3333-3333-3333-333333333333', 'document', 'd3333333-3333-3333-3333-333333333331', 1), -- User pode ler Relatório Q1
('33333333-3333-3333-3333-333333333333', 'document', 'd3333333-3333-3333-3333-333333333332', 1), -- User pode ler Orçamento 2024

-- ACLs específicos para workflows
('11111111-1111-1111-1111-111111111113', 'workflow', 'w1111111-1111-1111-1111-111111111111', 1), -- User pode ver Workflow Aprovação Projetos
('11111111-1111-1111-1111-111111111113', 'workflow', 'w1111111-1111-1111-1111-111111111112', 1), -- User pode ver Workflow Code Review
('22222222-2222-2222-2222-222222222223', 'workflow', 'w2222222-2222-2222-2222-222222222221', 1), -- User pode ver Workflow Aprovação Contábil
('33333333-3333-3333-3333-333333333333', 'workflow', 'w3333333-3333-3333-3333-333333333331', 1), -- User pode ver Workflow Aprovação Financeira

-- ACLs específicos para formulários
('11111111-1111-1111-1111-111111111113', 'form', 'form1111-1111-1111-1111-111111111111', 1), -- User pode acessar Formulário Solicitação Projeto
('22222222-2222-2222-2222-222222222223', 'form', 'form2222-2222-2222-2222-222222222221', 1), -- User pode acessar Formulário Relatório Contábil
('33333333-3333-3333-3333-333333333333', 'form', 'form3333-3333-3333-3333-333333333331', 1); -- User pode acessar Formulário Solicitação Investimento

-- =====================================================
-- VERIFICAR DADOS INSERIDOS
-- =====================================================
\echo '========================================'
\echo 'DADOS REALISTAS INSERIDOS COM SUCESSO!'
\echo '========================================'

\echo ''
\echo '--- ORGANIZAÇÕES ---'
SELECT '  - ' || name || ' (CNPJ: ' || cnpj || ')' as organizacao 
FROM organizations 
ORDER BY name;

\echo ''
\echo '--- ÁREAS ---'
SELECT '  - ' || a.name || ' (' || o.name || ')' as area
FROM areas a
JOIN organizations o ON a.organization_id = o.id
ORDER BY o.name, a.name;

\echo ''
\echo '--- USUÁRIOS ---'
SELECT '  - ' || u.name || ' (' || u.email || ') - ' || p.name || ' - ' || o.name as usuario
FROM users u
JOIN users_organizations uo ON u.id = uo.user_id
JOIN profiles p ON uo.profile_id = p.id
JOIN organizations o ON uo.organization_id = o.id
ORDER BY o.name, p.name, u.name;

\echo ''
\echo '--- DOCUMENTOS ---'
SELECT '  - ' || d.name || ' (' || f.name || ' - ' || a.name || ' - ' || o.name || ')' as documento
FROM documents d
JOIN folders f ON d.folder_id = f.id
JOIN areas a ON f.area_id = a.id
JOIN organizations o ON a.organization_id = o.id
ORDER BY o.name, a.name, d.name;

\echo ''
\echo '--- WORKFLOWS ---'
SELECT '  - ' || w.name || ' (' || a.name || ' - ' || o.name || ')' as workflow
FROM workflows w
JOIN areas a ON w.area_id = a.id
JOIN organizations o ON a.organization_id = o.id
ORDER BY o.name, a.name, w.name;

\echo ''
\echo '--- FORMULÁRIOS ---'
SELECT '  - ' || f.name || ' (' || a.name || ' - ' || o.name || ')' as formulario
FROM forms f
JOIN areas a ON f.area_id = a.id
JOIN organizations o ON a.organization_id = o.id
ORDER BY o.name, a.name, f.name;

\echo ''
\echo '--- ACLs CONFIGURADAS ---'
SELECT '  - ' || u.name || ' -> ' || acl.object_type || ' -> ' || acl.object_id || ' (perms: ' || acl.perms || ')' as acl
FROM acls acl
JOIN users u ON acl.subject_id = u.id
ORDER BY u.name, acl.object_type;

\echo ''
\echo '========================================'
\echo 'POC PRONTA PARA TESTE!'
\echo '========================================'
\echo ''
\echo 'Para testar, execute:'
\echo 'psql -h localhost -p 5433 -U postgres -d acl_poc_v2 -f tests/test-acl-completo-todas-empresas.sql'
\echo ''
