<#
.SYNOPSIS
    Promotes a validator.

.DESCRIPTION
    This script promotes a validator using the provided amount and passphrase.

.PARAMETER Amount
    The amount to promote.

.PARAMETER PassPhrase
    The secure passphrase for the validator.

.PARAMETER Detailed
    If specified, provides detailed output.

.EXAMPLE
    .\validator-promote.ps1 -Amount "1000" -PassPhrase $securePassPhrase

    Promotes a validator with the provided amount and passphrase.

.EXAMPLE
    .\validator-promote.ps1 -Amount "1000" -Detailed

    Promotes a validator with detailed output.
#>
Param(
    [Parameter(Mandatory = $true)]
    [string]$Amount,
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase,
    [switch]$Detailed
)

$signer = ./.scripts/get-signer.ps1
$keyId = ./.scripts/key-id.ps1 -Address $signer
$derived = ./.scripts/key-get.ps1 -KeyId $keyId -PassPhrase $PassPhrase
$runParameters = @{
    Name       = "promoteValidator"
    Arguments  = @{
        publicKey = $derived.PublicKey
        amount    = $Amount
    }
    PassPhrase = $PassPhrase
    Confirm    = $true
    Watch      = $true
    Detailed   = $Detailed
}
./.scripts/run-action.ps1 @runParameters
