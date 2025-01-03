Param(
    [Parameter(Mandatory = $true)]
    [uri]$Url,
    [Parameter(Mandatory = $true)]
    [string]$Query,
    [switch]$WhatIf,
    [string[]]$Properties
)

if ($WhatIf) {
    $query
}
else {
    $body = @{ query = $Query } | ConvertTo-Json -Depth 100
    $result = Invoke-RestMethod -Method Post -Uri $Url -Body $body -ContentType "application/json"
    if ($result.errors) {
        throw $result.errors[0]
    }

    $Properties | ForEach-Object {
        $result = $result | Select-Object -ExpandProperty $_
    }

    $result
}
