Param(
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [hashtable]$Arguments,
    [switch]$PrettyPrint,
    [int]$IndentLevel = 0
)

$level1 = "".PadRight($IndentLevel * 2, ' ')
$level2 = "".PadRight(($IndentLevel + 1) * 2, ' ')
$expression = $level1 + $Name

if ($Arguments.Count -gt 0) {
    $expression += "("

    if ($PrettyPrint) {
        $expression += "`n"
    }

    $items = $Arguments.Keys | ForEach-Object {
        $value = $Arguments[$_]
        if ($value -is [hashtable]) {
            $value = ./.scripts/generate-field -Arguments $value -PrettyPrint
        }
        elseif ($value -is [string]) {
            $value = "`"$value`""
        }

        $key = $_
        "$($key): $value"
    }
    $items = $items -join $($PrettyPrint ? ", `n" : ", ") -split "`n"

    if ($IndentLevel -gt 0 -and $PrettyPrint) {
        $items = $items | ForEach-Object { $level2 + $_ }
    }

    if ($PrettyPrint) {
        $expression += $items -join "`n"
    }
    else {
        $expression += $items -join ", "
    }
    if ($PrettyPrint) {
        $expression += "`n$level1)"
    }
    else {
        $expression += ")"
    }
}

$expression
