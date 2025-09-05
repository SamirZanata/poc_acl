-- =====================================================
-- ADICIONAR WORKFLOWS E AJUSTAR ACLS
-- =====================================================

-- Adicionar workflows para cada área
INSERT INTO workflows (id, name, area_id, is_active, created_at) VALUES
-- TechCorp - Desenvolvimento
('11111111-1111-1111-1111-111111111111', 'Workflow de Desenvolvimento', 'a1111111-1111-1111-1111-111111111111', true, NOW()),
('11111111-1111-1111-1111-111111111112', 'Workflow de Code Review', 'a1111111-1111-1111-1111-111111111111', true, NOW()),
-- TechCorp - Vendas  
('11111111-1111-1111-1111-111111111113', 'Workflow de Vendas', 'a1111111-1111-1111-1111-111111111112', true, NOW()),
-- TechCorp - Suporte
('11111111-1111-1111-1111-111111111114', 'Workflow de Suporte', 'a1111111-1111-1111-1111-111111111113', true, NOW()),

-- GlobalCorp - Contabilidade
('22222222-2222-2222-2222-222222222221', 'Workflow Contábil', 'a2222222-2222-2222-2222-222222222221', true, NOW()),
('22222222-2222-2222-2222-222222222222', 'Workflow de Fechamento', 'a2222222-2222-2222-2222-222222222221', true, NOW()),
-- GlobalCorp - Auditoria
('22222222-2222-2222-2222-222222222223', 'Workflow de Auditoria', 'a2222222-2222-2222-2222-222222222222', true, NOW()),
-- GlobalCorp - Consultoria
('22222222-2222-2222-2222-222222222224', 'Workflow de Consultoria', 'a2222222-2222-2222-2222-222222222223', true, NOW()),

-- StartupXYZ - TI
('33333333-3333-3333-3333-333333333331', 'Workflow de TI', 'a3333333-3333-3333-3333-333333333331', true, NOW()),
-- StartupXYZ - RH
('33333333-3333-3333-3333-333333333332', 'Workflow de RH', 'a3333333-3333-3333-3333-333333333332', true, NOW()),
-- StartupXYZ - Financeiro
('33333333-3333-3333-3333-333333333333', 'Workflow Financeiro', 'a3333333-3333-3333-3333-333333333333', true, NOW()),
('33333333-3333-3333-3333-333333333334', 'Workflow de Aprovação', 'a3333333-3333-3333-3333-333333333333', true, NOW())
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- ACLs ESPECÍFICOS PARA WORKFLOWS E DOCUMENTOS
-- =====================================================

-- Usuário TI TechCorp - Acesso específico a alguns workflows e documentos
INSERT INTO acls (subject_id, object_type, object_id, perms) VALUES
-- Workflows específicos
('11111111-1111-1111-1111-111111111113', 'workflow', '11111111-1111-1111-1111-111111111111', 1), -- READ workflow desenvolvimento
('11111111-1111-1111-1111-111111111113', 'workflow', '11111111-1111-1111-1111-111111111112', 1), -- READ workflow code review
-- Documentos específicos (usando IDs dos documentos existentes)
('11111111-1111-1111-1111-111111111113', 'document', 'd1111111-1111-1111-1111-111111111111', 1), -- READ Projeto Alpha
('11111111-1111-1111-1111-111111111113', 'document', 'd1111111-1111-1111-1111-111111111112', 1)  -- READ Manual Tecnico
ON CONFLICT (subject_id, object_type, object_id) DO NOTHING;

-- Usuário RH GlobalCorp - Acesso específico a alguns workflows e documentos
INSERT INTO acls (subject_id, object_type, object_id, perms) VALUES
-- Workflows específicos
('22222222-2222-2222-2222-222222222223', 'workflow', '22222222-2222-2222-2222-222222222221', 1), -- READ workflow contábil
-- Documentos específicos
('22222222-2222-2222-2222-222222222223', 'document', 'd2222222-2222-2222-2222-222222222221', 1), -- READ Balanco 2023
('22222222-2222-2222-2222-222222222223', 'document', 'd2222222-2222-2222-2222-222222222222', 1)  -- READ DRE 2023
ON CONFLICT (subject_id, object_type, object_id) DO NOTHING;

-- Usuário Financeiro StartupXYZ - Acesso específico a alguns workflows e documentos
INSERT INTO acls (subject_id, object_type, object_id, perms) VALUES
-- Workflows específicos
('33333333-3333-3333-3333-333333333333', 'workflow', '33333333-3333-3333-3333-333333333333', 1), -- READ workflow financeiro
('33333333-3333-3333-3333-333333333333', 'workflow', '33333333-3333-3333-3333-333333333334', 1), -- READ workflow aprovação
-- Documentos específicos
('33333333-3333-3333-3333-333333333333', 'document', 'd3333333-3333-3333-3333-333333333331', 1), -- READ Relatório Financeiro Q1
('33333333-3333-3333-3333-333333333333', 'document', 'd3333333-3333-3333-3333-333333333332', 1)  -- READ Orçamento 2024
ON CONFLICT (subject_id, object_type, object_id) DO NOTHING;

-- =====================================================
-- VERIFICAR DADOS INSERIDOS
-- =====================================================

\echo 'Workflows criados:'
SELECT w.name, a.name as area, o.name as organizacao 
FROM workflows w
JOIN areas a ON w.area_id = a.id
JOIN organizations o ON a.organization_id = o.id
ORDER BY o.name, a.name, w.name;

\echo ''
\echo 'ACLs específicos para workflows e documentos:'
SELECT subject_id, object_type, object_id, perms 
FROM acls 
WHERE object_type IN ('workflow', 'document')
ORDER BY subject_id, object_type;
