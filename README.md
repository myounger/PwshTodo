# PwshTodo Module

This is a very simple PowerShell module used to create local markdown files that can be manipulated via the functions in this module.

## Getting Started

Download the module to the appropriate module path and import the module:

```powershell
Import-Module -Name 'PwshTodo'
```

To get started, create your first markdown file by using the Add-PwshTodoTask function.

```powershell
Add-PwshTodoTask -Text 'my first task'
```

To display your new task, type:

```powershell
Get-PwshTodo
```

## Function aliases

Below is a list of the exported aliases for this module

```powershell
CommandType     Name                                                Version    Source
-----------     ----                                                -------    ------
Alias           at -> Add-PwshTodoTask                              1.0        PwshTodo
Alias           gt -> Get-PwshTodo                                  1.0        PwshTodo
Alias           rmt -> Remove-PwshTodoTask                          1.0        PwshTodo
Alias           rnt -> Rename-PwshTodoTask                          1.0        PwshTodo
Alias           st -> Set-PwshTodoTaskStatus                        1.0        PwshTodo
```
