<#
.SYNOPSIS
    Joins a guild.

.DESCRIPTION
    This script joins a guild using the provided guild address and passphrase.

.PARAMETER GuildAddress
    The address of the guild to join.

.PARAMETER PassPhrase
    The secure passphrase for authentication.

.PARAMETER Detailed
    Switch to enable detailed output.

.EXAMPLE
    .\guild-join.ps1 -GuildAddress "guild123" -Detailed
#>
Param(
    [Parameter(Mandatory = $true)]
    [string]$GuildAddress,
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase,
    [switch]$Detailed
)

$runParameters = @{
    Name       = "joinGuild"
    Arguments  = @{
        guildAddress = $GuildAddress
    }
    PassPhrase = $PassPhrase
    Confirm    = $true
    Watch      = $true
    Detailed   = $Detailed
}
./.scripts/run-action.ps1 @runParameters
