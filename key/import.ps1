<#
.SYNOPSIS
    Imports a key using the specified PrivateKey and optional PassPhrase.

.PARAMETER PrivateKey
    The private key to be imported.

.PARAMETER PassPhrase
    The passphrase for the key. If not provided, the user will be prompted to enter 
    it twice for confirmation.

.PARAMETER AsJson
    If specified, returns the result as JSON instead of a hashtable.

.PARAMETER Colorize
    If specified, colorizes the JSON output. Requires the 'pygmentize' command to be installed.

.PARAMETER SetAsSigner
    If specified, sets the imported key as the signer.
#>
Param(
    [securestring]$PrivateKey,
    [securestring]$PassPhrase,
    [switch]$AsJson,
    [switch]$Colorize,
    [switch]$SetAsSigner
)

begin {
}

process {
    if ($Colorize) {
        if (!(Get-Command "pygmentize")) {
            $message = "The -Colorize parameter requires the 'pygmentize' command to be installed."
            Write-Warning $message
            $Colorize = $false
        }
    
        if (-not $AsJson) {
            $message = "The -Colorize parameter is only supported when -AsJson or -WhatIf is set."
            Write-Warning $message
            $Colorize = $false
        }
    }

    Push-Location $PSScriptRoot/..
    try {
        $planetPath = ./.scripts/planet.ps1

        if (-not $PrivateKey) {
            $PrivateKey = Read-Host -AsSecureString "Enter PrivateKey"
        }

        if (-not $PassPhrase) {
            $pass1 = Read-Host -AsSecureString "Enter PassPhrase"
            $pass2 = Read-Host -AsSecureString "Re-enter PassPhrase"
            $plainPassword1 = ./.scripts/get-plain-password.ps1 -PassPhrase $pass1
            $plainPassword2 = ./.scripts/get-plain-password.ps1 -PassPhrase $pass2

            if ($plainPassword1 -ne $plainPassword2) {
                throw "PassPhrases do not match."
            }

            $plainPassword = $plainPassword1
        }
        else {
            $plainPassword = ./.scripts/get-plain-password.ps1 -PassPhrase $PassPhrase
        }

        $plainPrivateKey = ./.scripts/get-plain-password.ps1 -PassPhrase $PrivateKey
        $line = & $planetPath key import $plainPrivateKey --passphrase "$plainPassword" 2>$null
        if ($LASTEXITCODE) {
            throw "Failed to import the key."
        }

        $items = $line -split " "
        $result = @{
            KeyId   = $items[0]
            Address = $items[1]
        }

        if ($SetAsSigner) {
            ./signer.ps1 $result.Address
        }

        if ($AsJson) {
            $json = $result | ConvertTo-Json -Depth 10
            if ($Colorize -and (Get-Command "pygmentize")) {
                Write-Output ($json | pygmentize -l json -f terminal256 -O style=monokai)
            }
            else {
                Write-Output $json
            }
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
