<#
.SYNOPSIS
    Imports a key using the specified PrivateKey and optional PassPhrase.

.PARAMETER PrivateKey
    The private key to be imported.

.PARAMETER PassPhrase
    The passphrase for the key. If not provided, the user will be prompted to enter it twice for confirmation.

.PARAMETER AsJson
    If specified, returns the result as JSON instead of a hashtable.

.EXAMPLE
    .\import.ps1 -PrivateKey "yourPrivateKey"

    Imports the key with the specified PrivateKey.

.EXAMPLE
    .\import.ps1 -PrivateKey "yourPrivateKey" -PassPhrase (ConvertTo-SecureString "yourPassPhrase" -AsPlainText -Force)

    Imports the key with the specified PrivateKey using the provided PassPhrase.

.EXAMPLE
    .\import.ps1 -PrivateKey "yourPrivateKey" -AsJson

    Imports the key with the specified PrivateKey and returns the result as JSON.
#>
Param(
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
    [ValidatePattern("[0-9a-fA-F]{64}")]
    [string]$PrivateKey,
    [securestring]$PassPhrase,
    [switch]$AsJson
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
                throw "PassPhrases do not match."
            }

            $plainPassword = $plainPassword1
        }
        else {
            $plainPassword = $PassPhrase.Length ? (ConvertFrom-SecureString -SecureString $PassPhrase -AsPlainText) : ""
        }

        $line = & $planetPath key import $PrivateKey --passphrase "$plainPassword" 2>$null
        if ($LASTEXITCODE) {
            throw "Failed to import the key."
        }

        $items = $line -split " "
        $result = @{
            KeyId   = $items[0]
            Address = $items[1]
        }

        if ($AsJson) {
            $result | ConvertTo-Json -Depth 10
        }
        else {
            $result
        }
    }
    finally {
        Pop-Location
    }
}

end {
}
