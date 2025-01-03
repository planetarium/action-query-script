if (-not $Env:ACTION_QUERY_URL) {
    throw "The URL for the action query is not specified. " + 
    "Please set the ACTION_QUERY_URL environment variable. " + 
    "ex) `$Env:ACTION_QUERY_URL = <graphql-url>"
}

$Env:ACTION_QUERY_URL
