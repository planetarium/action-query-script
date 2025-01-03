<#
.SYNOPSIS
    Stakes an amount.

.DESCRIPTION
    This script stakes an amount using the provided amount, passphrase, and optional avatar address.

.PARAMETER Amount
    The amount to stake.

.PARAMETER PassPhrase
    The secure passphrase for the staking.

.PARAMETER AvatarAddress
    The avatar address for staking. If not provided, it will be retrieved from the state.

.PARAMETER Detailed
    If specified, provides detailed output.

.EXAMPLE
    .\stake.ps1 -Amount 1000 -PassPhrase $securePassPhrase

    Stakes an amount with the provided amount and passphrase.

.EXAMPLE
    .\stake.ps1 -Amount 1000 -AvatarAddress "0x123" -Detailed

    Stakes an amount with the provided amount, passphrase, and avatar address with detailed output.
#>
Param(
    [Parameter(Mandatory = $true)]
    [ValidateScript({ $_ -ge 0 })]
    [bigint]$Amount,
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase,
    [string]$AvatarAddress,
    [switch]$Detailed
)

$runParameters = @{
    Name       = "stake"
    Arguments  = @{
        amount        = $Amount
        avatarAddress = $AvatarAddress ? $AvatarAddress : (./state/avatar.ps1).address
    }
    PassPhrase = $PassPhrase
    Confirm    = $true
    Watch      = $true
    Detailed   = $Detailed
}
./.scripts/run-action.ps1 @runParameters
