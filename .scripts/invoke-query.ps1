Param(
    [Parameter(Mandatory = $true)]
    [uri]$Url,
    [Parameter(Mandatory = $true)]
    [string]$Query,
    [switch]$WhatIf
)

if ($WhatIf) {
    $query
}
else {
    $body = @{ query = $Query } | ConvertTo-Json -Depth 100
    Invoke-RestMethod -Method Post -Uri $Url -Body $body -ContentType "application/json"
}
