$users = ./key/list.ps1 | Select-Object -First 7
$organizer = ./key/list.ps1 | Select-Object -Last 1
$sessionId = (./key/new.ps1).Address
$gloveId = (./key/new.ps1).Address

Write-Host "SessionId: $sessionId"
Write-Host "GloveId: $gloveId"

$passPhrase = Read-Host -AsSecureString "Enter PassPhrase"
$users | ForEach-Object { 
    ./signer.ps1 $_.Address | Out-Null
    ./action/user-create.ps1 -PassPhrase $passPhrase
}

./signer.ps1 $organizer.Address
./action/glove-register.ps1 $gloveId -PassPhrase $passPhrase -Watch
./action/session-create.ps1 $sessionId $gloveId -PassPhrase $passPhrase -Watch

Start-Sleep -Milliseconds 2000

./state/session.ps1 -SessionId $sessionId -AsJson -Colorize

$users | ForEach-Object { 
    ./signer.ps1 $_.Address
    ./action/session-join.ps1 $sessionId -PassPhrase $passPhrase
}
