function Get-PwshTodo {
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .PARAMETER RemoveLineNumbers
    An optional switch. Removes the line numbers from the returned results
    .PARAMETER ShowLastFile
    An optional switch. Shows the previous and most recent todo file instead of the current day's todo file
    .EXAMPLE
    Get-PwshTodo
    Returns the current list of todo items
    .EXAMPLE
    Get-PwshTodo -ShowLastFile
    Returns the list of todo items from the previous and most recent todo text file
    .EXAMPLE
    Get-PwshTodo -RemoveLineNumbers
    Returns the list of todo items from the current todo file and removes the line numbers to easily copy/paste them into another Documents
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
        $backlogItems = ''
        foreach ($line in $content) {
            Write-Verbose $line
            if ($lineNum -notin (1,2)) {
                if ($line -like '- `[ `]*') {
                    if ($line -like "*backlog*") {
                        if (-not $RemoveLineNumbers) {
                            $backlogItems += "[$($lineNum)] "
                        }
                        $backlogItems += "$($line.TrimStart('- [ ]'))`n"
                    } else {
                        if (-not $RemoveLineNumbers) {
                            $inProgressItems += "[$($lineNum)] "
                        }
                        $inProgressItems += "$($line.TrimStart('- [ ]'))`n"
                    }
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

        Write-Host "Backlog:" -ForegroundColor Yellow
        Write-Output $backlogItems
    } else { Write-Output "Task file doesn't exist for today. Create one with Add-MryTask."}
}


New-Alias -Name 'gt' -Value Get-PwshTodo

