param(
    [switch]$ValidateOnly
)

$manifest = Get-Content (Join-Path $PSScriptRoot '..\app.json') -Raw | ConvertFrom-Json
$alFiles = Get-ChildItem (Join-Path $PSScriptRoot '..\src') -Recurse -Filter '*.al'

if ($alFiles.Count -eq 0) {
    throw 'No AL source files were found.'
}

Write-Host "Validated manifest for $($manifest.name) $($manifest.version)."
Write-Host "Found $($alFiles.Count) AL source files."

if (-not $ValidateOnly) {
    Write-Host 'Compiler invocation is environment-specific. Use VS Code AL: Package or configure AL-Go for CI.'
}
