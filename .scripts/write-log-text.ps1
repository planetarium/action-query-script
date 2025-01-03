Param(
    [string]$Text,
    [switch]$OutputToHost
)

./.scripts/write-log.ps1 -Text $Text

if ($OutputToHost) {
    Write-Host $Text
}
