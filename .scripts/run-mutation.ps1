Param(
    [Parameter(Mandatory = $true)]
    [string]$Mutation,
    [switch]$WhatIf,
    [switch]$AsJson,
    [switch]$Colorize,
    [string[]]$Properties
)

if ($Colorize) {
    if (!(Get-Command "pygmentize")) {
        Write-Warning "The -Colorize parameter requires the 'pygmentize' command to be installed."
        $Colorize = $false
    }

    if ((-not $AsJson) -and (-not $WhatIf)) {
        Write-Warning "The -Colorize parameter is only supported when -AsJson or -WhatIf is set."
        $Colorize = $false
    }
}

$oldErrorActionPreference = $ErrorActionPreference
$oldLogPath = $Global:LogPath
$ErrorActionPreference = 'Stop'
try {
    $url = ./.scripts/get-url.ps1
    $scriptCategory = Split-Path (Split-Path $MyInvocation.ScriptName -Parent) -Leaf
    $scriptName = Split-Path -Path $MyInvocation.ScriptName -LeafBase
    $dateTime = $(Get-Date -Format "yyyy-MM-ddTHH-mm-ss")
    if (-not $Global:LogPath) {
        $filename = "$dateTime-$scriptCategory-$scriptName.md"
        $Global:LogPath = Join-Path ".logs" $filename
        New-Item -ItemType File -Path $Global:LogPath -Force | Out-Null
    }
    else {
        if ($Global:LogIndex -is [int]) {
            $index = "$Global:LogIndex. "
            $Global:LogIndex++
        }

        ./.scripts/write-log-text.ps1 "## $index$scriptCategory-$scriptName`n" -OutputToHost:$Detailed
        ./.scripts/write-log-text.ps1 "$dateTime`n" -OutputToHost:$Detailed
    }
    
    ./.scripts/write-log-text.ps1 "### Arguments`n" -OutputToHost:$Detailed
    ./.scripts/write-log-json.ps1 -HashTable @{
        Url        = $url
        WhatIf     = $WhatIf.IsPresent
        AsJson     = $AsJson.IsPresent
        Colorize   = $Colorize.IsPresent
        Properties = $Properties
    } -OutputToHost:$Detailed

    ./.scripts/write-log-text.ps1 "### Mutation`n" -OutputToHost:$Detailed
    ./.scripts/write-log-graphql.ps1 -Query $Mutation -OutputToHost:$Detailed

    if ($WhatIf) {
        if ($Properties) {
            Write-Warning "The -Properties parameter is ignored when -WhatIf is set."
            Write-Warning $Properties.Length
        }
    
        if ($AsJson) {
            Write-Warning "The -AsJson parameter is ignored when -WhatIf is set."
        }
    
        $Colorize ? ($Mutation | pygmentize -l graphql -f terminal256 -O style=monokai) : $Mutation
    }
    else {
        $parameters = @{
            Url      = $url
            Mutation = $mutation
        }
        $result = ./.scripts/invoke-mutation.ps1 @parameters
        if ($result.errors) {
            ./.scripts/write-log-text.ps1 "### Error`n" -OutputToHost:$Detailed
            ./.scripts/write-log-json.ps1 -Object $result
            throw $result.errors[0]
        }
    
        $Properties | ForEach-Object {
            $result = $result | Select-Object -ExpandProperty $_
        }

        $json = ConvertTo-Json -InputObject $result -Depth 100

        ./.scripts/write-log-text.ps1 "### Result`n" -OutputToHost:$Detailed
        ./.scripts/write-log-json.ps1 -Object $result -OutputToHost:$Detailed

        if ($AsJson) {
            $Colorize ? ($json | pygmentize -l json -f terminal256 -O style=monokai) : $json
        }
        else {
            ConvertTo-Json $result -Depth 100 | ConvertFrom-Json -AsHashtable -Depth 100
        }
    }
}
finally {
    $ErrorActionPreference = $oldErrorActionPreference
    if (-not $oldLogPath) {
        Remove-Variable -Name LogPath -Scope Global
    }
}
