# =====================================================
# SETUP POC COMPLETA - SISTEMA ACL V2
# =====================================================
# Script para setup completo com dados realistas

Write-Host "========================================" -ForegroundColor Green
Write-Host "SETUP POC COMPLETA - SISTEMA ACL V2" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Verificar se o PostgreSQL está rodando
Write-Host "Verificando conexão com PostgreSQL..." -ForegroundColor Yellow
$pgTest = psql -h localhost -p 5433 -U postgres -d postgres -c "SELECT 1;" 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERRO: PostgreSQL não está rodando ou não está acessível na porta 5433" -ForegroundColor Red
    Write-Host "Verifique se o PostgreSQL está rodando e acessível" -ForegroundColor Yellow
    exit 1
}

Write-Host "PostgreSQL está rodando!" -ForegroundColor Green

# Criar banco de dados se não existir
Write-Host "Criando banco de dados 'acl_poc_v2'..." -ForegroundColor Yellow
psql -h localhost -p 5433 -U postgres -d postgres -c "CREATE DATABASE acl_poc_v2;" 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "Banco de dados criado com sucesso!" -ForegroundColor Green
} else {
    Write-Host "Banco de dados já existe ou erro na criação" -ForegroundColor Blue
}

# Executar scripts SQL em ordem
Write-Host "Executando scripts SQL..." -ForegroundColor Yellow

# 1. Criar tabelas
Write-Host "1. Criando tabelas..." -ForegroundColor Cyan
psql -h localhost -p 5433 -U postgres -d acl_poc_v2 -f database/create-tables-v2.sql
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERRO ao criar tabelas" -ForegroundColor Red
    exit 1
}
Write-Host "Tabelas criadas com sucesso!" -ForegroundColor Green

# 2. Configurar ACL
Write-Host "2. Configurando sistema ACL..." -ForegroundColor Cyan
psql -h localhost -p 5433 -U postgres -d acl_poc_v2 -f database/acl-setup-v2.sql
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERRO ao configurar ACL" -ForegroundColor Red
    exit 1
}
Write-Host "Sistema ACL configurado com sucesso!" -ForegroundColor Green

# 3. Inserir dados realistas
Write-Host "3. Inserindo dados realistas..." -ForegroundColor Cyan
psql -h localhost -p 5433 -U postgres -d acl_poc_v2 -f poc-dados-reais.sql
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERRO ao inserir dados realistas" -ForegroundColor Red
    exit 1
}
Write-Host "Dados realistas inseridos com sucesso!" -ForegroundColor Green

# 4. Verificar setup
Write-Host "4. Verificando setup..." -ForegroundColor Cyan

$verificacao = psql -h localhost -p 5433 -U postgres -d acl_poc_v2 -c "
SELECT 
    'Organizações: ' || COUNT(*) as orgs
FROM organizations
UNION ALL
SELECT 
    'Áreas: ' || COUNT(*) as areas
FROM areas
UNION ALL
SELECT 
    'Usuários: ' || COUNT(*) as users
FROM users
UNION ALL
SELECT 
    'Documentos: ' || COUNT(*) as documents
FROM documents
UNION ALL
SELECT 
    'Workflows: ' || COUNT(*) as workflows
FROM workflows
UNION ALL
SELECT 
    'Formulários: ' || COUNT(*) as forms
FROM forms
UNION ALL
SELECT 
    'ACLs: ' || COUNT(*) as acls
FROM acls;
"

Write-Host $verificacao -ForegroundColor White

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "SETUP POC COMPLETA CONCLUÍDO!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Banco de dados: acl_poc_v2" -ForegroundColor Blue
Write-Host "Host: localhost:5433" -ForegroundColor Blue
Write-Host "Usuário: postgres" -ForegroundColor Blue
Write-Host ""

Write-Host "Dados inseridos:" -ForegroundColor Yellow
Write-Host "- 3 Organizações (TechCorp, GlobalCorp, StartupXYZ)" -ForegroundColor White
Write-Host "- 9 Áreas (3 por organização)" -ForegroundColor White
Write-Host "- 9 Usuários com nomes realistas" -ForegroundColor White
Write-Host "- 9 Documentos com dados reais" -ForegroundColor White
Write-Host "- 6 Workflows configurados" -ForegroundColor White
Write-Host "- 3 Formulários dinâmicos" -ForegroundColor White
Write-Host "- ACLs configurados para controle granular" -ForegroundColor White
Write-Host ""

Write-Host "Próximos passos:" -ForegroundColor Yellow
Write-Host "1. Execute o teste: psql -h localhost -p 5433 -U postgres -d acl_poc_v2 -f teste-poc-realista.sql" -ForegroundColor White
Write-Host "2. Ou execute: psql -h localhost -p 5433 -U postgres -d acl_poc_v2 -f tests/test-acl-completo-todas-empresas.sql" -ForegroundColor White
Write-Host "3. Abra a documentação: documentacao-sistema-acl.html" -ForegroundColor White
Write-Host "4. Visualize o diagrama: diagrama-banco-dados.dbml (use em dbdiagram.io)" -ForegroundColor White
Write-Host ""

Write-Host "Para demonstrar ao chefe:" -ForegroundColor Green
Write-Host "1. Execute o teste-poc-realista.sql" -ForegroundColor White
Write-Host "2. Mostre como diferentes usuários veem apenas seus dados" -ForegroundColor White
Write-Host "3. Demonstre o isolamento entre organizações" -ForegroundColor White
Write-Host "4. Explique o sistema de permissões granular" -ForegroundColor White
Write-Host ""

Write-Host "POC pronta para demonstração! 🎉" -ForegroundColor Green
