Param(
    [string]$Text,
    [ValidateSet("Host", "Output", "Error", "Warning", "Verbose", "Debug")]
    [string]$OutputType = "Host"
)

switch ($OutputType) {
    "Host" { Write-Host $Text }
    "Output" { Write-Output $Text }
    "Warning" { Write-Warning $Text }
    "Error" { Write-Error $Text }
    "Verbose" { Write-Verbose $Text }
    "Debug" { Write-Debug $Text }
    default { throw "Invalid output type: $OutputType" }
}
