param(
    [string]$Url
)

Push-Location $PSScriptRoot
try {
    if (-not $Url) {
        if (-not $Env:ACTION_QUERY_URL) {
            throw "ACTION_QUERY_URL is not set."
        }
        $Env:ACTION_QUERY_URL
    }
    else {
        try {
            $Url = New-Object System.Uri($Url)
        }
        catch {
            throw "Invalid URL format: $Url"
        }

        if (-not "$Url".EndsWith("/graphql")) {
            throw "URL must end with '/graphql'."
        }

        $oldUrl = $Env:ACTION_QUERY_URL
        $Env:ACTION_QUERY_URL = "$Url"
        if ($Env:ACTION_QUERY_PROMPT) {
            ./.scripts/prompt.ps1 $Env:ACTION_QUERY_SIGNER $Env:ACTION_QUERY_URL
        }

        if ($oldUrl -eq $Env:ACTION_QUERY_URL) {
            Write-Host "URL is unchanged."
        }
        elseif ($oldUrl) {
            Write-Host "URL changed from " -NoNewline
            Write-Host "'$oldUrl'" -ForegroundColor Green -NoNewline
            Write-Host " to " -NoNewline
            Write-Host "'$Env:ACTION_QUERY_URL'" -ForegroundColor Green
        }
        else {
            Write-Host "URL set to " -NoNewline
            Write-Host "'$Env:ACTION_QUERY_URL'" -ForegroundColor Green
        }
    }
}
finally {
    Pop-Location
}
