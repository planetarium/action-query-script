Param(
    [Parameter(Mandatory = $true)]
    [uri]$Url,
    [Parameter(Mandatory = $true)]
    [string]$Mutation,
    [switch]$WhatIf
)

if ($WhatIf) {
    $Mutation
}
else {
    $body = @{ query = $Mutation } | ConvertTo-Json -Depth 100
    Invoke-RestMethod -Method Post -Uri $Url -Body $body -ContentType "application/json"
}
