Param(
    [Parameter(Mandatory = $true)]
    [string]$Address
)

$planetPath = ./.scripts/planet.ps1
$lines = & $planetPath key 2>$null
if ($LASTEXITCODE) {
    throw "Failed to identify key"
}

if (!$Address.StartsWith("0x")) {
    $Address = "0x$Address"
}

$idByAddress = @{}
foreach ($line in $lines) {
    $items = $line -split " "
    $idByAddress[$items[1]] = $items[0]
}

if ($idByAddress.ContainsKey($Address)) {
    $idByAddress[$Address]
}
else {
    throw "KeyId cannot be found for the given address. " +
    "The private key must be imported into the planet."
}
