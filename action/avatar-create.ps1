<#
.SYNOPSIS
    Creates a new avatar.

.DESCRIPTION
    This script creates a new avatar using the provided avatar details and passphrase.

.PARAMETER AvatarName
    The name of the avatar.

.PARAMETER AvatarIndex
    The index of the avatar.

.PARAMETER AvatarHair
    The hair style of the avatar.

.PARAMETER AvatarLens
    The lens style of the avatar.

.PARAMETER AvatarEar
    The ear style of the avatar.

.PARAMETER AvatarTail
    The tail style of the avatar.

.PARAMETER PassPhrase
    The secure passphrase for authentication.

.PARAMETER Detailed
    Switch to enable detailed output.

.EXAMPLE
    .\avatar-create.ps1 -AvatarName "avatar1" -Detailed
#>
Param(
    [Parameter(Mandatory = $true)]
    [ValidateLength(2, 20)]
    [string]$AvatarName,
    [ValidateRange(0, 2)]
    [int]$AvatarIndex,
    [int]$AvatarHair,
    [int]$AvatarLens,
    [int]$AvatarEar,
    [int]$AvatarTail,
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase,
    [switch]$Detailed
)

$runParameters = @{
    Name       = "createAvatar"
    Arguments  = @{
        index = $AvatarIndex
        name  = $AvatarName
        hair  = $AvatarHair
        lens  = $AvatarLens
        ear   = $AvatarEar
        tail  = $AvatarTail
    }
    PassPhrase = $PassPhrase
    Confirm    = $true
    Watch      = $true
    Detailed   = $Detailed
}
./.scripts/run-action.ps1 @runParameters
