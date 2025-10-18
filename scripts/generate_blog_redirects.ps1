param(
    [string]$BlogDir = (Join-Path (Get-Location) 'blog')
)

if (-not (Test-Path $BlogDir)) {
    Write-Error "Blog directory not found: $BlogDir"; exit 1
}

$redirectTemplate = @'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta http-equiv="refresh" content="0; url=../{FILENAME}" />
  <link rel="canonical" href="../{FILENAME}" />
  <title>Redirecting…</title>
  <meta name="robots" content="noindex" />
  <style>body{font-family:system-ui,-apple-system,Segoe UI,Roboto,Ubuntu,"Helvetica Neue",Arial;display:flex;align-items:center;justify-content:center;height:100vh;color:#334155}</style>
</head>
<body>
  <p>Redirecting to the article… If you are not redirected, <a href="../{FILENAME}">click here</a>.</p>
</body>
</html>
'@

$files = Get-ChildItem -Path $BlogDir -Filter '*.html' -File
$created = @()
foreach ($file in $files) {
    if ($file.Name -ieq 'index.html') { continue }
    $slug = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    $folder = Join-Path $BlogDir $slug
    $indexPath = Join-Path $folder 'index.html'
    if (-not (Test-Path $folder)) { New-Item -ItemType Directory -Path $folder | Out-Null }
    if (-not (Test-Path $indexPath)) {
        $content = $redirectTemplate.Replace('{FILENAME}', $file.Name)
        $content | Set-Content -Path $indexPath -Encoding UTF8
        $created += (Resolve-Path $indexPath).Path
    }
}

if ($created.Count -gt 0) {
    Write-Output "Created redirects:" 
    $created | ForEach-Object { Write-Output " - $_" }
} else {
    Write-Output 'No new redirects needed.'
}
