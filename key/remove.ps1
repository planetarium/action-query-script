<#
.SYNOPSIS
    Removes a key using the specified KeyId and optional PassPhrase.

.PARAMETER KeyId
    The unique identifier of the key to be removed.

.PARAMETER PassPhrase
    The passphrase for the key. If not provided, the user will be prompted to enter it twice
    for confirmation.

.EXAMPLE
    .\remove.ps1 -KeyId "123e4567-e89b-12d3-a456-426614174000"

    Removes the key with the specified KeyId.

.EXAMPLE
    .\remove.ps1 -KeyId "123e4567-e89b-12d3-a456-426614174000"

    Removes the key with the specified KeyId using the provided PassPhrase.
#>
Param(
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
    [guid]$KeyId,
    [securestring]$PassPhrase
)

Push-Location $PSScriptRoot/..
try {
    $planetPath = ./.scripts/planet.ps1

    if (-not $PassPhrase) {
        $pass = Read-Host -AsSecureString "Enter PassPhrase"
        $plainPassword = ./.scripts/get-plain-password.ps1 -PassPhrase $pass
    }
    else {
        $plainPassword = ./.scripts/get-plain-password.ps1 -PassPhrase $PassPhrase
    }

    & $planetPath key remove $KeyId --passphrase "$plainPassword"
    if ($LASTEXITCODE) {
        throw "Failed to remove the key."
    }
}
finally {
    Pop-Location
}
