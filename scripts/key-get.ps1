Param(
    [Parameter(Mandatory = $true)]
    [string]$KeyId,
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase
)

$errorPath = New-TemporaryFile
try {
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($PassPhrase)
    $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
    $publicKey = planet key export $KeyId --public-key --passphrase $plainPassword 2>$errorPath
    if ($LASTEXITCODE) {
        $errorMessage = $(Get-Content -Path $errorPath -Raw)
        throw $errorMessage
    }
    
    ./scripts/key-derive.ps1 -PrivateKey $publicKey -IsPublicKey
}
finally {
    Remove-Item $errorPath -ErrorAction SilentlyContinue
}
