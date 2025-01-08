Param(
    [string]$Url,
    [switch]$WhatIf
)

$Url = ./.scripts/resolve-url.ps1 -Url $Url

$query = @"
query {
  nodeStatus {
    tip {
      index
      hash
      miner
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
