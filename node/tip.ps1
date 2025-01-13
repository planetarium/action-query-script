<#
.SYNOPSIS
    Retrieves the tip of the node status.

.DESCRIPTION
    This script queries the node status and retrieves the tip information, including index, hash, and miner.
    The result can be output as JSON or a hashtable, and detailed information can be toggled.

.PARAMETER Url
    The URL of the node to query.

.PARAMETER WhatIf
    If set, the query will be output without being executed.

.PARAMETER AsJson
    If set, the result will be output as JSON.

.PARAMETER Detailed
    If set, detailed information will be included in the result.

.EXAMPLE
    .\tip.ps1 -Url "http://example.com" -AsJson

.NOTES
    Author: Your Name
    Date: Today's Date
#>

Param(
    [string]$Url,
    [switch]$WhatIf,
    [switch]$AsJson,
    [switch]$Detailed
)

Push-Location $PSScriptRoot/..
try {
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
        $Url = ./.scripts/resolve-url.ps1 -Url $Url
        $result = ./.scripts/invoke.ps1 -Url $Url -Query $query
        if (!$Detailed) {
            $result = $result.data.nodeStatus.tip
        }

        if ($AsJson) {
            ./.scripts/write-json.ps1 -Object $result -Raw -OutputType Output
        }
        else {
            ./.scripts/write-hashtable.ps1 $result
        }
    }
}
finally {
    Pop-Location
}
