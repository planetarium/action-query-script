<#
.SYNOPSIS
    Unjails a validator.

.DESCRIPTION
    This script unjails a validator using the provided passphrase.

.PARAMETER PassPhrase
    The secure passphrase for the validator.

.PARAMETER Detailed
    If specified, provides detailed output.

.EXAMPLE
    .\validator-unjail.ps1

    Unjails a validator with the provided passphrase.

.EXAMPLE
    .\validator-unjail.ps1 -Detailed

    Unjails a validator with detailed output.
#>
Param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$SessionId,
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase,
    [switch]$Detailed,
    [switch]$Watch
)

$runParameters = @{
    Name       = "joinSession"
    Arguments  = @{
        sessionId = $SessionId
    }
    PassPhrase = $PassPhrase
    Confirm    = $true
    Watch      = $Watch
    Detailed   = $Detailed
}
./.scripts/run-action.ps1 @runParameters
