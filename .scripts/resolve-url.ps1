Param(
    [string]$Url
)

if (!$Url) {
    if ($env:ACTION_QUERY_URL) {
        $Url = $env:ACTION_QUERY_URL
    }
    else {
        throw "The URL for the action query is not specified. Please set the -Url parameter or the ACTION_QUERY_URL environment variable."
    }
}

$Url
