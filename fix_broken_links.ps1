# Fix broken domain links - Replace "Calculate For Me.com" with "calculateforme.xyz"

Write-Host "Fixing broken domain links from 'Calculate For Me.com' to 'calculateforme.xyz'..." -ForegroundColor Yellow

# Get all HTML files recursively
$htmlFiles = Get-ChildItem -Path . -Filter "*.html" -Recurse | Where-Object { $_.Name -ne "debug-adsense.html" }

$filesFixed = 0
$totalReplacements = 0

foreach ($file in $htmlFiles) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    $originalContent = $content
    
    # Replace all instances of the incorrect domain
    $content = $content -replace 'Calculate For Me\.com', 'calculateforme.xyz'
    
    # Count replacements in this file
    $replacements = ([regex]::Matches($originalContent, 'Calculate For Me\.com')).Count
    
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
        Write-Host "Fixed $replacements broken links in: $($file.FullName)" -ForegroundColor Green
        $filesFixed++
        $totalReplacements += $replacements
    }
}

Write-Host "`nSummary:" -ForegroundColor Cyan
Write-Host "Files fixed: $filesFixed" -ForegroundColor Green
Write-Host "Total broken links fixed: $totalReplacements" -ForegroundColor Green
Write-Host "Domain corrected from 'Calculate For Me.com' to 'calculateforme.xyz'" -ForegroundColor Yellow