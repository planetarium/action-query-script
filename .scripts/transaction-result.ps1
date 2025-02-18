Param(
    [Parameter(Mandatory = $true)]
    [uri]$Url,
    [Parameter(Mandatory = $true)]
    [string]$TxId,
    [int]$PollingInterval = 1000,
    [int]$MaxPollingTime = 60000,
    [switch]$Detailed
)

$fieldParameters = @{
    Name        = "transactionResult"
    Arguments   = @{
        txId = $TxId
    }
    IndentLevel = 2
    PrettyPrint = $true
    TrimStart   = $true
}
$field = ./.scripts/generate-method.ps1 @fieldParameters

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

./.scripts/write-log-text.ps1 -Text "Query`n" -OutputToHost:$Detailed
./.scripts/write-log-graphql.ps1 -Query $query -OutputToHost:$Detailed

$startTime = Get-Date
$endTime = $startTime.AddMilliseconds($MaxPollingTime)
$txStatus = $result.data.transaction.transactionResult.txStatus
if ($Detailed) {
    Write-Host -NoNewline "Polling: "
}

while ($txStatus -ne "Success" -and $txStatus -ne "Failure" -and (Get-Date) -lt $endTime) {
    if ($Detailed) {
        Write-Host -NoNewline "."
    }

    Start-Sleep -Milliseconds $PollingInterval
    $result = ./.scripts/invoke-query.ps1 -Url $Url -Query $query
    if ($result.errors) {
        ./.scripts/write-log-text.ps1 -Text "Error`n" -OutputToHost:$Detailed
        ./.scripts/write-log-json.ps1 -Object $result -OutputToHost:$Detailed
        throw $result.errors[0]
    }
    
    $txStatus = $result.data.transaction.transactionResult.txStatus
}

if ($Detailed) {
    Write-Host "`n"
}

./.scripts/write-log-text.ps1 -Text "Result`n" -OutputToHost:$Detailed
./.scripts/write-log-json.ps1 -Object $result -OutputToHost:$Detailed
if ($txStatus -ne "Success") {
    $status = ConvertTo-Json $result.data.transaction.transactionResult -Depth 10
    throw "Transaction '$TxId' failed with status: $status"
}
