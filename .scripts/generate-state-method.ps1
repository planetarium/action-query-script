Param(
    [long]$BlockHeight = -1,
    [string]$BlockHash,
    [switch]$PrettyPrint,
    [int]$IndentLevel = 0,
    [switch]$TrimStart
)

$name = "stateQuery"
if ($BlockHeight -ge 0) {
    $arguments = @{
        index = $BlockHeight
    }
}
elseif ($BlockHash) {
    $arguments = @{
        hash = $BlockHash
    }
}
else {
    $arguments = @{}
}

$parameters = @{
    Name        = $name
    Arguments   = $arguments
    IndentLevel = $IndentLevel
    PrettyPrint = $PrettyPrint
    TrimStart   = $TrimStart
}
./.scripts/generate-method.ps1 @parameters
