$users = ./key/list.ps1 | Select-Object -First 7
$organizer = ./key/list.ps1 | Select-Object -Last 1
$sessionId = (./key/new.ps1).Address
$gloveId = (./key/new.ps1).Address
Write-Host "SessionId: $sessionId"

$passPhrase = Read-Host -AsSecureString "Enter PassPhrase"
$users | ForEach-Object { 
    $userId = $_.Address
    ./signer.ps1 $userId -Quiet
    ./action/user-create.ps1 -PassPhrase $passPhrase | Out-Null
    Write-Host "User created: $userId"
}

./signer.ps1 $organizer.Address -Quiet
./action/glove-register.ps1 $gloveId -PassPhrase $passPhrase -Watch | Out-Null
Write-Host "Glove registered: $gloveId"
./action/session-create.ps1 $sessionId $gloveId -PassPhrase $passPhrase -Watch | Out-Null
Write-Host "Session created: $sessionId"

$users | ForEach-Object { 
    $userId = $_.Address
    ./signer.ps1 $userId -Quiet
    ./action/session-join.ps1 $sessionId -PassPhrase $passPhrase | Out-Null
    Write-Host "User joined to session: $userId => $sessionId"
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
        $userId = $player.id
        $moveType = $moveTypes | Get-Random
        ./signer.ps1 $userId -Quiet
        ./action/move-submit.ps1 $sessionId $moveType -PassPhrase $passPhrase | Out-Null
        Write-Host "Move submitted: $userId, $moveType"
    }

    $session = ./state/session.ps1 -SessionId $sessionId
    $tip = ./node/tip.ps1
}
