Param(
    [uri]$Url
)

$Url = ./scripts/resolve-url.ps1 -Url $Url

$query = @"
query {
  nodeStatus {
    tip {
      index
      hash
      miner
    }
  }
}
"@

$result = ./scripts/invoke.ps1 -Url $Url -Query $query
./scripts/write-host-json.ps1 -Object $result
