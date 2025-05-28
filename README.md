# TestingADO: Azure Devops Extension Sandbox

Testing Azure Devops pipeline extension capabilities

## Agent Oddities - PowerShell

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

### Variable Passing

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

### Dumping Environment Variables

Helpful script:

```powershell
Get-ChildItem Env: | Where-Object { $_.Name -like "INPUT_*" } | Sort-Object Name | Format-Table -AutoSize Name, Value
```

## Agent Oddities - Node.js Wrappers for Powershell

As an alternative, instead of wrapping Powershell in Powershell, using Node.js (which Azure Devops thinks is a first-class citizen) as the wrapper.  A couple of problems exist with this style, but overall it can be made work.

### Variable Passing

Noticed during testing:
* passing of `boolean` variables in Powershell - yeah, it's not happening; best alternative: pass text and parse it yourself.  (The reason is because Node.js cannot pass an actual $true as a value to the boolean in Powershell.)
* in fact, Node.js can only pass text via spawn() (which is what I am using) because every argument to a spawned process is a string.
* additionally, it would appear that ALL environmental variables are indeed strings

**This implies that if you use the Node.js bootstrappers, you _must_ roll your own variable interpreters.**

### Sample Bootstrapper

```js
const { spawn } = require("child_process");
const path = require("path");
const env = { ...process.env };

const psPath = process.platform === "win32"
  ? "C:\\Program Files\\PowerShell\\7\\pwsh.exe"
  : "pwsh";

const scriptPath = path.join(__dirname, "collect-variables.ps1");

const stringVar = process.env.INPUT_STRINGVAR;
const boolVar = process.env['INPUT_BOOLVAR']?.toLowerCase() === 'true';

const args = [
  "-NoProfile",
  "-ExecutionPolicy", "Bypass",
  "-File", scriptPath,
  "-StringVar", stringVar || 'tweeter',
  "-BoolVar", boolVar ? 'true' : 'false'
];

const child = spawn(psPath, args, {
  stdio: "inherit",
  env: process.env
});

child.on("exit", process.exit);
```