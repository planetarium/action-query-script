Param(
    [string]$Text
)

if ($Global:LogPath) {
    Add-Content -Path $Global:LogPath -Value $Text
}