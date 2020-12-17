function Set-PwshTodoTaskStatus {
    <#
    .SYNOPSIS
    Sets the status of a target todo task
    .DESCRIPTION
    Sets the status of a target todo task
    .PARAMETER LineNumber
    The target line number of the todo task you want to change the status on 
    .PARAMETER Status
    An optional string. Provide this switch if the target server is hosted in the testads.iu.edu domain
    .EXAMPLE
    Set-PwshTodoTaskStatus -LineNumber 4
    Sets the task status to 'Completed' (default status) for the task on line number 4 of the current todo file. This will move the task
    from the In Progress section to the Completed section
    .EXAMPLE
    Set-PwshTodoTaskStatus -LineNumber 4 -Status 'InProgress'
    Sets the task status to 'InProgress' for the task on line number 4 of the current todo file. This will move the task
    from the Completed section to the In Progress section
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


New-Alias -Name 'st' -Value Set-PwshTodoTaskStatus

