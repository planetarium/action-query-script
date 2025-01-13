<#
.SYNOPSIS
    Queries the MEAD balance of an address.

.PARAMETER Address
    The address to query the MEAD balance for.

.PARAMETER Url
    The URL of the endpoint to query. If not provided, the default URL is used.

.PARAMETER WhatIf
    If specified, outputs the query without executing it.

.PARAMETER AsJson
    If specified, returns the result as JSON instead of a hashtable.

.PARAMETER Detailed
    If specified, returns detailed information.

.EXAMPLE
    .\mead.ps1 -Address "0x1234567890abcdef"

    Queries the MEAD balance of the specified address.

.EXAMPLE
    .\mead.ps1 -Address "0x1234567890abcdef" -AsJson

    Queries the MEAD balance of the specified address and returns the result as JSON.
#>

Param(
    [Parameter(Mandatory = $true)]
    [string]$Address,
    [string]$Url,
    [switch]$WhatIf,
    [switch]$AsJson,
    [switch]$Detailed
)

Push-Location $PSScriptRoot/..
try {
    $arguments = @{
        address  = $Address
        currency = @{ ticker = "Mead"; decimalPlaces = 18; }
    }

    $field = ./.scripts/generate-method.ps1 -Name "balance" -Arguments $arguments -IndentLevel 2 -PrettyPrint
    $field = $field.TrimStart()

    $query = @"
query {
  stateQuery {
    $field {
      quantity
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
            $result = $result.data.stateQuery.balance.quantity
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
