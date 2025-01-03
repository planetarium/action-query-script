<#
.SYNOPSIS
    Deletes a guild.

.DESCRIPTION
    This script deletes a guild using the provided passphrase.

.PARAMETER PassPhrase
    The secure passphrase for authentication.

.PARAMETER Detailed
    Switch to enable detailed output.

.EXAMPLE
    .\guild-delete.ps1 -Detailed
#>
Param(
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase,
    [switch]$Detailed
)

$runParameters = @{
    Name       = "removeGuild"
    Arguments  = @{}
    PassPhrase = $PassPhrase
    Confirm    = $true
    Watch      = $true
    Detailed   = $Detailed
}
./.scripts/run-action.ps1 @runParameters
