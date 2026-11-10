param(
    [Parameter(Mandatory = $true)]
    [string]$IssuerUri,

    [Parameter(Mandatory = $true)]
    [string]$Audience
)

$ErrorActionPreference = "Stop"
$env:SPRING_PROFILES_ACTIVE = "auth0"
$env:AUTH0_ISSUER_URI = $IssuerUri
$env:AUTH0_AUDIENCE = $Audience

Write-Host "Iniciando com Auth0 e H2. O front-end continua opcional."
& "$PSScriptRoot\..\mvnw.cmd" spring-boot:run

