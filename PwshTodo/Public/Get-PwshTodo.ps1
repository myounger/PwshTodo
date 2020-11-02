function Get-PwshTodo {
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
        [Parameter()][switch]$RemoveLineNumbers,
        [Parameter()][switch]$ShowLastFile
    )

    $today = Get-Date -Format 'yyyy-MM-dd'
    if ($ShowLastFile) {
        $file = Get-ChildItem -Path "$($env:USERPROFILE)\Documents\Tasks\" -File | 
            Where-Object { $_.Name -ne "$($today).md" } | Sort-Object -Property LastWriteTime -Descending | Select-Object -First 1
    } else {
        $file = "$($env:USERPROFILE)\Documents\Tasks\$($today).md"
    }
    
    if (Test-Path -Path $file) {
        $content = Get-Content -Path $file
        $lineNum = 1
        $inProgressItems = ''
        $completedItems = ''
        foreach ($line in $content) {
            Write-Verbose $line
            if ($lineNum -notin (1,2)) {
                if ($line -like '- `[ `]*') {
                    if (-not $RemoveLineNumbers) {
                        $inProgressItems += "[$($lineNum)] "
                    }
                    $inProgressItems += "$($line.TrimStart('- [ ]'))`n"
                } else {
                    if (-not $RemoveLineNumbers) {
                        $completedItems += "[$($lineNum)] "
                    }
                    $completedItems += "$($line.TrimStart('- [X]'))`n"
                }
            }
            $lineNum++
        }

        if (-not $inProgressItems) { $inProgressItems = "None`n" }
        if (-not $completedItems) { $completedItems = "None`n" }
        Write-Host "In Progress:" -ForegroundColor Magenta
        Write-Output $inProgressItems

        Write-Host "Completed:" -ForegroundColor Green
        Write-Output $completedItems
    } else { Write-Output "Task file doesn't exist for today. Create one with Add-MryTask."}
}
