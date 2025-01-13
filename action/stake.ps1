Param(
    [Parameter(Mandatory = $true, ParameterSetName = "KeyId", Position = 0)]
    [string]$KeyId,
    [Parameter(Mandatory = $true, ParameterSetName = "Signer", Position = 0)]
    [string]$Signer,
    [Parameter(Mandatory = $true)]
    [ValidateScript({ $_ -ge 0 })]
    [Int64]$Amount,
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase,
    [string]$AvatarAddress,
    [string]$Url
)

$name = "stake"
$arguments = @{
    amount = $Amount
    avatarAddress = $AvatarAddress
}

if ($KeyId) {
    ./.scripts/run.ps1 -KeyId $KeyId -Name $name -Arguments $arguments -PassPhrase $PassPhrase -Url:$Url -Confirm -Watch
}
else {
    ./.scripts/run.ps1 -Signer $Signer -Name $name -Arguments $arguments -PassPhrase $PassPhrase -Url:$Url -Confirm -Watch
}
