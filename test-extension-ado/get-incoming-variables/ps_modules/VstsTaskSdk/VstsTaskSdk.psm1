Write-Host "✅ VstsTaskSdk.psm1 LOADED"
function Invoke-VstsTaskScript {
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [scriptblock]$ScriptBlock
    )

    Write-Host "Running script block via stubbed Invoke-VstsTaskScript..."
    & $ScriptBlock
}