<#
.SYNOPSIS
    Removes a key using the specified KeyId and optional PassPhrase.

.PARAMETER KeyId
    The unique identifier of the key to be removed.

.PARAMETER PassPhrase
    The passphrase for the key. If not provided, the user will be prompted to enter it twice for confirmation.

.EXAMPLE
    .\remove.ps1 -KeyId "123e4567-e89b-12d3-a456-426614174000"

    Removes the key with the specified KeyId.

.EXAMPLE
    .\remove.ps1 -KeyId "123e4567-e89b-12d3-a456-426614174000" -PassPhrase (ConvertTo-SecureString "yourPassPhrase" -AsPlainText -Force)

    Removes the key with the specified KeyId using the provided PassPhrase.
#>
Param(
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
    [guid]$KeyId,
    [securestring]$PassPhrase
)

begin {
}

process {
    Push-Location $PSScriptRoot/..
    try {
        $planetPath = ./.scripts/planet.ps1

        if (-not $PassPhrase) {
            $pass1 = Read-Host -AsSecureString "Enter PassPhrase"
            $pass2 = Read-Host -AsSecureString "Re-enter PassPhrase"
            $plainPassword1 = $pass1.Length ? (ConvertFrom-SecureString -SecureString $pass1 -AsPlainText) : ""
            $plainPassword2 = $pass2.Length ? (ConvertFrom-SecureString -SecureString $pass2 -AsPlainText) : ""

            if ($plainPassword1 -ne $plainPassword2) {
                Write-Error "PassPhrases do not match."
                exit 1
            }

            $plainPassword = $plainPassword1
        }
        else {
            $plainPassword = $PassPhrase.Length ? (ConvertFrom-SecureString -SecureString $PassPhrase -AsPlainText) : ""
        }

        & $planetPath key remove $KeyId --passphrase "$plainPassword"
        if ($LASTEXITCODE) {
            throw "Failed to remove the key."
        }
    }
    finally {
        Pop-Location
    }
}

end {
}
