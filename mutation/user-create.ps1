Param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$PrivateKey,
    [switch]$Detailed,
    [switch]$AsJson,
    [switch]$WhatIf,
    [switch]$Colorize
)

Push-Location $PSScriptRoot/..
try {
    $name = "createUser"
    $methodParameters = @{
        Name        = $name
        Arguments   = @{
            privateKey = $PrivateKey
        }
        IndentLevel = 1
        PrettyPrint = $true
    }
    $method = ./.scripts/generate-method.ps1 @methodParameters
    $method = $method.TrimStart()

    $mutation = @"
mutation {
  $method
}
"@

    $runParameters = @{
        Mutation  = $mutation
        WhatIf     = $WhatIf
        AsJson     = $AsJson
        Colorize   = $Colorize
        Properties = ($WhatIf -or $Detailed) ? @() : @("data", $name)
    }
    ./.scripts/run-mutation.ps1 @runParameters
}
finally {
    Pop-Location
}
