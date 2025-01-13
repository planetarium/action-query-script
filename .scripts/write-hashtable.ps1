Param(
    [Parameter(Position = 0)]
    [pscustomobject]$Object
)

ConvertTo-Json $Object -Depth 100 | ConvertFrom-Json -AsHashtable
