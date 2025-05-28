[cmdletbinding()]
param(
    [string]$StringVar,
    [boolean]$BoolVar
)

Write-Host "Starting task."

Write-Host "I am: $MyInvocation.MyCommand.Path"
Write-Host "Script root is: $PSScriptRoot"
Write-Host "Call stack:"
Get-PSCallStack

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
$myStringVarType = $env:INPUT_STRINGVAR?.GetType()
Write-Host "env:INPUT_STRINGVAR ($myStringVarType) = $myStringVar"

$myStringVar2 = $env:INPUT_StringVar
$myStringVarType2 = $env:INPUT_StringVar?.GetType()
Write-Host "env:INPUT_StringVar ($myStringVarType2) = $myStringVar2"

$myStringVar3 = $env:STRINGVAR
$myStringVarType3 = $env:STRINGVAR?.GetType()
Write-Host "env:STRINGVAR ($myStringVarType3) = $myStringVar3"

$myStringVar4 = $env:StringVar
$myStringVarType4 = $env:StringVar?.GetType()
Write-Host "env:StringVar ($myStringVarType4) = $myStringVar4"

$myBoolVar = $env:INPUT_BOOLVAR
$myBoolVarType = $env:INPUT_BOOLVAR?.GetType()
Write-Host "env:INPUT_BOOLVAR ($myBoolVarType) = $myBoolVar"

$myBoolVar2 = $env:INPUT_BoolVar
$myBoolVarType2 = $env:INPUT_BoolVar?.GetType()
Write-Host "env:INPUT_BoolVar ($myBoolVarType2) = $myBoolVar2"

$myBoolVar3 = $env:BOOLVAR
$myBoolVarType3 = $env:BOOLVAR?.GetType()
Write-Host "env:BOOLVAR ($myBoolVarType3) = $myBoolVar3"

$myBoolVar4 = $env:BoolVar
$myBoolVarType4 = $env:BoolVar?.GetType()
Write-Host "env:BoolVar ($myBoolVarType4) = $myBoolVar4"

Write-Host "========================================================================================"
Write-Host "DUMPING ALL ENVIRONMENT VARIABLES:"
Write-Host "========================================================================================"

Get-ChildItem Env: | Sort-Object Name | Format-Table -AutoSize Name, Value