-- =====================================================
-- CONFIGURAÇÃO DO SISTEMA ACL V2
-- =====================================================

-- =====================================================
-- FUNÇÕES DE PERMISSÃO
-- =====================================================

-- Função para calcular permissões efetivas
CREATE OR REPLACE FUNCTION effective_perms_v2(
    p_object_type resource_type,
    p_object_id UUID,
    p_user_id UUID
) RETURNS INTEGER AS $$
DECLARE
    result_perms INTEGER := 0;
    acl_record RECORD;
BEGIN
    -- Buscar ACL direto
    SELECT perms INTO result_perms
    FROM acls
    WHERE subject_id = p_user_id
      AND object_type = p_object_type
      AND object_id = p_object_id;
    
    -- Se não encontrou ACL direto, retorna 0
    IF result_perms IS NULL THEN
        RETURN 0;
    END IF;
    
    RETURN result_perms;
END;
$$ LANGUAGE plpgsql;

-- Função para verificar se pode ler
CREATE OR REPLACE FUNCTION can_read_v2(
    p_object_type resource_type,
    p_object_id UUID,
    p_user_id UUID
) RETURNS BOOLEAN AS $$
BEGIN
    RETURN (effective_perms_v2(p_object_type, p_object_id, p_user_id) & 1) = 1;
END;
$$ LANGUAGE plpgsql;

-- Função para verificar se pode escrever
CREATE OR REPLACE FUNCTION can_write_v2(
    p_object_type resource_type,
    p_object_id UUID,
    p_user_id UUID
) RETURNS BOOLEAN AS $$
BEGIN
    RETURN (effective_perms_v2(p_object_type, p_object_id, p_user_id) & 2) = 2;
END;
$$ LANGUAGE plpgsql;

-- Função para verificar se pode aprovar
CREATE OR REPLACE FUNCTION can_approve_v2(
    p_object_type resource_type,
    p_object_id UUID,
    p_user_id UUID
) RETURNS BOOLEAN AS $$
BEGIN
    RETURN (effective_perms_v2(p_object_type, p_object_id, p_user_id) & 4) = 4;
END;
$$ LANGUAGE plpgsql;

-- Função para verificar se pode compartilhar
CREATE OR REPLACE FUNCTION can_share_v2(
    p_object_type resource_type,
    p_object_id UUID,
    p_user_id UUID
) RETURNS BOOLEAN AS $$
BEGIN
    RETURN (effective_perms_v2(p_object_type, p_object_id, p_user_id) & 8) = 8;
END;
$$ LANGUAGE plpgsql;

-- Função para verificar se pode deletar
CREATE OR REPLACE FUNCTION can_delete_v2(
    p_object_type resource_type,
    p_object_id UUID,
    p_user_id UUID
) RETURNS BOOLEAN AS $$
BEGIN
    RETURN (effective_perms_v2(p_object_type, p_object_id, p_user_id) & 16) = 16;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- ROW LEVEL SECURITY (RLS)
-- =====================================================

-- Habilitar RLS nas tabelas principais
ALTER TABLE organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE areas ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE folders ENABLE ROW LEVEL SECURITY;
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE forms ENABLE ROW LEVEL SECURITY;
ALTER TABLE workflows ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- POLÍTICAS RLS PARA ORGANIZAÇÕES
-- =====================================================

CREATE POLICY org_read_policy ON organizations
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM acls
            WHERE subject_id = current_setting('app.current_user_id')::UUID
              AND object_type = 'organization'
              AND object_id = organizations.id
              AND (perms & 1) = 1
        )
    );

CREATE POLICY org_write_policy ON organizations
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM acls
            WHERE subject_id = current_setting('app.current_user_id')::UUID
              AND object_type = 'organization'
              AND object_id = organizations.id
              AND (perms & 2) = 2
        )
    );

-- =====================================================
-- POLÍTICAS RLS PARA ÁREAS
-- =====================================================

CREATE POLICY area_read_policy ON areas
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM acls
            WHERE subject_id = current_setting('app.current_user_id')::UUID
              AND object_type = 'area'
              AND object_id = areas.id
              AND (perms & 1) = 1
        )
    );

CREATE POLICY area_write_policy ON areas
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM acls
            WHERE subject_id = current_setting('app.current_user_id')::UUID
              AND object_type = 'area'
              AND object_id = areas.id
              AND (perms & 2) = 2
        )
    );

