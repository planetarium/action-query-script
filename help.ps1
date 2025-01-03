param(
    [string]$ScriptPath
)

Push-Location $PSScriptRoot
try {
    $directories = @(
        "action",
        "node",
        "key",
        "state"
    )
        
    if ($ScriptPath) {
        if (-not (Test-Path $ScriptPath)) {
            throw "Script not found: $ScriptPath"       
        }

        Get-Help -Path $ScriptPath
    }
    else {
        $scriptPaths = [ordered]@{}
        $maxLength = 0
        $directories | ForEach-Object {
            $directory = $_
            $items = Get-ChildItem -Path $directory | ForEach-Object { 
                $item = Resolve-Path $_.FullName -Relative
                $maxLength = [Math]::Max($maxLength, $item.Length)
                $item
            }

            $scriptPaths[$directory] = $items
        }

        Write-Host "`e[1mSummary`e[0m"
        Write-Host "  Provides scripts to run the action and state queries."
        Write-Host ""

        Write-Host "`e[1mUsage`e[0m"
        Write-Host "  script-path [options...]"
        Write-Host ""

        $scriptPaths.Keys | ForEach-Object {
            $directory = $_
            Write-Host "`e[1m$directory`e[0m"
            $scriptPaths[$directory] | ForEach-Object {
                $item = $_
                $padding = " " * ($maxLength - $item.Length)
                $synopsis = (Get-Help $item).Synopsis
                Write-Host "  $item $padding $synopsis"
            }

            Write-Host ""
        }
        
        $helpPath = Resolve-Path "./help.ps1" -Relative
        $signerPath = Resolve-Path "./signer.ps1" -Relative
        $urlPath = Resolve-Path "./url.ps1" -Relative
        Write-Host "Run '`e[32m$helpPath <script-path>`e[0m' to get help for a specific script."
        Write-Host "Run '`e[32m$signerPath <address>`e[0m' to set the signer address."
        Write-Host "Run '`e[32m$urlPath <url>`e[0m' to set the query URL."
    }
}
finally {
    Pop-Location
}
