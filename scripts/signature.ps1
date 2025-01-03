Param(
    [string]$KeyId,
    [string]$UnsignedTransaction,
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase
)

$txPath = New-TemporaryFile
$errorPath = New-TemporaryFile
try {
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($PassPhrase)
    $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
    $bytes = [System.Convert]::FromHexString($UnsignedTransaction)
    [System.IO.File]::WriteAllBytes($txPath, $bytes)
    planet key sign --passphrase $plainPassword $KeyId $txPath 2>$errorPath
    if ($LASTEXITCODE) {
        $errorMessage = $(Get-Content -Path $tempPath -Raw)
        throw $errorMessage
    }
}
finally {
    Remove-Item $txPath -ErrorAction SilentlyContinue
    Remove-Item $errorPath -ErrorAction SilentlyContinue
}
