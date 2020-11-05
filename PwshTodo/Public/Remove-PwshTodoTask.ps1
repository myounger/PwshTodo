function Remove-PwshTodoTask {
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
        [Parameter(Mandatory)][string]$LineNumber
    )

    $today = Get-Date -Format 'yyyy-MM-dd'
    $file = "$($env:USERPROFILE)\Documents\Tasks\$($today).md"
    $content = Get-Content -Path $file

    $lineNum = 1
    $newContent = @()
    foreach ($line in $content) {
        if ($LineNumber -ne $lineNum) {
            $newContent += @($line)
        }
        $lineNum++
    }
    
    Set-Content -Path $file -Value $newContent -Force
}


New-Alias -Name 'rt' -Value Remove-PwshTodoTask

