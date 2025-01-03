Param(
    [securestring]$PassPhrase
)

if ($PassPhrase.Length) {
    ConvertFrom-SecureString -SecureString $PassPhrase -AsPlainText
}
else {
    ""
}
