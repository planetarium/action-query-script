<#
.SYNOPSIS
    Stakes a validator.

.DESCRIPTION
    This script stakes a validator using the provided amount and passphrase.

.PARAMETER Amount
    The amount to stake.

.PARAMETER PassPhrase
    The secure passphrase for the validator.

.PARAMETER Detailed
    If specified, provides detailed output.

.EXAMPLE
    .\validator-stake.ps1 -Amount 1000

    Stakes a validator with the provided amount and passphrase.

.EXAMPLE
    .\validator-stake.ps1 -Amount 1000 -Detailed

    Stakes a validator with detailed output.
#>
Param(
    [Parameter(Mandatory = $true)]
    [ValidateScript({ $_ -ge 0 })]
    [bigint]$Amount,
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase,
    [switch]$Detailed
)

$runParameters = @{
    Name       = "stake"
    Arguments  = @{
        amount = $Amount
    }
    PassPhrase = $PassPhrase
    Confirm    = $true
    Watch      = $true
    Detailed   = $Detailed
}
./.scripts/run-action.ps1 @runParameters
