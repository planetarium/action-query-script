Param(
    [Parameter(Mandatory = $true)]
    [string]$ValidatorAddress,
    [string]$Url,
    [switch]$WhatIf
)

$Url = ./.scripts/resolve-url.ps1 -Url $Url
$arguments = @{
    "validatorAddress" = $ValidatorAddress
}

$field = ./.scripts/generate-method.ps1 -Name "validator" -Arguments $arguments -IndentLevel 2 -PrettyPrint
$field = $field.TrimStart()

$query = @"
query {
  stateQuery {
    $field {
      power
      isActive
      totalShares
      jailed
      jailedUntil
      tombstoned
      totalDelegated { 
        currency
        quantity
      }
    }
  }
}
"@

if ($WhatIf) {
    Write-Output $query
}
else {
    $result = ./.scripts/invoke.ps1 -Url $Url -Query $query
    ./.scripts/write-json.ps1 -Object $result -Raw -OutputType Output
}
