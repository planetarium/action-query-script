<#
.SYNOPSIS
    Claims unbonded tokens.

.DESCRIPTION
    This script claims unbonded tokens using the provided passphrase.

.PARAMETER PassPhrase
    The secure passphrase for authentication.

.PARAMETER Detailed
    Switch to enable detailed output.

.EXAMPLE
    .\claim-unbonded.ps1 -Detailed
#>
Param(
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase,
    [switch]$Detailed
)

$runParameters = @{
    Name       = "claimUnbonded"
    Arguments  = @{}
    PassPhrase = $PassPhrase
    Confirm    = $true
    Watch      = $true
    Detailed   = $Detailed
}
./.scripts/run-action.ps1 @runParameters
