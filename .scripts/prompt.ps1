function Global:ActionQueryPrompt {
    $signer = $Env:ACTION_QUERY_SIGNER
    $url = $Env:ACTION_QUERY_URL

    if (-not $signer) {
        Write-Host "NoSigner" -ForegroundColor Red -NoNewline
    }
    else {
        if ($signer -notmatch "^0x") {
            $signer = "0x" + $signer
        }

        if ($signer.Length -gt 10) {
            $signer = $signer.Substring(0, 10)
        }

        Write-Host $signer -NoNewline
    }

    Write-Host " " -NoNewline
    if (-not $url) {
        Write-Host "NoURL" -ForegroundColor Red -NoNewline
    }
    else {
        $hostname = [System.Uri]::new($url).Host
        if ($hostname.Length -gt 40) {
            $pre = $hostname.Substring(0, 19)
            $post = $hostname.Substring($hostname.Length - 18)
            $hostname = $pre + "..." + $post
        }
        Write-Host $hostname -NoNewline
    }

    return "> "
}

Set-Item -Path Function:Prompt -Value ActionQueryPrompt
