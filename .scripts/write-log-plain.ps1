Param(
    [Parameter(Mandatory = $true)]
    [string]$Text,
    [switch]$OutputToHost
)

./.scripts/write-log.ps1 "``````plain"
./.scripts/write-log.ps1 $Text
./.scripts/write-log.ps1 "```````n"

if ($OutputToHost) {
    Write-Host $Text
    Write-Host "`n"
}
