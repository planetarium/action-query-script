Param(
    [Parameter(Mandatory = $true, ParameterSetName = "KeyId", Position = 0)]
    [string]$KeyId,
    [Parameter(Mandatory = $true, ParameterSetName = "Signer", Position = 0)]
    [string]$Signer,
    [Parameter(Mandatory = $true)]
    [ValidateRange(0, 2)]
    [int]$AvatarIndex,
    [Parameter(Mandatory = $true)]
    [ValidateLength(2, 20)]
    [string]$AvatarName,
    [int]$AvatarHair,
    [int]$AvatarLens,
    [int]$AvatarEar,
    [int]$AvatarTail,
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase,
    [string]$Url
)

$name = "createAvatar"
$arguments = @{
    index = $AvatarIndex
    name  = $AvatarName
    hair  = $AvatarHair
    lens  = $AvatarLens
    ear   = $AvatarEar
    tail  = $AvatarTail
}

if ($KeyId) {
    ./.scripts/run.ps1 -KeyId $KeyId -Name $name -Arguments $arguments -PassPhrase $PassPhrase -Url:$Url -Confirm -Watch
}
else {
    ./.scripts/run.ps1 -Signer $Signer -Name $name -Arguments $arguments -PassPhrase $PassPhrase -Url:$Url -Confirm -Watch
}
