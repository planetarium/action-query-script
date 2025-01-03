Param(
    [Parameter(Mandatory = $true)]
    [string]$PrivateKey,
    [switch]$IsPublicKey
)

$errorPath = New-TemporaryFile
try {
    $planetPath = ./.scripts/planet.ps1
    if ($IsPublicKey) {
        $line = & $planetPath key derive --public-key $PrivateKey 2>$errorPath
    }
    else {
        $line = & $planetPath key derive $PrivateKey 2>$errorPath
    }

    if ($LASTEXITCODE) {
        $errorMessage = $(Get-Content -Path $errorPath -Raw)
        throw $errorMessage
    }

    $items = $line -split " "
    @{
        "PublicKey" = $items[0]
        "Address"   = $items[1]
    }
}
finally {
    Remove-Item $errorPath -ErrorAction SilentlyContinue
}
