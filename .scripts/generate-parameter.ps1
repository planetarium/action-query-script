Param(
    [Parameter(Mandatory = $true)]
    $Argument,
    [switch]$PrettyPrint,
    [int]$IndentLevel = 0
)

if ($Argument -is [hashtable]) {
    ./.scripts/generate-field -Arguments $Argument -PrettyPrint
}
elseif ($Argument -is [string]) {
    "`"$Argument`""
}
elseif ($Argument -is [array]) {
    $items = $Argument | ForEach-Object {
        $parameters = @{
            Argument    = $_
            PrettyPrint = $PrettyPrint
            IndentLevel = $IndentLevel
        }
        ./.scripts/generate-parameter @parameters
    }
    "[$($items -join ", ")]"
}
else {
    $Argument
}
