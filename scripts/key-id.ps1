Param(
    [string]$Address
)

$lines = planet key 2>$null
if ($LASTEXITCODE) {
    throw "Failed to identify key"
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
    throw "Key not found"
}
