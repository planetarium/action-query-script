Param(
    [Parameter(Mandatory = $true)]
    [string]$Query,
    [switch]$Quiet
)

if (!$Quiet) {
    Write-Host "``````graphql"
    Write-Host $Query
    Write-Host "``````"
    Write-Host ""
}
