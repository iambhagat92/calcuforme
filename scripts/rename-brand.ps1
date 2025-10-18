Param()
$ErrorActionPreference = 'Stop'

# File patterns to process
$extensions = @('*.html','*.js','*.css','*.md')

# 1) Replace brand name occurrences: CalcuForMe -> Calculate For Me
Get-ChildItem -Recurse -File -Include $extensions | ForEach-Object {
  $path = $_.FullName
  $content = Get-Content -Raw -Encoding UTF8 -LiteralPath $path
  if ($content -match 'CalcuForMe') {
    $updated = $content -replace 'CalcuForMe','Calculate For Me'
    Set-Content -Encoding UTF8 -LiteralPath $path -Value $updated
  }
}

# 2) Fix Twitter handle if it became @Calculate For Me -> @CalculateForMe (no spaces)
Get-ChildItem -Recurse -File -Include $extensions | ForEach-Object {
  $path = $_.FullName
  $content = Get-Content -Raw -Encoding UTF8 -LiteralPath $path
  if ($content -match '@Calculate For Me') {
    $updated = $content -replace '@Calculate For Me','@CalculateForMe'
    Set-Content -Encoding UTF8 -LiteralPath $path -Value $updated
  }
}

Write-Host "Brand rename completed."
