function Rename-PwshTodoTask {
    <#
    .SYNOPSIS
    Renames the todo task text
    .DESCRIPTION
    Renames the todo task text
    .PARAMETER LineNumber
    The target line number of the todo item you want to update the text for
    .PARAMETER Text
    The new text you want to insert at a specific line number
    .EXAMPLE
    Rename-PwshTodoTask -LineNumber 4 -Text "This is the new text"
    Renames the text from line 4 from the current todo file with the text "This is the new text"
    .EXAMPLE
    Rename-PwshTodoTask -LineNumber 4 -Text "backlog: This is a backlog item"
    Renames the text from line 4 from the current todo file with the text "backlog: This is a backlog item". The addition of the word 
    "backlog" in the text will visually move the item to the Backlog section when doing a Get-PwshTodo call
    .NOTES
    ! Adding the word "backlog" to the todo item text will move it to the "Backlog" section of the Get-PwshTodo results
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

