Param(
    [string]$PrivateKey
)

$tempPath = New-TemporaryFile
try {
    $line = planet key derive $PrivateKey 2>$tempPath
    if ($LASTEXITCODE) {
        $errorMessage = $(Get-Content -Path $tempPath -Raw)
        throw $errorMessage
    }

    $items = $line -split " "
    @{
        "PublicKey" = $items[0]
        "Address"   = $items[1]
    }
}
finally {
    Remove-Item $tempPath -ErrorAction SilentlyContinue
}
