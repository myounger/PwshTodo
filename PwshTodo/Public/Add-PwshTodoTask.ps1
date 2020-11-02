function Add-PwshTodoTask {
    <#
    .SYNOPSIS
    Adds a new task
    .DESCRIPTION
    Appends a new task to the task markdown file for the current day. By default, all new tasks go in as "In Progress" tasks
    .PARAMETER Text
    The task text to be added as a new line to your todo list
    .PARAMETER PassThru
    An optional switch. Provide this switch if you want to return the results of the file
    .EXAMPLE
    Add-PwshTodoTask -Text "fold the laundry"
    Appends a new task to the current day's markdown file
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory,Position=0)][string]$Text,
        [Parameter()][switch]$PassThru
    )

    $today = Get-Date -Format 'yyyy-MM-dd'
    $file = "$($env:USERPROFILE)\Documents\Tasks\$($today).md"

    if (-not (Test-Path -Path $file)) {
        New-Item -Path $file -ItemType File -Force | Out-Null
        Add-Content -Path $file -Value "# Tasks" -Force
        Add-Content -Path $file -Value "" -Force

        $lastFile = Get-ChildItem -Path "$($env:USERPROFILE)\Documents\Tasks\" -File | 
            Where-Object { $_.Name -ne "$($today).md" } | Sort-Object -Property LastWriteTime -Descending | Select-Object -First 1
        if ($lastFile) {
            $lastFileContent = Get-Content -Path $lastFile.FullName
            foreach ($line in $lastFileContent) {
                if ($line -like '- `[ `]*') {
                    Add-Content -Path $file -Value $line -Force
                }
            }
        }
    }

    # Begin splat for Add-Content call
    $addContentOpts = @{
        Path = $file
        Value = "- [ ] $($Text)"
        Force = $true
    }
    # End splat for Add-Content call
    
    Add-Content @addContentOpts

    if ($PassThru) { Get-PwshTodo }
}

