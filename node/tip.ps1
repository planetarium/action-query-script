<#
.SYNOPSIS
    Retrieves the tip of the node status.

.DESCRIPTION
    This script queries the node status and retrieves the tip information, 
    including index, hash, and miner.
    The result can be output as JSON or a hashtable, and detailed information can be toggled.

.PARAMETER WhatIf
    If set, the query will be output without being executed.

.PARAMETER AsJson
    If set, the result will be output as JSON.

.PARAMETER Detailed
    If set, detailed information will be included in the result.

.EXAMPLE
    .\tip.ps1 -AsJson

.NOTES
    Author: Your Name
    Date: Today's Date
#>

Param(
    [switch]$Detailed,
    [switch]$AsJson,
    [switch]$WhatIf,
    [switch]$Colorize
)

Push-Location $PSScriptRoot/..
try {
    $query = @"
query {
  nodeStatus {
    tip {
      height
      hash
      miner
    }
  }
}
"@

    $parameters = @{
        Query      = $query
        WhatIf     = $WhatIf
        AsJson     = $AsJson
        Colorize   = $Colorize
        Properties = ($WhatIf -or $Detailed) ? @() : @("data", "nodeStatus", "tip")
    }
    ./.scripts/run-state.ps1 @parameters
}
finally {
    Pop-Location
}
