Param(
    [Parameter(Mandatory = $true, ParameterSetName = "KeyId", Position = 0)]
    [string]$KeyId,
    [Parameter(Mandatory = $true, ParameterSetName = "Signer", Position = 0)]
    [string]$Signer,
    [Parameter(Mandatory = $true)]
    [string]$AvatarAddress,
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase,
    [string]$Url
)

$name = "claimStakeReward"
$arguments = @{
    avatarAddress = $AvatarAddress
}

if ($KeyId) {
    ./.scripts/run.ps1 -KeyId $KeyId -Name $name -Arguments $arguments -PassPhrase $PassPhrase -Url:$Url -Confirm -Watch
}
else {
    ./.scripts/run.ps1 -Signer $Signer -Name $name -Arguments $arguments -PassPhrase $PassPhrase -Url:$Url -Confirm -Watch
}
