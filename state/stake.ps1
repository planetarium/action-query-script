Param(
    [Parameter(Mandatory = $true)]
    [string]$Address,
    [string]$Url,
    [switch]$WhatIf
)

$Url = ./.scripts/resolve-url.ps1 -Url $Url
$arguments = @{
    address = $Address
}

$field = ./.scripts/generate-method.ps1 -Name "stakeState" -Arguments $arguments -IndentLevel 2 -PrettyPrint
$field = $field.TrimStart()

$query = @"
query {
  stateQuery {
    $field {
      deposit
      startedBlockIndex
      receivedBlockIndex
      cancellableBlockIndex
      claimableBlockIndex
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
