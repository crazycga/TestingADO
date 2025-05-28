[cmdletbinding()]
param(
    [string]$StringVar,
    [string]$BoolVar
)

Write-Host "Starting task."

Write-Host "Interpolating boolean (BoolVar): '$BoolVar'"
    switch -Regex ($BoolVar.ToLowerInvariant()) {
        '^(1|true|yes|on)$'  { $local_BoolVar = $true }
        '^(0|false|no|off)?$' { $local_BoolVar = $false } # default to false if empty or explicitly false-ish
        default { throw "Unable to parse '$InputValue' as boolean." }
    }

Write-Host "local_BoolVar: $local_BoolVar"

Write-Host "I am: $MyInvocation.MyCommand.Path"
Write-Host "Script root is: $PSScriptRoot"
Write-Host "Call stack:"
Get-PSCallStack | ForEach-Object { Write-Host $_ }

Write-Host "========================================================================================"

Write-Host "Received the following:"
Write-Host ("  {0, 20} = {1}" -f "StringVar", $StringVar)
Write-Host ("  {0, 20} = {1}" -f "BoolVar", $BoolVar)

Write-Host "HereEndethTheLesson"

Write-Host ""
Write-Host "========================================================================================"
Write-Host "Now we get into the shit...."
Write-Host "========================================================================================"
Write-Host ""

$myStringVar = $env:INPUT_STRINGVAR
Write-Host "env:INPUT_STRINGVAR = $myStringVar"

$myStringVar2 = $env:INPUT_StringVar
Write-Host "env:INPUT_StringVar = $myStringVar2"
