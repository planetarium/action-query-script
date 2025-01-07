Param(
    [Parameter(Mandatory = $true)]
    [string]$Text,
    [switch]$Quiet
)

if (!$Quiet) {
    Write-Host $Text
}

