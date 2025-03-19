
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
    $gloveId = "0x0000000000000000000000000000000000000000"
    $rock = "0x0000000000000000000000000000000000000000"
    $paper = "0x0000000000000000000000000000000000000001"
    $scissors = "0x0000000000000000000000000000000000000002"
    $numberOfGloves = 5

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

    ./mutation/user-create.ps1 -PrivateKey $organizer.PrivateKey | Out-Null
    Write-Host "Organizer created: $($organizer.Address)"
    # $txId = ./mutation/glove-register.ps1 $organizer.PrivateKey $gloveId
    # ./.scripts/transaction-result.ps1 -Url $(./url.ps1) -TxId $txId
    # Write-Host "Glove registered: $gloveId"

    $sessionParameter = @{
        PrivateKey         = $organizer.PrivateKey
        SessionId          = $sessionId
        PrizeId            = $gloveId
        MaximumUser        = 8
        MinimumUser        = 2
        RemainingUser      = 1
        StartAfter         = 20
        MaxRound           = 5
        RoundInterval      = 7
        RoundLength        = 20
        InitialHealthPoint = 100
        NumberOfGloves     = $numberOfGloves
    }
    $txId = ./mutation/session-create.ps1 @sessionParameter
    ./.scripts/transaction-result.ps1 -Url $(./url.ps1) -TxId $txId
    Write-Host "Session created: $sessionId"

    $users | ForEach-Object {
        $initialGloves = @($rock, $rock, $paper, $paper, $scissors, $scissors)
        $gloves = $initialGloves | Get-Random -Shuffle | Select-Object -First $numberOfGloves
        $userKey = $_.PrivateKey
        ./mutation/session-join.ps1 $userKey $sessionId $gloves | Out-Null
        Write-Host "User joined to session: $($_.Address) => $sessionId"
    }

    $session = ./state/session.ps1 -SessionId $sessionId
    $tip = ./node/tip.ps1

    while (($session.state -ne "Ended")) {
        Start-Sleep -Milliseconds 10

        if (($tip.height -ge $session.startHeight) -and
              ($session.phases.Count -gt 0) -and
              ($session.state -eq "Active")) {
            $phase = $session.phases[-1]
            $match = $phase.matches | Get-Random 
            $playerIndex = $match.players | Get-Random
            $player = $session.players[$playerIndex]
            $user = $users | Where-Object { $_.Address -eq "0x$($player.id)" } | Select-Object -First 1
            if ($user) {
                $gloveIndex = Get-Random -Maximum $player.gloves.length
                ./mutation/move-submit.ps1 $user.PrivateKey $sessionId $gloveIndex | Out-Null
                Write-Host "Move submitted: $($user.Address), $gloveIndex"
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