-- =====================================================
-- POLÍTICAS RLS PARA USUÁRIOS
-- =====================================================

CREATE POLICY user_read_policy ON users
    FOR SELECT
    USING (
        -- Usuário pode ver a si mesmo
        id = current_setting('app.current_user_id')::UUID
        OR
        -- Ou tem permissão de leitura na organização
        EXISTS (
            SELECT 1 FROM acls
            WHERE subject_id = current_setting('app.current_user_id')::UUID
              AND object_type = 'organization'
              AND object_id = users.organization_id
              AND (perms & 1) = 1
        )
    );

CREATE POLICY user_write_policy ON users
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM acls
            WHERE subject_id = current_setting('app.current_user_id')::UUID
              AND object_type = 'organization'
              AND object_id = users.organization_id
              AND (perms & 2) = 2
        )
    );

-- =====================================================
-- POLÍTICAS RLS PARA PASTAS
-- =====================================================

CREATE POLICY folder_read_policy ON folders
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM acls
            WHERE subject_id = current_setting('app.current_user_id')::UUID
              AND (
                  (object_type = 'folder' AND object_id = folders.id AND (perms & 1) = 1)
                  OR
                  (object_type = 'area' AND object_id = folders.area_id AND (perms & 1) = 1)
                  OR
                  (object_type = 'organization' AND object_id = (
                      SELECT organization_id FROM areas WHERE id = folders.area_id
                  ) AND (perms & 1) = 1)
              )
        )
    );

CREATE POLICY folder_write_policy ON folders
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM acls
            WHERE subject_id = current_setting('app.current_user_id')::UUID
              AND (
                  (object_type = 'folder' AND object_id = folders.id AND (perms & 2) = 2)
                  OR
                  (object_type = 'area' AND object_id = folders.area_id AND (perms & 2) = 2)
                  OR
                  (object_type = 'organization' AND object_id = (
                      SELECT organization_id FROM areas WHERE id = folders.area_id
                  ) AND (perms & 2) = 2)
              )
        )
    );

-- =====================================================
-- POLÍTICAS RLS PARA DOCUMENTOS
-- =====================================================

CREATE POLICY document_read_policy ON documents
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM acls
            WHERE subject_id = current_setting('app.current_user_id')::UUID
              AND (
                  (object_type = 'document' AND object_id = documents.id AND (perms & 1) = 1)
                  OR
                  (object_type = 'folder' AND object_id = documents.folder_id AND (perms & 1) = 1)
                  OR
                  (object_type = 'area' AND object_id = (
                      SELECT area_id FROM folders WHERE id = documents.folder_id
                  ) AND (perms & 1) = 1)
                  OR
                  (object_type = 'organization' AND object_id = (
                      SELECT a.organization_id 
                      FROM folders f 
                      JOIN areas a ON f.area_id = a.id 
                      WHERE f.id = documents.folder_id
                  ) AND (perms & 1) = 1)
              )
        )
    );

CREATE POLICY document_write_policy ON documents
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM acls
            WHERE subject_id = current_setting('app.current_user_id')::UUID
              AND (
                  (object_type = 'document' AND object_id = documents.id AND (perms & 2) = 2)
                  OR
                  (object_type = 'folder' AND object_id = documents.folder_id AND (perms & 2) = 2)
                  OR
                  (object_type = 'area' AND object_id = (
                      SELECT area_id FROM folders WHERE id = documents.folder_id
                  ) AND (perms & 2) = 2)
                  OR
                  (object_type = 'organization' AND object_id = (
                      SELECT a.organization_id 
                      FROM folders f 
                      JOIN areas a ON f.area_id = a.id 
                      WHERE f.id = documents.folder_id
                  ) AND (perms & 2) = 2)
              )
        )
    );

-- =====================================================
-- POLÍTICAS RLS PARA FORMULÁRIOS
-- =====================================================

CREATE POLICY form_read_policy ON forms
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM acls
            WHERE subject_id = current_setting('app.current_user_id')::UUID
              AND (
                  (object_type = 'form' AND object_id = forms.id AND (perms & 1) = 1)
                  OR
                  (object_type = 'area' AND object_id = forms.area_id AND (perms & 1) = 1)
                  OR
                  (object_type = 'organization' AND object_id = (
                      SELECT organization_id FROM areas WHERE id = forms.area_id
                  ) AND (perms & 1) = 1)
              )
        )
    );

