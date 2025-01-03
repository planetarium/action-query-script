Param(
    [Parameter(Mandatory = $true)]
    [string]$Query,
    [switch]$OutputToHost
)

./.scripts/write-log.ps1 "``````graphql"
./.scripts/write-log.ps1 $Query
./.scripts/write-log.ps1 "```````n"

if ($OutputToHost) {
    if (Get-Command "pygmentize") {
        Write-Output ($Query | pygmentize -l graphql -f terminal256 -O style=monokai) | Write-Host
    }
    else {
        Write-Host $Query
    }
    
    Write-Host ""
}
