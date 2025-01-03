<#
.SYNOPSIS
    Queries the NCG balance of an address.

.PARAMETER Address
    The address to query the NCG balance for. If not specified, the default signer address will be used.

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
    .\ncg.ps1 -AsJson

    Queries the NCG balance of the default signer and returns the result as JSON.
#>
Param(
    [ValidateScript(
        { !$_ -or ($_ -match "(?:0x)?[0-9a-fA-F]{40}") },
        ErrorMessage = "Invalid address format.")]
    [string]$Address,
    [switch]$Detailed,
    [switch]$AsJson,
    [switch]$WhatIf,
    [switch]$Colorize
)

Push-Location $PSScriptRoot/..
try {
    $name = "goldBalance"

    $fieldParameters = @{
        Name        = $name
        Arguments   = @{
            address = $Address ? $Address : (./.scripts/get-signer.ps1)
        }
        IndentLevel = 1
        PrettyPrint = $true
    }
    $field = ./.scripts/generate-method.ps1 @fieldParameters
    $field = $field.TrimStart()

    $query = @"
query {
  $field
}
"@

    $parameters = @{
        Query      = $query
        WhatIf     = $WhatIf
        AsJson     = $AsJson
        Colorize   = $Colorize
        Properties = ($WhatIf -or $Detailed) ? @() : @("data", $name)
    }
    ./.scripts/run-state.ps1 @parameters
}
finally {
    Pop-Location
}
