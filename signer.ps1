param(
    [string]$Address,
    [switch]$Quiet
)

Push-Location $PSScriptRoot
try {
    if (-not $Address) {
        if (-not $Env:ACTION_QUERY_SIGNER) {
            throw "ACTION_QUERY_SIGNER is not set."
        }

        $Env:ACTION_QUERY_SIGNER
    }
    else {
        $items = ./key/list.ps1
        $signer = $items | Where-Object { $_.Address -eq $Address }
        if (-not $signer) {
            throw "Signer not found."
        }

        $oldSigner = $Env:ACTION_QUERY_SIGNER
        $Env:ACTION_QUERY_SIGNER = $signer.Address
        if ($Env:ACTION_QUERY_PROMPT) {
            ./.scripts/prompt.ps1 $Env:ACTION_QUERY_SIGNER $Env:ACTION_QUERY_URL
        }

        if ($oldSigner -eq $Env:ACTION_QUERY_SIGNER) {
            if (-not $Quiet) {
                Write-Host "Signer is unchanged."
            }
        }
        elseif ($oldSigner) {
            if (-not $Quiet) {
                Write-Host "Signer changed from " -NoNewline
                Write-Host "'$oldSigner'" -ForegroundColor Green -NoNewline
                Write-Host " to " -NoNewline
                Write-Host "'$Env:ACTION_QUERY_SIGNER'" -ForegroundColor Green
            }
        }
        else {
            if (-not $Quiet) {
                Write-Host "Signer set to " -NoNewline
                Write-Host "'$Env:ACTION_QUERY_SIGNER'" -ForegroundColor Green
            }
        }
    }
}
finally {
    Pop-Location
}
