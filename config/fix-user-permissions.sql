-- =====================================================
-- CORRIGIR PERMISSÕES DOS USUÁRIOS
-- =====================================================

-- Usuário TI TechCorp - Acesso a documentos da área de Desenvolvimento
INSERT INTO acls (subject_id, object_type, object_id, perms) VALUES
-- Documentos da área de Desenvolvimento
('11111111-1111-1111-1111-111111111113', 'document', 'd1111111-1111-1111-1111-111111111111', 1), -- Projeto Alpha
('11111111-1111-1111-1111-111111111113', 'document', 'd1111111-1111-1111-1111-111111111112', 1), -- Manual Tecnico
('11111111-1111-1111-1111-111111111113', 'document', 'd1111111-1111-1111-1111-111111111113', 1), -- Contrato Cliente B
-- Formulários da área de Desenvolvimento
('11111111-1111-1111-1111-111111111113', 'form', 'f1111111-1111-1111-1111-111111111111', 1), -- Formulário de Desenvolvimento
-- Workflows da área de Desenvolvimento
('11111111-1111-1111-1111-111111111113', 'workflow', '11111111-1111-1111-1111-111111111111', 1), -- Workflow de Desenvolvimento
('11111111-1111-1111-1111-111111111113', 'workflow', '11111111-1111-1111-1111-111111111112', 1)  -- Workflow de Code Review
ON CONFLICT (subject_id, object_type, object_id) DO NOTHING;

-- Usuário RH GlobalCorp - Acesso a documentos da área de Contabilidade
INSERT INTO acls (subject_id, object_type, object_id, perms) VALUES
-- Documentos da área de Contabilidade
('22222222-2222-2222-2222-222222222223', 'document', 'd2222222-2222-2222-2222-222222222221', 1), -- Balanco 2023
('22222222-2222-2222-2222-222222222223', 'document', 'd2222222-2222-2222-2222-222222222222', 1), -- DRE 2023
-- Formulários da área de Contabilidade
('22222222-2222-2222-2222-222222222223', 'form', 'f2222222-2222-2222-2222-222222222221', 1), -- Formulário Contábil
-- Workflows da área de Contabilidade
('22222222-2222-2222-2222-222222222223', 'workflow', '22222222-2222-2222-2222-222222222221', 1), -- Workflow Contábil
('22222222-2222-2222-2222-222222222223', 'workflow', '22222222-2222-2222-2222-222222222222', 1)  -- Workflow de Fechamento
ON CONFLICT (subject_id, object_type, object_id) DO NOTHING;

-- Usuário Financeiro StartupXYZ - Acesso a documentos da área Financeiro
INSERT INTO acls (subject_id, object_type, object_id, perms) VALUES
-- Documentos da área Financeiro
('33333333-3333-3333-3333-333333333333', 'document', 'd3333333-3333-3333-3333-333333333331', 1), -- Relatório Financeiro Q1
('33333333-3333-3333-3333-333333333333', 'document', 'd3333333-3333-3333-3333-333333333332', 1), -- Orçamento 2024
-- Formulários da área Financeiro
('33333333-3333-3333-3333-333333333333', 'form', 'f3333333-3333-3333-3333-333333333333', 1), -- Formulário Financeiro
-- Workflows da área Financeiro
('33333333-3333-3333-3333-333333333333', 'workflow', '33333333-3333-3333-3333-333333333333', 1), -- Workflow Financeiro
('33333333-3333-3333-3333-333333333333', 'workflow', '33333333-3333-3333-3333-333333333334', 1)  -- Workflow de Aprovação
ON CONFLICT (subject_id, object_type, object_id) DO NOTHING;

-- =====================================================
-- VERIFICAR ACLs CRIADOS
-- =====================================================

\echo 'ACLs dos usuários criados:'
SELECT 
    subject_id,
    object_type,
    object_id,
    perms,
    CASE 
        WHEN object_type = 'document' THEN (SELECT name FROM documents WHERE id = object_id)
        WHEN object_type = 'form' THEN (SELECT name FROM forms WHERE id = object_id)
        WHEN object_type = 'workflow' THEN (SELECT name FROM workflows WHERE id = object_id)
    END as resource_name
FROM acls 
WHERE subject_id IN (
    '11111111-1111-1111-1111-111111111113', -- Usuário TI TechCorp
    '22222222-2222-2222-2222-222222222223', -- Usuário RH GlobalCorp
    '33333333-3333-3333-3333-333333333333'  -- Usuário Financeiro StartupXYZ
)
ORDER BY subject_id, object_type;
