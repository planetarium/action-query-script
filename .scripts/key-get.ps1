Param(
    [Parameter(Mandatory = $true)]
    [string]$KeyId,
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase
)

$errorPath = New-TemporaryFile
try {
    $plainPassword = ""
    if ($PassPhrase.Length) {
        $plainPassword = ConvertFrom-SecureString -SecureString $PassPhrase -AsPlainText
    }
    $planetPath = ./.scripts/planet.ps1
    $publicKey = & $planetPath key export $KeyId `--public-key --passphrase `
        "$plainPassword" 2>$errorPath
    if ($LASTEXITCODE) {
        $errorMessage = $(Get-Content -Path $errorPath -Raw)
        throw $errorMessage
    }
    ./.scripts/key-derive.ps1 -PrivateKey $publicKey -IsPublicKey
}
finally {
    Remove-Item $errorPath -ErrorAction SilentlyContinue
}
