param(
    [string]$Database = "provafinal",
    [string]$Username = "postgres",
    [string]$Password = "postgres"
)

$ErrorActionPreference = "Stop"

docker info *> $null
if ($LASTEXITCODE -ne 0) {
    throw "O Docker Desktop nao esta iniciado. O modo padrao com H2 continua disponivel em scripts/run-local.ps1."
}

$existing = docker ps -a --filter "name=^provafinal-postgres$" --format "{{.Names}}"
if ($existing -eq "provafinal-postgres") {
    docker start provafinal-postgres | Out-Null
} else {
    docker run --name provafinal-postgres `
        -e "POSTGRES_DB=$Database" `
        -e "POSTGRES_USER=$Username" `
        -e "POSTGRES_PASSWORD=$Password" `
        -p 5432:5432 `
        -v provafinal-postgres-data:/var/lib/postgresql/data `
        -d postgres:17-alpine | Out-Null
}

$env:SPRING_PROFILES_ACTIVE = "postgres"
$env:DB_HOST = "localhost"
$env:DB_PORT = "5432"
$env:DB_NAME = $Database
$env:DB_USER = $Username
$env:DB_PASSWORD = $Password

Write-Host "PostgreSQL iniciado. Agora iniciando a API com o perfil postgres."
& "$PSScriptRoot\..\mvnw.cmd" spring-boot:run

