<#
.SYNOPSIS
    Transfers assets to a specified recipient.

.DESCRIPTION
    This script transfers a specified amount of assets to a recipient address. 
    The currency can be either NCG or MEAD. An optional memo can be included with the transfer.

.PARAMETER RecipientAddress
    The address of the recipient.

.PARAMETER Amount
    The amount of assets to transfer.

.PARAMETER Currency
    The type of currency to transfer. Valid values are "NCG" and "MEAD".

.PARAMETER Memo
    An optional memo to include with the transfer.

.PARAMETER PassPhrase
    The passphrase to authorize the transfer.

.PARAMETER Detailed
    If specified, provides detailed output.

.EXAMPLE
    .\asset-transfer.ps1 -RecipientAddress "0x1234" -Amount 100 -Currency "NCG"
#>

Param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$RecipientAddress,
    [Parameter(Mandatory = $true, Position = 1)]
    [int64]$Amount,
    [Parameter(Mandatory = $true, Position = 2)]
    [ValidateSet("NCG", "MEAD")]
    [string]$Currency,
    [string]$Memo,
    [Parameter(Mandatory = $true)]
    [securestring]$PassPhrase,
    [switch]$Detailed
)

enum Currency {
    NCG
    MEAD
}

$runParameters = @{
    Name       = "transferAsset"
    Arguments  = @{
        sender    = ./.scripts/get-signer.ps1
        recipient = $RecipientAddress
        currency  = [Currency]$Currency
        memo      = $Memo
        amount    = "$Amount"
    }
    PassPhrase = $PassPhrase
    Confirm    = $true
    Watch      = $true
    Detailed   = $Detailed
}
./.scripts/run-action.ps1 @runParameters
