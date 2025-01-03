<#
.SYNOPSIS
    Unbans a guild member.

.DESCRIPTION
    This script unbans a guild member using the provided agent address and passphrase.

.PARAMETER AgentAddress
    The address of the agent to unban.

.PARAMETER PassPhrase
    The secure passphrase for authentication.

.PARAMETER Detailed
    Switch to enable detailed output.

.EXAMPLE
    .\guild-unban.ps1 -AgentAddress "agent123" -Detailed
#>
Param(
    [Parameter(Mandatory = $true)]
    [string]$AgentAddress,
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase,
    [switch]$Detailed
)

$runParameters = @{
    Name       = "unbanGuildMember"
    Arguments  = @{
        agentAddress = $AgentAddress
    }
    PassPhrase = $PassPhrase
    Confirm    = $true
    Watch      = $true
    Detailed   = $Detailed
}
./.scripts/run-action.ps1 @runParameters