CREATE POLICY form_write_policy ON forms
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM acls
            WHERE subject_id = current_setting('app.current_user_id')::UUID
              AND (
                  (object_type = 'form' AND object_id = forms.id AND (perms & 2) = 2)
                  OR
                  (object_type = 'area' AND object_id = forms.area_id AND (perms & 2) = 2)
                  OR
                  (object_type = 'organization' AND object_id = (
                      SELECT organization_id FROM areas WHERE id = forms.area_id
                  ) AND (perms & 2) = 2)
              )
        )
    );

-- =====================================================
-- POLÍTICAS RLS PARA WORKFLOWS
-- =====================================================

CREATE POLICY workflow_read_policy ON workflows
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM acls
            WHERE subject_id = current_setting('app.current_user_id')::UUID
              AND (
                  (object_type = 'workflow' AND object_id = workflows.id AND (perms & 1) = 1)
                  OR
                  (object_type = 'area' AND object_id = workflows.area_id AND (perms & 1) = 1)
                  OR
                  (object_type = 'organization' AND object_id = (
                      SELECT organization_id FROM areas WHERE id = workflows.area_id
                  ) AND (perms & 1) = 1)
              )
        )
    );

CREATE POLICY workflow_write_policy ON workflows
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM acls
            WHERE subject_id = current_setting('app.current_user_id')::UUID
              AND (
                  (object_type = 'workflow' AND object_id = workflows.id AND (perms & 2) = 2)
                  OR
                  (object_type = 'area' AND object_id = workflows.area_id AND (perms & 2) = 2)
                  OR
                  (object_type = 'organization' AND object_id = (
                      SELECT organization_id FROM areas WHERE id = workflows.area_id
                  ) AND (perms & 2) = 2)
              )
        )
    );

-- =====================================================
-- FUNÇÃO PARA CONFIGURAR USUÁRIO ATUAL
-- =====================================================

CREATE OR REPLACE FUNCTION set_current_user(p_user_id UUID)
RETURNS VOID AS $$
BEGIN
    PERFORM set_config('app.current_user_id', p_user_id::TEXT, FALSE);
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- FUNÇÃO PARA VERIFICAR PERMISSÕES EM CASCATA
-- =====================================================

CREATE OR REPLACE FUNCTION has_permission_cascade(
    p_user_id UUID,
    p_object_type resource_type,
    p_object_id UUID,
    p_permission INTEGER
) RETURNS BOOLEAN AS $$
DECLARE
    result BOOLEAN := FALSE;
BEGIN
    -- Verificar permissão direta
    SELECT (perms & p_permission) = p_permission INTO result
    FROM acls
    WHERE subject_id = p_user_id
      AND object_type = p_object_type
      AND object_id = p_object_id;
    
    IF result THEN
        RETURN TRUE;
    END IF;
    
    -- Se não tem permissão direta, verificar herança
    CASE p_object_type
        WHEN 'document' THEN
            -- Verificar pasta pai
            SELECT has_permission_cascade(p_user_id, 'folder', folder_id, p_permission) INTO result
            FROM documents WHERE id = p_object_id;
            
        WHEN 'folder' THEN
            -- Verificar área pai
            SELECT has_permission_cascade(p_user_id, 'area', area_id, p_permission) INTO result
            FROM folders WHERE id = p_object_id;
            
        WHEN 'area' THEN
            -- Verificar organização pai
            SELECT has_permission_cascade(p_user_id, 'organization', organization_id, p_permission) INTO result
            FROM areas WHERE id = p_object_id;
            
        WHEN 'form' THEN
            -- Verificar área pai
            SELECT has_permission_cascade(p_user_id, 'area', area_id, p_permission) INTO result
            FROM forms WHERE id = p_object_id;
            
        WHEN 'workflow' THEN
            -- Verificar área pai
            SELECT has_permission_cascade(p_user_id, 'area', area_id, p_permission) INTO result
            FROM workflows WHERE id = p_object_id;
    END CASE;
    
    RETURN result;
END;
$$ LANGUAGE plpgsql;
