Param(
  [Parameter(Mandatory = $true)]
  [string]$Text,
  [switch]$Quiet
)

Write-Host $Text
