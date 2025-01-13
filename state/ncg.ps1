<#
.SYNOPSIS
    Queries the NCG balance of an address.

.PARAMETER Address
    The address to query the NCG balance for.

.PARAMETER Url
    The URL of the endpoint to query. If not provided, the default URL is used.

.PARAMETER WhatIf
    If specified, outputs the query without executing it.

.PARAMETER AsJson
    If specified, returns the result as JSON instead of a hashtable.

.PARAMETER Detailed
    If specified, returns detailed information.

.EXAMPLE
    .\ncg.ps1 -Address "0x1234567890abcdef"

    Queries the NCG balance of the specified address.

.EXAMPLE
    .\ncg.ps1 -Address "0x1234567890abcdef" -AsJson

    Queries the NCG balance of the specified address and returns the result as JSON.
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
        address = $Address
    }

    $field = ./.scripts/generate-method.ps1 -Name "goldBalance" -Arguments $arguments -IndentLevel 1 -PrettyPrint
    $field = $field.TrimStart()

    $query = @"
query {
  $field
}
"@

    if ($WhatIf) {
        Write-Output $query
    }
    else {
        $Url = ./.scripts/resolve-url.ps1 -Url $Url
        $result = ./.scripts/invoke.ps1 -Url $Url -Query $query
        if (!$Detailed) {
            $result = $result.data.goldBalance
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
