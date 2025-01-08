Param(
    [Parameter(ParameterSetName = "Text", Position = 0)]
    [string]$Text,
    [Parameter(ParameterSetName = "HashTable", Position = 0)]
    [hashtable]$HashTable,
    [Parameter(ParameterSetName = "PSCustomObject", Position = 0)]
    [pscustomobject]$Object,
    [ValidateSet("Host", "Output", "Error", "Warning", "Verbose", "Debug")]
    [string]$OutputType = "Host",
    [switch]$Quiet,
    [switch]$Raw
)

function Write-Text {
    param (
        [string]$Text
    )

    ./.scripts/write-text.ps1 -Text $Text -OutputType $OutputType
}

if (!$Quiet) {
    if (!$Raw) {
        Write-Text "``````json"
    }

    if ($Text) {
        Write-Text $Text
    }
    elseif ($HashTable) {
        Write-Text $(ConvertTo-Json -InputObject $HashTable -Depth 10)
    }
    elseif ($Object) {
        Write-Text $(ConvertTo-Json -InputObject $Object -Depth 10)
    }

    if (!$Raw) {
        Write-Text "``````"
    }

    Write-Text ""
}
