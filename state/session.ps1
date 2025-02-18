Param(
    [ValidateScript(
        { !$_ -or ($_ -match "(?:0x)?[0-9a-fA-F]{40}") },
        ErrorMessage = "Invalid address format.")]
    [string]$SessionId,
    [ValidateScript(
        { $_ -ge 0 },
        ErrorMessage = "Block height must be greater than or equal to 0.")]
    [long]$BlockHeight = -1,
    [string]$BlockHash,
    [switch]$Detailed,
    [switch]$AsJson,
    [switch]$WhatIf,
    [switch]$Colorize
)

Push-Location $PSScriptRoot/..
try {
    $stateParameters = @{
        BlockHeight = $BlockHeight
        BlockHash   = $BlockHash
        IndentLevel = 1
        PrettyPrint = $true
        TrimStart   = $true
    }
    $stateField = ./.scripts/generate-state-method.ps1 @stateParameters

    $name = "session"
    $fieldParameters = @{
        Name        = $name
        Arguments   = @{
            sessionId = $SessionId
        }
        IndentLevel = 2
        PrettyPrint = $true
        TrimStart   = $true
    }
    $field = ./.scripts/generate-method.ps1 @fieldParameters

    $query = @"
query {
  $stateField {
    $field {
      rounds {
        height
        matches {
          move1 {
            playerIndex
            type
          }
          move2 {
            playerIndex
            type
          }
        }
      }
      players {
        id
        glove
        state
      }
      state
      creationHeight
      startHeight
    }
  }
}
"@

    $parameters = @{
        Query      = $query
        WhatIf     = $WhatIf
        AsJson     = $AsJson
        Colorize   = $Colorize
        Properties = ($WhatIf -or $Detailed) ? @() : @("data", "stateQuery", $name)
    }
    ./.scripts/run-state.ps1 @parameters
}
finally {
    Pop-Location
}
