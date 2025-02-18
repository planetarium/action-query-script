Param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$PrivateKey,
    [Parameter(Mandatory = $true, Position = 1)]
    [string]$GloveId,
    [switch]$Detailed,
    [switch]$AsJson,
    [switch]$WhatIf,
    [switch]$Colorize
)

Push-Location $PSScriptRoot/..
try {
    $name = "registerGlove"
    $methodParameters = @{
        Name        = $name
        Arguments   = @{
            privateKey = $PrivateKey
            gloveId    = $GloveId
        }
        IndentLevel = 1
        PrettyPrint = $true
        TrimStart   = $true
    }
    $method = ./.scripts/generate-method.ps1 @methodParameters

    $mutation = @"
mutation {
  $method
}
"@

    $runParameters = @{
        Mutation   = $mutation
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
