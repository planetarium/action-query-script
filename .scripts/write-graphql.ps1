Param(
    [Parameter(Mandatory = $true)]
    [string]$Query,
    [ValidateSet("Host", "Output", "Error", "Warning", "Verbose", "Debug")]
    [string]$OutputType = "Host",
    [switch]$Quiet
)

function Write-Text {
    param (
        [string]$Text
    )

    ./.scripts/write-text.ps1 -Text $Text -OutputType $OutputType
}

if (!$Quiet) {
    if (!$Raw) {
        Write-Text "``````graphql"
    }

    Write-Text $Query

    if (!$Raw) {
        Write-Text "``````"
    }

    Write-Text ""
}
