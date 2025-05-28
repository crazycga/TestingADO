# TestingADO: Azure Devops Extension Sandbox

Testing Azure Devops pipeline extension capabilities

## Agent Oddities

Microsoft Hosted Agents require the presences of the `VstsTaskSdk` for Powershell to be present - or at the very least, the _appearance_ of that module.  To get around this, two dummy files must be placed in `ps_modules\VstsTaskSdk`, one for `VstsTaskSdk.psd1` and one for `VstsTaskSdk.psm1`.  The following stubs appear to work (for simple scenarios, at least:)

### VstsTaskSdk.psd1
```powershell
@{
    RootModule = 'VstsTaskSdk.psm1'
    ModuleVersion = '0.0.1'
    GUID = '00000000-0000-0000-0000-000000000000'
    Author = 'Stub'
    Description = 'Stub module to satisfy Azure DevOps agent.'
}
```

### VstsTaskSdk.psm1

```powershell
function Invoke-VstsTaskScript {
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [scriptblock]$ScriptBlock
    )

    Write-Host "Running script block via stubbed Invoke-VstsTaskScript..."
    & $ScriptBlock
}
```

## Variable Passing

* variables are indeed passed in using `$env` variables
* variables are prepended with `INPUT_` and the variable name
* variables appear to be stored as text
* variables are accessible with `$env:INPUT_STRINGVAR` where `STRINGVAR` is the variable name; they do **not** appear to be case sensitive, however, they are contained in the environment as upper-case

Example:

```
2025-05-28T17:00:30.2349259Z ImageVersion                                                    20250511.1.0                                           
2025-05-28T17:00:30.2353022Z INPUT_BOOLVAR                                                   true                                                   
2025-05-28T17:00:30.2353342Z INPUT_STRINGVAR                                                 This is a string                                       
2025-05-28T17:00:30.2354005Z JAVA_HOME                                                       C:\hostedtoolcache\windows\Java_Temurin-Hotspot_jdk\...
```

This was taken from an enumeration of the environment variables at run-time in a pipeline.

## Dumping Environment Variables

Helpful script:

```powershell
Get-ChildItem Env: | Where-Object { $_.Name -like "INPUT_*" } | Sort-Object Name | Format-Table -AutoSize Name, Value
```