<#
.SYNOPSIS
    Creates a new guild.

.DESCRIPTION
    This script creates a new guild using the provided validator address and passphrase.

.PARAMETER ValidatorAddress
    The address of the validator.

.PARAMETER PassPhrase
    The secure passphrase for authentication.

.PARAMETER Detailed
    Switch to enable detailed output.

.EXAMPLE
    .\guild-create.ps1 -ValidatorAddress "validator123" -Detailed
#>
Param(
    [Parameter(Mandatory = $true)]
    [string]$ValidatorAddress,
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase,
    [switch]$Detailed
)

$runParameters = @{
    Name       = "makeGuild"
    Arguments  = @{
        validatorAddress = $ValidatorAddress
    }
    PassPhrase = $PassPhrase
    Confirm    = $true
    Watch      = $true
    Detailed   = $Detailed
}
./.scripts/run-action.ps1 @runParameters
