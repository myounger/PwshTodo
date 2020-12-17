function Remove-PwshTodoTask {
    <#
    .SYNOPSIS
    Removes a todo task from the current day's todo file
    .DESCRIPTION
    Removes a todo task from the current day's todo file
    .PARAMETER LineNumber
    The target line number from the current day's todo file that you want to remove from the list completely
    .EXAMPLE
    Remove-PwshTodoTask -LineNumber 5
    Removes the task from the current todo file located on line number 5 of the Documents
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


New-Alias -Name 'rmt' -Value Remove-PwshTodoTask

