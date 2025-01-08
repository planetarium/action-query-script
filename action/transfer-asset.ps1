Param(
    [Parameter(Mandatory = $true, ParameterSetName = "KeyId", Position = 0)]
    [string]$KeyId,
    [Parameter(Mandatory = $true, ParameterSetName = "Signer", Position = 0)]
    [string]$Signer,
    [Parameter(Mandatory = $true)]
    [string]$RecipientAddress,
    [Parameter(Mandatory = $true)]
    [ValidateSet("NCG", "MEAD")]
    [string]$Currency,
    [int64]$Amount,
    [string]$Memo,
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase,
    [string]$Url
)

enum Currency {
    NCG
    MEAD
}

$name = "transferAsset"
$arguments = @{
    sender    = $Signer
    recipient = $RecipientAddress
    currency  = [Currency]$Currency
    memo      = $Memo
    amount    = "$Amount"
}

if ($KeyId) {
    ./run.ps1 -KeyId $KeyId -Name $name -Arguments $arguments -PassPhrase $PassPhrase -Url:$Url -Confirm -Watch -Quiet
}
else {
    ./run.ps1 -Signer $Signer -Name $name -Arguments $arguments -PassPhrase $PassPhrase -Url:$Url -Confirm -Watch -Quiet
}
