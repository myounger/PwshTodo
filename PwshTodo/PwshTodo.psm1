$privateFunctions = @(Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1" -ErrorAction SilentlyContinue)
$publicFunctions = @(Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1" -ErrorAction SilentlyContinue)

foreach ($file in @($privateFunctions + $publicFunctions)) {
    try { . $file.FullName }
    catch { Write-Error -Message "Failed to import function $($file.FullName): $_" }
}

Export-ModuleMember -Function $publicFunctions.Basename

