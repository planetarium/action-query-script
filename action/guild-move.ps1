<#
.SYNOPSIS
    Moves a guild to a new address.

.DESCRIPTION
    This script moves a guild to a new address using the provided guild address and passphrase.

.PARAMETER GuildAddress
    The new address of the guild.

.PARAMETER PassPhrase
    The secure passphrase for authentication.

.PARAMETER Detailed
    Switch to enable detailed output.

.EXAMPLE
    .\guild-move.ps1 -GuildAddress "guild123" -Detailed
#>
Param(
    [Parameter(Mandatory = $true)]
    [string]$GuildAddress,
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase,
    [switch]$Detailed
)

$runParameters = @{
    Name       = "moveGuild"
    Arguments  = @{
        guildAddress = $GuildAddress
    }
    PassPhrase = $PassPhrase
    Confirm    = $true
    Watch      = $true
    Detailed   = $Detailed
}
./.scripts/run-action.ps1 @runParameters
