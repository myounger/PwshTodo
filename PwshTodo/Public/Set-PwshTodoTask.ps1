function Set-MryTask {
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .PARAMETER ComputerName
    The target computer 
    .PARAMETER TestADS
    An optional switch. Provide this switch if the target server is hosted in the testads.iu.edu domain
    .EXAMPLE
    
    .NOTES
    
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$LineNumber,
        [Parameter()][ValidateSet('Completed','InProgress')][string]$Status='Completed'
    )

    $today = Get-Date -Format 'yyyy-MM-dd'
    $file = "$($env:USERPROFILE)\Documents\Tasks\$($today).md"
    $content = Get-Content -Path $file

    $lineNum = 1
    $newContent = @()
    
    foreach ($line in $content) {
        if ($LineNumber -eq $lineNum) {
            if ($Status -eq 'Completed') {
                $newContent += @("- [X] $($line.TrimStart('- [ ]'))")
            } elseif ($Status -eq 'InProgress') {
                $newContent += @("- [ ] $($line.TrimStart('- [X]'))")
            }
        } else { $newContent += @($line) }
        $lineNum++
    }
    
    Set-Content -Path $file -Value $newContent -Force
}

