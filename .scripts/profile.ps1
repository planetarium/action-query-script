$Env:ACTION_QUERY_PROMPT = $true

Write-Host ("".PadRight(80, '-'))
Write-Host "Welcome to the " -NoNewline
Write-Host "action query" -ForegroundColor Green -NoNewline
Write-Host " for the " -NoNewline
Write-Host "NineChronicles" -ForegroundColor Yellow
Write-Host ""

if (-not $Env:ACTION_QUERY_URL) {
    $urlPath = Resolve-Path "./url.ps1" -Relative
    Write-Host "Please set it to the URL for the Action Query API."
    Write-Host "You can set it by running the following command:"
    Write-Host "    $urlPath '<graphql-url>'" -ForegroundColor Green
    Write-Host ""
}

if (-not $Env:ACTION_QUERY_SIGNER) {
    $signerPath = Resolve-Path "./signer.ps1" -Relative
    $newPath = Resolve-Path "./key/new.ps1" -Relative
    $importPath = Resolve-Path "./key/import.ps1" -Relative

    Write-Host "Please set it to the address of the signer."
    Write-Host "You can set it by running the following command:"
    Write-Host "    $signerPath '<signer-address>'" -ForegroundColor Green
    Write-Host ""
    
    Write-Host "To create and import a signer, run the following command:"
    Write-Host "    $newPath" -ForegroundColor Green
    Write-Host "    $importPath" -ForegroundColor Green
    Write-Host ""
}

$helpPath = Resolve-Path "./help.ps1" -Relative
Write-Host "To get help, run the following command:"
Write-Host "    $helpPath" -ForegroundColor Green
Write-Host ""

if (Test-Path -Path "/.dockerenv") {
    ./.scripts/prompt.ps1
}
elseif ($Env:CODESPACES -eq "true") {
}
