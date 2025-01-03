Param(
    [Parameter(Mandatory = $true)]
    [hashtable]$Arguments,
    [switch]$PrettyPrint,
    [int]$IndentLevel = 0
)

$level1 = "".PadRight($IndentLevel * 2, ' ')
$level2 = "".PadRight(($IndentLevel + 1) * 2, ' ')
$expression = $level1

if ($Arguments.Count -gt 0) {
    $expression += $PrettyPrint ? "{`n" : "{ "

    $items = $Arguments.Keys | ForEach-Object {
        $value = $Arguments[$_]
        if ($value -is [hashtable]) {
            $value = ConvertTo-Json $value -Depth 10
        }
        elseif ($value -is [string]) {
            $value = "`"$value`""
        }

        $key = $_
        "$($key): $value"
    }
    $items = $items -join $($PrettyPrint ? ",`n" : ", ") -split "`n"

    if ($PrettyPrint) {
        $items = $items | ForEach-Object { $level2 + $_ }
    }

    if ($PrettyPrint) {
        $expression += $items -join "`n"
    }
    else {
        $expression += $items -join ", "
    }
    $expression += $PrettyPrint ? "`n$level1}" : ($items.Length ? " }" : "}")
}

$expression
