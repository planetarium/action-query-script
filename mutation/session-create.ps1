Param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$PrivateKey,
    [Parameter(Mandatory = $true, Position = 1)]
    [string]$SessionId,
    [Parameter(Mandatory = $true, Position = 2)]
    [string]$PrizeId,
    [int]$MaximumUser = 8,
    [int]$MinimumUser = 2,
    [int]$RemainingUser = 1,
    [long]$StartAfter = 20,
    [int]$MaxRounds = 5,
    [long]$RoundLength = 20,
    [long]$RoundInterval = 7,
    [int]$InitialHealthPoint = 100,
    [int]$NumberOfGloves = 5,
    [switch]$Detailed,
    [switch]$AsJson,
    [switch]$WhatIf,
    [switch]$Colorize
)

Push-Location $PSScriptRoot/..
try {
    $name = "createSession"
    $methodParameters = @{
        Name        = $name
        Arguments   = @{
            privateKey          = $PrivateKey
            sessionId           = $SessionId
            prize               = $PrizeId
            maximumUser         = $MaximumUser
            minimumUser         = $MinimumUser
            remainingUser       = $RemainingUser
            startAfter          = $StartAfter
            maxRounds           = $MaxRounds
            roundLength         = $RoundLength
            roundInterval       = $RoundInterval
            initialHealthPoint  = $InitialHealthPoint
            numberOfGloves      = $NumberOfGloves
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
