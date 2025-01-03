<#
.SYNOPSIS
    Undelegates a validator.

.DESCRIPTION
    This script undelegates a validator using the provided share and passphrase.

.PARAMETER Share
    The share to undelegate.

.PARAMETER PassPhrase
    The secure passphrase for the validator.

.PARAMETER Detailed
    If specified, provides detailed output.

.EXAMPLE
    .\validator-undelegate.ps1 -Share "0.5"

    Undelegates a validator with the provided share and passphrase.

.EXAMPLE
    .\validator-undelegate.ps1 -Share "0.5" -Detailed

    Undelegates a validator with detailed output.
#>
Param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Share,
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase,
    [switch]$Detailed
)

$runParameters = @{
    Name       = "undelegateValidator"
    Arguments  = @{
        share = $Share
    }
    PassPhrase = $PassPhrase
    Confirm    = $true
    Watch      = $true
    Detailed   = $Detailed
}
./.scripts/run-action.ps1 @runParameters
