if (-not $Env:ACTION_QUERY_SIGNER) {
    throw "The Signer for the action query is not specified. " + 
    "Please set the ACTION_QUERY_SIGNER environment variable. " + 
    "ex) `$Env:ACTION_QUERY_SIGNER = <address>"
}

$Env:ACTION_QUERY_SIGNER
