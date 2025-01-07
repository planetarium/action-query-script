Param(
    [Parameter(Mandatory = $true, ParameterSetName = "KeyId", Position = 0)]
    [string]$KeyId,
    [Parameter(Mandatory = $true, ParameterSetName = "Signer", Position = 0)]
    [string]$Signer,
    [Parameter(Mandatory = $true)]
    [string]$GuildAddress,
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase,
    [string]$Url
)

$name = "moveGuild"
$arguments = @{
    guildAddress = $GuildAddress
}

if ($KeyId) {
    ./run.ps1 -KeyId $KeyId -Name $name -Arguments $arguments -PassPhrase $PassPhrase -Url:$Url -Confirm -Watch -Quiet
}
else {
    ./run.ps1 -Signer $Signer -Name $name -Arguments $arguments -PassPhrase $PassPhrase -Url:$Url -Confirm -Watch -Quiet
}
