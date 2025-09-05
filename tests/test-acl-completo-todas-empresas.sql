-- ========================================
-- TESTE ACL COMPLETO - TODAS AS EMPRESAS
-- ========================================

\echo '========================================'
\echo 'TESTE ACL COMPLETO - TODAS AS EMPRESAS'
\echo '========================================'

-- ========================================
-- TESTE 1: ADMIN TECHCORP
-- ========================================
\echo ''
\echo '===== USUARIO: ADMIN TECHCORP ====='
\echo 'Empresa: TechCorp'
\echo 'Perfil: Owner (Administrador) - Vê TUDO da organização'
\echo ''

\echo '--- ORGANIZAÇÕES QUE PODE VER ---'
SELECT '  - ' || name || ' (CNPJ: ' || cnpj || ')' as organizacao 
FROM organizations 
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '11111111-1111-1111-1111-111111111111'::UUID
      AND object_type = 'organization'
      AND object_id = organizations.id
      AND (perms & 1) = 1
);

\echo ''
\echo '--- ÁREAS QUE PODE VER ---'
SELECT '  - ' || a.name || ' (' || o.name || ')' as area
FROM areas a
JOIN organizations o ON a.organization_id = o.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '11111111-1111-1111-1111-111111111111'::UUID
      AND (
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = o.id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- DOCUMENTOS QUE PODE VER ---'
SELECT '  - ' || d.name || ' (' || f.name || ' - ' || a.name || ')' as documento
FROM documents d
JOIN folders f ON d.folder_id = f.id
JOIN areas a ON f.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '11111111-1111-1111-1111-111111111111'::UUID
      AND (
          (object_type = 'document' AND object_id = d.id AND (perms & 1) = 1)
          OR
          (object_type = 'folder' AND object_id = f.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- FORMULÁRIOS QUE PODE VER ---'
SELECT '  - ' || f.name || ' (' || a.name || ')' as formulario
FROM forms f
JOIN areas a ON f.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '11111111-1111-1111-1111-111111111111'::UUID
      AND (
          (object_type = 'form' AND object_id = f.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- WORKFLOWS QUE PODE VER ---'
SELECT '  - ' || w.name || ' (' || a.name || ')' as workflow
FROM workflows w
JOIN areas a ON w.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '11111111-1111-1111-1111-111111111111'::UUID
      AND (
          (object_type = 'workflow' AND object_id = w.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

-- ========================================
-- TESTE 2: GERENTE TI TECHCORP
-- ========================================
\echo ''
\echo '===== USUARIO: GERENTE TI TECHCORP ====='
\echo 'Empresa: TechCorp'
\echo 'Perfil: Manager (Gerente) - Vê TUDO da área de Desenvolvimento'
\echo ''

\echo '--- ÁREAS QUE PODE VER ---'
SELECT '  - ' || a.name || ' (' || o.name || ')' as area
FROM areas a
JOIN organizations o ON a.organization_id = o.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '11111111-1111-1111-1111-111111111112'::UUID
      AND (
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = o.id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- DOCUMENTOS QUE PODE VER ---'
SELECT '  - ' || d.name || ' (' || f.name || ' - ' || a.name || ')' as documento
FROM documents d
JOIN folders f ON d.folder_id = f.id
JOIN areas a ON f.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '11111111-1111-1111-1111-111111111112'::UUID
      AND (
          (object_type = 'document' AND object_id = d.id AND (perms & 1) = 1)
          OR
          (object_type = 'folder' AND object_id = f.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- FORMULÁRIOS QUE PODE VER ---'
SELECT '  - ' || f.name || ' (' || a.name || ')' as formulario
FROM forms f
JOIN areas a ON f.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '11111111-1111-1111-1111-111111111112'::UUID
      AND (
          (object_type = 'form' AND object_id = f.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- WORKFLOWS QUE PODE VER ---'
SELECT '  - ' || w.name || ' (' || a.name || ')' as workflow
FROM workflows w
JOIN areas a ON w.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '11111111-1111-1111-1111-111111111112'::UUID
      AND (
          (object_type = 'workflow' AND object_id = w.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

-- ========================================
-- TESTE 3: USUÁRIO TI TECHCORP
-- ========================================
\echo ''
\echo '===== USUARIO: USUÁRIO TI TECHCORP ====='
\echo 'Empresa: TechCorp'
\echo 'Perfil: User (Usuário) - Vê APENAS workflows/documentos com acesso específico'
\echo ''

\echo '--- ÁREAS QUE PODE VER ---'
SELECT '  - ' || a.name || ' (' || o.name || ')' as area
FROM areas a
JOIN organizations o ON a.organization_id = o.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '11111111-1111-1111-1111-111111111113'::UUID
      AND (
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = o.id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- DOCUMENTOS QUE PODE VER ---'
SELECT '  - ' || d.name || ' (' || f.name || ' - ' || a.name || ')' as documento
FROM documents d
JOIN folders f ON d.folder_id = f.id
JOIN areas a ON f.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '11111111-1111-1111-1111-111111111113'::UUID
      AND (
          (object_type = 'document' AND object_id = d.id AND (perms & 1) = 1)
          OR
          (object_type = 'folder' AND object_id = f.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- FORMULÁRIOS QUE PODE VER ---'
SELECT '  - ' || f.name || ' (' || a.name || ')' as formulario
FROM forms f
JOIN areas a ON f.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '11111111-1111-1111-1111-111111111113'::UUID
      AND (
          (object_type = 'form' AND object_id = f.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- WORKFLOWS QUE PODE VER ---'
SELECT '  - ' || w.name || ' (' || a.name || ')' as workflow
FROM workflows w
JOIN areas a ON w.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '11111111-1111-1111-1111-111111111113'::UUID
      AND (
          (object_type = 'workflow' AND object_id = w.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

-- ========================================
-- TESTE 4: ADMIN GLOBALCORP
-- ========================================
\echo ''
\echo '===== USUARIO: ADMIN GLOBALCORP ====='
\echo 'Empresa: GlobalCorp'
\echo 'Perfil: Owner (Administrador) - Vê TUDO da organização'
\echo ''

\echo '--- ORGANIZAÇÕES QUE PODE VER ---'
SELECT '  - ' || name || ' (CNPJ: ' || cnpj || ')' as organizacao 
FROM organizations 
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '22222222-2222-2222-2222-222222222221'::UUID
      AND object_type = 'organization'
      AND object_id = organizations.id
      AND (perms & 1) = 1
);

\echo ''
\echo '--- ÁREAS QUE PODE VER ---'
SELECT '  - ' || a.name || ' (' || o.name || ')' as area
FROM areas a
JOIN organizations o ON a.organization_id = o.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '22222222-2222-2222-2222-222222222221'::UUID
      AND (
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = o.id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- DOCUMENTOS QUE PODE VER ---'
SELECT '  - ' || d.name || ' (' || f.name || ' - ' || a.name || ')' as documento
FROM documents d
JOIN folders f ON d.folder_id = f.id
JOIN areas a ON f.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '22222222-2222-2222-2222-222222222221'::UUID
      AND (
          (object_type = 'document' AND object_id = d.id AND (perms & 1) = 1)
          OR
          (object_type = 'folder' AND object_id = f.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- FORMULÁRIOS QUE PODE VER ---'
SELECT '  - ' || f.name || ' (' || a.name || ')' as formulario
FROM forms f
JOIN areas a ON f.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '22222222-2222-2222-2222-222222222221'::UUID
      AND (
          (object_type = 'form' AND object_id = f.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- WORKFLOWS QUE PODE VER ---'
SELECT '  - ' || w.name || ' (' || a.name || ')' as workflow
FROM workflows w
JOIN areas a ON w.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '22222222-2222-2222-2222-222222222221'::UUID
      AND (
          (object_type = 'workflow' AND object_id = w.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

-- ========================================
-- TESTE 5: GERENTE RH GLOBALCORP
-- ========================================
\echo ''
\echo '===== USUARIO: GERENTE RH GLOBALCORP ====='
\echo 'Empresa: GlobalCorp'
\echo 'Perfil: Manager (Gerente) - Vê TUDO da área de Contabilidade'
\echo ''

\echo '--- ÁREAS QUE PODE VER ---'
SELECT '  - ' || a.name || ' (' || o.name || ')' as area
FROM areas a
JOIN organizations o ON a.organization_id = o.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '22222222-2222-2222-2222-222222222222'::UUID
      AND (
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = o.id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- DOCUMENTOS QUE PODE VER ---'
SELECT '  - ' || d.name || ' (' || f.name || ' - ' || a.name || ')' as documento
FROM documents d
JOIN folders f ON d.folder_id = f.id
JOIN areas a ON f.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '22222222-2222-2222-2222-222222222222'::UUID
      AND (
          (object_type = 'document' AND object_id = d.id AND (perms & 1) = 1)
          OR
          (object_type = 'folder' AND object_id = f.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- FORMULÁRIOS QUE PODE VER ---'
SELECT '  - ' || f.name || ' (' || a.name || ')' as formulario
FROM forms f
JOIN areas a ON f.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '22222222-2222-2222-2222-222222222222'::UUID
      AND (
          (object_type = 'form' AND object_id = f.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- WORKFLOWS QUE PODE VER ---'
SELECT '  - ' || w.name || ' (' || a.name || ')' as workflow
FROM workflows w
JOIN areas a ON w.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '22222222-2222-2222-2222-222222222222'::UUID
      AND (
          (object_type = 'workflow' AND object_id = w.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

-- ========================================
-- TESTE 6: USUÁRIO RH GLOBALCORP
-- ========================================
\echo ''
\echo '===== USUARIO: USUÁRIO RH GLOBALCORP ====='
\echo 'Empresa: GlobalCorp'
\echo 'Perfil: User (Usuário) - Vê APENAS workflows/documentos com acesso específico'
\echo ''

\echo '--- ÁREAS QUE PODE VER ---'
SELECT '  - ' || a.name || ' (' || o.name || ')' as area
FROM areas a
JOIN organizations o ON a.organization_id = o.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '22222222-2222-2222-2222-222222222223'::UUID
      AND (
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = o.id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- DOCUMENTOS QUE PODE VER ---'
SELECT '  - ' || d.name || ' (' || f.name || ' - ' || a.name || ')' as documento
FROM documents d
JOIN folders f ON d.folder_id = f.id
JOIN areas a ON f.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '22222222-2222-2222-2222-222222222223'::UUID
      AND (
          (object_type = 'document' AND object_id = d.id AND (perms & 1) = 1)
          OR
          (object_type = 'folder' AND object_id = f.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- FORMULÁRIOS QUE PODE VER ---'
SELECT '  - ' || f.name || ' (' || a.name || ')' as formulario
FROM forms f
JOIN areas a ON f.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '22222222-2222-2222-2222-222222222223'::UUID
      AND (
          (object_type = 'form' AND object_id = f.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- WORKFLOWS QUE PODE VER ---'
SELECT '  - ' || w.name || ' (' || a.name || ')' as workflow
FROM workflows w
JOIN areas a ON w.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '22222222-2222-2222-2222-222222222223'::UUID
      AND (
          (object_type = 'workflow' AND object_id = w.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

-- ========================================
-- TESTE 7: ADMIN STARTUPXYZ
-- ========================================
\echo ''
\echo '===== USUARIO: ADMIN STARTUPXYZ ====='
\echo 'Empresa: StartupXYZ'
\echo 'Perfil: Owner (Administrador) - Vê TUDO da organização'
\echo ''

\echo '--- ORGANIZAÇÕES QUE PODE VER ---'
SELECT '  - ' || name || ' (CNPJ: ' || cnpj || ')' as organizacao 
FROM organizations 
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '33333333-3333-3333-3333-333333333331'::UUID
      AND object_type = 'organization'
      AND object_id = organizations.id
      AND (perms & 1) = 1
);

\echo ''
\echo '--- ÁREAS QUE PODE VER ---'
SELECT '  - ' || a.name || ' (' || o.name || ')' as area
FROM areas a
JOIN organizations o ON a.organization_id = o.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '33333333-3333-3333-3333-333333333331'::UUID
      AND (
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = o.id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- DOCUMENTOS QUE PODE VER ---'
SELECT '  - ' || d.name || ' (' || f.name || ' - ' || a.name || ')' as documento
FROM documents d
JOIN folders f ON d.folder_id = f.id
JOIN areas a ON f.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '33333333-3333-3333-3333-333333333331'::UUID
      AND (
          (object_type = 'document' AND object_id = d.id AND (perms & 1) = 1)
          OR
          (object_type = 'folder' AND object_id = f.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- FORMULÁRIOS QUE PODE VER ---'
SELECT '  - ' || f.name || ' (' || a.name || ')' as formulario
FROM forms f
JOIN areas a ON f.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '33333333-3333-3333-3333-333333333331'::UUID
      AND (
          (object_type = 'form' AND object_id = f.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- WORKFLOWS QUE PODE VER ---'
SELECT '  - ' || w.name || ' (' || a.name || ')' as workflow
FROM workflows w
JOIN areas a ON w.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '33333333-3333-3333-3333-333333333331'::UUID
      AND (
          (object_type = 'workflow' AND object_id = w.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

-- ========================================
-- TESTE 8: GERENTE FINANCEIRO STARTUPXYZ
-- ========================================
\echo ''
\echo '===== USUARIO: GERENTE FINANCEIRO STARTUPXYZ ====='
\echo 'Empresa: StartupXYZ'
\echo 'Perfil: Manager (Gerente) - Vê TUDO da área Financeiro'
\echo ''

\echo '--- ÁREAS QUE PODE VER ---'
SELECT '  - ' || a.name || ' (' || o.name || ')' as area
FROM areas a
JOIN organizations o ON a.organization_id = o.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '33333333-3333-3333-3333-333333333332'::UUID
      AND (
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = o.id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- DOCUMENTOS QUE PODE VER ---'
SELECT '  - ' || d.name || ' (' || f.name || ' - ' || a.name || ')' as documento
FROM documents d
JOIN folders f ON d.folder_id = f.id
JOIN areas a ON f.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '33333333-3333-3333-3333-333333333332'::UUID
      AND (
          (object_type = 'document' AND object_id = d.id AND (perms & 1) = 1)
          OR
          (object_type = 'folder' AND object_id = f.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- FORMULÁRIOS QUE PODE VER ---'
SELECT '  - ' || f.name || ' (' || a.name || ')' as formulario
FROM forms f
JOIN areas a ON f.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '33333333-3333-3333-3333-333333333332'::UUID
      AND (
          (object_type = 'form' AND object_id = f.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- WORKFLOWS QUE PODE VER ---'
SELECT '  - ' || w.name || ' (' || a.name || ')' as workflow
FROM workflows w
JOIN areas a ON w.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '33333333-3333-3333-3333-333333333332'::UUID
      AND (
          (object_type = 'workflow' AND object_id = w.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

-- ========================================
-- TESTE 9: USUÁRIO FINANCEIRO STARTUPXYZ
-- ========================================
\echo ''
\echo '===== USUARIO: USUÁRIO FINANCEIRO STARTUPXYZ ====='
\echo 'Empresa: StartupXYZ'
\echo 'Perfil: User (Usuário) - Vê APENAS workflows/documentos com acesso específico'
\echo ''

\echo '--- ÁREAS QUE PODE VER ---'
SELECT '  - ' || a.name || ' (' || o.name || ')' as area
FROM areas a
JOIN organizations o ON a.organization_id = o.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '33333333-3333-3333-3333-333333333333'::UUID
      AND (
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = o.id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- DOCUMENTOS QUE PODE VER ---'
SELECT '  - ' || d.name || ' (' || f.name || ' - ' || a.name || ')' as documento
FROM documents d
JOIN folders f ON d.folder_id = f.id
JOIN areas a ON f.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '33333333-3333-3333-3333-333333333333'::UUID
      AND (
          (object_type = 'document' AND object_id = d.id AND (perms & 1) = 1)
          OR
          (object_type = 'folder' AND object_id = f.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- FORMULÁRIOS QUE PODE VER ---'
SELECT '  - ' || f.name || ' (' || a.name || ')' as formulario
FROM forms f
JOIN areas a ON f.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '33333333-3333-3333-3333-333333333333'::UUID
      AND (
          (object_type = 'form' AND object_id = f.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '--- WORKFLOWS QUE PODE VER ---'
SELECT '  - ' || w.name || ' (' || a.name || ')' as workflow
FROM workflows w
JOIN areas a ON w.area_id = a.id
WHERE EXISTS (
    SELECT 1 FROM acls
    WHERE subject_id = '33333333-3333-3333-3333-333333333333'::UUID
      AND (
          (object_type = 'workflow' AND object_id = w.id AND (perms & 1) = 1)
          OR
          (object_type = 'area' AND object_id = a.id AND (perms & 1) = 1)
          OR
          (object_type = 'organization' AND object_id = a.organization_id AND (perms & 1) = 1)
      )
);

\echo ''
\echo '========================================'
\echo 'TESTE COMPLETO TODAS AS EMPRESAS CONCLUÍDO!'
\echo '========================================'
