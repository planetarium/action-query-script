Param(
    [Parameter(Mandatory = $true)]
    [string]$Url,
    [Parameter(Mandatory = $true)]
    [string]$Query
)

$body = @{ query = $Query } | ConvertTo-Json
$result = Invoke-RestMethod -Method Post -Uri $url -Body $body -ContentType "application/json"
if ($result.errors) {
    throw $result.errors[0]
}

$result
