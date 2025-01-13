Param(
    [Parameter(Mandatory = $true)]
    [string]$KeyId,
    [Parameter(Mandatory = $true)]
    [string]$UnsignedTransaction,
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase,
    [switch]$Quiet
)

$txPath = New-TemporaryFile
$errorPath = New-TemporaryFile
try {
    $plainPassword = $PassPhrase.Length ? (ConvertFrom-SecureString -SecureString $PassPhrase -AsPlainText) : ""
    $bytes = [System.Convert]::FromHexString($UnsignedTransaction)
    [System.IO.File]::WriteAllBytes($txPath, $bytes)
    $planetPath = ./.scripts/planet.ps1
    $signature = & $planetPath key sign --passphrase $plainPassword $KeyId $txPath 2>$errorPath
    if ($LASTEXITCODE) {
        $errorMessage = $(Get-Content -Path $tempPath -Raw)
        throw $errorMessage
    }

    if (!$Quiet) {
        Write-Host "$signature`n"
    }

    $signature
}
finally {
    Remove-Item $txPath -ErrorAction SilentlyContinue
    Remove-Item $errorPath -ErrorAction SilentlyContinue
}
