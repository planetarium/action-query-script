<#
.SYNOPSIS
    Claims stake rewards.

.DESCRIPTION
    This script claims stake rewards using the provided avatar address and passphrase.

.PARAMETER AvatarAddress
    The address of the avatar.

.PARAMETER PassPhrase
    The secure passphrase for authentication.

.PARAMETER Detailed
    Switch to enable detailed output.

.EXAMPLE
    .\claim-stake.ps1 -AvatarAddress "avatar123" -Detailed
#>
Param(
    [Parameter(Mandatory = $true)]
    [string]$AvatarAddress,
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase,
    [switch]$Detailed
)

$runParameters = @{
    Name       = "claimStakeReward"
    Arguments  = @{
        avatarAddress = $AvatarAddress
    }
    PassPhrase = $PassPhrase
    Confirm    = $true
    Watch      = $true
    Detailed   = $Detailed
}
./.scripts/run-action.ps1 @runParameters
