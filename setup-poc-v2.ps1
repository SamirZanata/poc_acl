# =====================================================
# SETUP COMPLETO - SISTEMA ACL V2
# =====================================================

Write-Host "Iniciando setup do Sistema ACL V2..." -ForegroundColor Green

# Verificar se o PostgreSQL está rodando
Write-Host "Verificando conexao com PostgreSQL..." -ForegroundColor Yellow
$pgTest = psql -h localhost -p 5433 -U postgres -d postgres -c "SELECT 1;" 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERRO: PostgreSQL nao esta rodando ou nao esta acessivel na porta 5433" -ForegroundColor Red
    Write-Host "Verifique se o PostgreSQL esta rodando e acessivel" -ForegroundColor Yellow
    exit 1
}

Write-Host "PostgreSQL esta rodando!" -ForegroundColor Green

# Criar banco de dados se não existir
Write-Host "Criando banco de dados 'acl_poc_v2'..." -ForegroundColor Yellow
psql -h localhost -p 5433 -U postgres -d postgres -c "CREATE DATABASE acl_poc_v2;" 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "Banco de dados criado com sucesso!" -ForegroundColor Green
} else {
    Write-Host "Banco de dados ja existe ou erro na criacao" -ForegroundColor Blue
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

# 3. Inserir dados
Write-Host "3. Inserindo dados..." -ForegroundColor Cyan
psql -h localhost -p 5433 -U postgres -d acl_poc_v2 -f database/insert-basic-data.sql
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERRO ao inserir dados" -ForegroundColor Red
    exit 1
}
Write-Host "Dados inseridos com sucesso!" -ForegroundColor Green

# 4. Verificar setup
Write-Host "4. Verificando setup..." -ForegroundColor Cyan

# Verificar setup
Write-Host "Verificando setup..." -ForegroundColor Yellow
$verificacao = psql -h localhost -p 5433 -U postgres -d acl_poc_v2 -c "
SELECT 
    'Organizacoes: ' || COUNT(*) as orgs
FROM organizations
UNION ALL
SELECT 
    'Areas: ' || COUNT(*) as areas
FROM areas
UNION ALL
SELECT 
    'Usuarios: ' || COUNT(*) as users
FROM users
UNION ALL
SELECT 
    'ACLs: ' || COUNT(*) as acls
FROM acls;
"

Write-Host $verificacao -ForegroundColor White

Write-Host "Setup do Sistema ACL V2 concluido com sucesso!" -ForegroundColor Green
Write-Host "Banco de dados: acl_poc_v2" -ForegroundColor Blue
Write-Host "Host: localhost:5433" -ForegroundColor Blue
Write-Host "Usuario: postgres" -ForegroundColor Blue

Write-Host "`nProximos passos:" -ForegroundColor Yellow
Write-Host "1. Conecte ao banco 'acl_poc_v2' no DBeaver" -ForegroundColor White
Write-Host "2. Verifique as tabelas e dados criados" -ForegroundColor White
Write-Host "3. Execute testes de permissoes" -ForegroundColor White
Write-Host "4. Use o diagrama em database-diagram-v2.dbml" -ForegroundColor White