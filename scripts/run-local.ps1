$ErrorActionPreference = "Stop"

Write-Host "Iniciando no modo minimo: H2 local e rotas sem Auth0."
Write-Host "Health check: http://localhost:8080/actuator/health"
Write-Host "H2 Console:   http://localhost:8080/h2-console"

& "$PSScriptRoot\..\mvnw.cmd" spring-boot:run

