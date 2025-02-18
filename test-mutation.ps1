
Push-Location $PSScriptRoot
$oldErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = 'Stop'
try {
    $scriptName = Split-Path -Path $MyInvocation.MyCommand -LeafBase
    $dateTime = $(Get-Date -Format "yyyy-MM-ddTHH-mm-ss")
    $filename = "$dateTime-$scriptName.md"
    $Global:LogPath = Join-Path ".logs" $filename
    $Global:LogIndex = 0
    New-Item -ItemType File -Path $Global:LogPath -Force | Out-Null
    $users = ./key/new.ps1 -Count 7
    $organizer = ./key/new.ps1 -Count 1
    $sessionId = (./key/new.ps1).Address
    $gloveId = (./key/new.ps1).Address

    Write-Host "Users:"
    Write-Host ($users | ConvertTo-Json -Depth 10)
    Write-Host "Organizer:"
    Write-Host ($organizer | ConvertTo-Json -Depth 10)
    Write-Host "SessionId: $sessionId"
    Write-Host "GloveId: $sessionId"

    $users | ForEach-Object { 
        $userKey = $_.PrivateKey
        ./mutation/user-create.ps1 -PrivateKey $userKey | Out-Null
        Write-Host "User created: $($_.Address)"
    }

    $txId = ./mutation/glove-register.ps1 $organizer.PrivateKey $gloveId
    ./.scripts/transaction-result.ps1 -Url $(./url.ps1) -TxId $txId
    Write-Host "Glove registered: $gloveId"

    $txId = ./mutation/session-create.ps1 $organizer.PrivateKey $sessionId $gloveId
    ./.scripts/transaction-result.ps1 -Url $(./url.ps1) -TxId $txId
    Write-Host "Session created: $sessionId"

    $users | ForEach-Object { 
        $userKey = $_.PrivateKey
        ./mutation/session-join.ps1 $userKey $sessionId | Out-Null
        Write-Host "User joined to session: $($_.Address) => $sessionId"
    }

    $session = ./state/session.ps1 -SessionId $sessionId
    $tip = ./node/tip.ps1
    $moveTypes = @(
        "rock"
        "paper"
        "scissors"
    )

    while (($session.state -ne "Ended")) {
        Start-Sleep -Milliseconds 10

        if (($tip.height -ge $session.startHeight) -and ($session.rounds.Count -gt 0)) {
            $round = $session.rounds[-1]
            $match = $round.matches | Get-Random 
            $move = (Get-Random -Minimum 0 -Maximum 2) -eq 0 ? $match.move1 : $match.move2
            $player = $session.players[$move.playerIndex]
            $user = $users | Where-Object { $_.Address -eq "0x$($player.id)" } | Select-Object -First 1
            if ($user) {
                $moveType = $moveTypes | Get-Random
                ./mutation/move-submit.ps1 $user.PrivateKey $sessionId $moveType | Out-Null
                Write-Host "Move submitted: $($user.Address), $moveType"
            }
            else {
                Write-Warning "User not found: $($player.id)"
            }
        }

        $session = ./state/session.ps1 -SessionId $sessionId
        $tip = ./node/tip.ps1
    }
}
finally {
    $ErrorActionPreference = $oldErrorActionPreference
    $Global:LogPath = $null
    Remove-Variable -Name LogIndex -Scope Global
    Pop-Location
}
