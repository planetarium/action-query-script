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
      state
      creationHeight
      startHeight
      height
      players {
        id
        gloves
        state
      }
      phases {
        height
        matches {
          startHeight
          players
          state
          winner
          rounds {
            winner
            condition1 {
              healthPoint
              gloveUsed
              submission
            }
            condition2 {
              healthPoint
              gloveUsed
              submission
            }
          }
        }
      }
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
