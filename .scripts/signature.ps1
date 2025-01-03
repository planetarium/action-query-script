Param(
    [Parameter(Mandatory = $true)]
    [string]$KeyId,
    [Parameter(Mandatory = $true)]
    [string]$UnsignedTransaction,
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase,
    [switch]$Detailed
)

$txPath = New-TemporaryFile
$errorPath = New-TemporaryFile
try {
    $plainPassword = ./.scripts/get-plain-password.ps1 -PassPhrase $PassPhrase
    $bytes = [System.Convert]::FromHexString($UnsignedTransaction)
    [System.IO.File]::WriteAllBytes($txPath, $bytes)
    $planetPath = ./.scripts/planet.ps1
    $expression = "$planetPath key sign --passphrase $plainPassword $KeyId $txPath"
    $expression2 = "$planetPath key sign --passphrase **** $KeyId $txPath"

    ./.scripts/write-log-text.ps1 -Text "Command`n" -OutputToHost:$Detailed
    ./.scripts/write-log-plain.ps1 -Text $expression2 -OutputToHost:$Detailed

    $signature = Invoke-Expression "$expression 2>$errorPath"
    if ($LASTEXITCODE) {
        $errorMessage = $(Get-Content -Path $tempPath -Raw)
        throw $errorMessage
    }

    ./.scripts/write-log-text.ps1 -Text "Result`n" -OutputToHost:$Detailed
    ./.scripts/write-log-plain.ps1 -Text $signature -OutputToHost:$Detailed

    $signature
}
finally {
    Remove-Item $txPath -ErrorAction SilentlyContinue
    Remove-Item $errorPath -ErrorAction SilentlyContinue
}
