Param(
    [Parameter(ParameterSetName = "Text", Position = 0)]
    [string]$Text,
    [Parameter(ParameterSetName = "HashTable", Position = 0)]
    [hashtable]$HashTable,
    [Parameter(ParameterSetName = "PSCustomObject", Position = 0)]
    [object]$Object,
    [switch]$OutputToHost
)

if ($Text) {
    $json = ConvertTo-Json -InputObject $Text -Depth 10
}
elseif ($HashTable) {
    $json = ConvertTo-Json -InputObject $HashTable -Depth 10
}
elseif ($Object) {
    $json = ConvertTo-Json -InputObject $Object -Depth 10
}

./.scripts/write-log.ps1 "``````json"
./.scripts/write-log.ps1 $json
./.scripts/write-log.ps1 "```````n"

if ($OutputToHost) {
    if (Get-Command "pygmentize") {
        Write-Output ($json | pygmentize -l json -f terminal256 -O style=monokai) | Write-Host
    }
    else {
        Write-Host $json
    }

    Write-Host ""
}
