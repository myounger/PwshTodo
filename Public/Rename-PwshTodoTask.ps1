function Rename-PwshTodoTask {
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
        [Parameter(Mandatory)][string]$Text
    )

    $today = Get-Date -Format 'yyyy-MM-dd'
    $file = "$($env:USERPROFILE)\Documents\Tasks\$($today).md"
    $content = Get-Content -Path $file

    $lineNum = 1
    $newContent = @()
    
    foreach ($line in $content) {
        if ($LineNumber -eq $lineNum) {
            if ($line -like '- `[ `]*') {
                $newContent += @("- [ ] $($Text)")
            } else {
                $newContent += @("- [X] $($Text)")
            }
        } else { $newContent += @($line) }
        $lineNum++
    }
    
    Set-Content -Path $file -Value $newContent -Force
}

New-Alias -Name 'rnt' -Value Rename-PwshTodoTask

