<#
.SYNOPSIS
    Leaves the current guild.

.DESCRIPTION
    This script allows a user to leave the current guild using the provided passphrase.

.PARAMETER PassPhrase
    The secure passphrase for authentication.

.PARAMETER Detailed
    Switch to enable detailed output.

.EXAMPLE
    .\guild-leave.ps1 -Detailed
#>
Param(
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase,
    [switch]$Detailed
)

$runParameters = @{
    Name       = "quitGuild"
    Arguments  = @{}
    PassPhrase = $PassPhrase
    Confirm    = $true
    Watch      = $true
    Detailed   = $Detailed
}
./.scripts/run-action.ps1 @runParameters
