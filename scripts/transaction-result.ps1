Param(
    [Parameter(Mandatory = $true)]
    [uri]$Url,
    [Parameter(Mandatory = $true)]
    [string]$TxId,
    [int]$PollingInterval = 1000,
    [int]$MaxPollingTime = 60000,
    [switch]$Quiet
)

$arguments = @{
    "txId" = $TxId
}

$field = ./scripts/generate-method.ps1 -Name "transactionResult" -Arguments $arguments -IndentLevel 2 -PrettyPrint

$query = @"
query {
  transaction{
$field {
      txStatus
      blockIndex
      exceptionNames
    }
  }
}
"@

./scripts/write-host-graphql.ps1 -Query $query -Quiet:$Quiet

$startTime = Get-Date
$endTime = $startTime.AddMilliseconds($MaxPollingTime)
$txStatus = $result.data.transaction.transactionResult.txStatus
Write-Host -NoNewline "Polling: "
while ($txStatus -ne "SUCCESS" -and $txStatus -ne "FAILURE" -and (Get-Date) -lt $endTime) {
    Write-Host -NoNewline "."
    Start-Sleep -Milliseconds $PollingInterval
    $result = ./scripts/invoke.ps1 -Url $Url -Query $query
    $txStatus = $result.data.transaction.transactionResult.txStatus
}

Write-Host "`n"

./scripts/write-host-json.ps1 -Object $result -Quiet:$Quiet
if ($txStatus -ne "SUCCESS") {
    throw "Transaction failed with status: $(ConvertTo-Json $result.data.transaction.transactionResult -Depth 10)"
}
