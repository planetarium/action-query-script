Param(
    [Parameter(ParameterSetName = "Text", Position = 0)]
    [string]$Text,
    [Parameter(ParameterSetName = "HashTable", Position = 0)]
    [hashtable]$HashTable,
    [Parameter(ParameterSetName = "PSCustomObject", Position = 0)]
    [pscustomobject]$Object,
    [switch]$Quiet
)

if (!$Quiet) {
    Write-Host "``````json"
    if ($Text) {
        Write-Host $Text
    }
    elseif ($HashTable) {
        Write-Host $(ConvertTo-Json -InputObject $HashTable -Depth 10)
    }
    elseif ($Object) {
        Write-Host $(ConvertTo-Json -InputObject $Object -Depth 10)
    }
    
    Write-Host "``````"
    Write-Host ""
}
