Param(
    [string]$Text
)

if ($Env:ACTION_QUERY_LOG_PATH) {
    Add-Content -Path $Env:ACTION_QUERY_LOG_PATH -Value $Text
}