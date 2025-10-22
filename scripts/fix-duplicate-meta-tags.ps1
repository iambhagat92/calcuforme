# Fix Duplicate Meta Tags Script
# This script removes redundant meta name="title" tags and duplicate Open Graph tags

Write-Host "🔧 Fixing duplicate meta tags across HTML files..." -ForegroundColor Cyan

$filesFixed = 0
$totalIssues = 0

Get-ChildItem -Path "F:\CalcuForMe" -Include "*.html" -Recurse | Where-Object {$_.FullName -notmatch "backups"} | ForEach-Object {
    $file = $_
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content
    $issuesInFile = 0
    
    Write-Host "`nProcessing: $($file.Name)" -ForegroundColor Yellow
    
    # Remove redundant meta name="title" tags (keep only <title> tags)
    if ($content -match '<meta\s+name=["'']title["''][^>]*>') {
        $content = $content -replace '<meta\s+name=["'']title["''][^>]*>\s*', ''
        $issuesInFile++
        Write-Host "  ✓ Removed redundant meta name='title' tag" -ForegroundColor Green
    }
    
    # Check for duplicate og:type tags and remove the first occurrence if found
    $ogTypeMatches = [regex]::Matches($content, '<meta\s+property=["\']og:type["\'][^>]*>', 'IgnoreCase')
    if ($ogTypeMatches.Count -gt 1) {
        $content = [regex]::Replace($content, '<meta\s+property=["\']og:type["\'][^>]*>', '', 1)
        $issuesInFile++
        Write-Host "  ✓ Removed duplicate og:type tag" -ForegroundColor Green
    }
    
    # Check for duplicate twitter:card tags and remove the first occurrence if found
    $twitterCardMatches = [regex]::Matches($content, '<meta\s+name=["\']twitter:card["\'][^>]*>', 'IgnoreCase')
    if ($twitterCardMatches.Count -gt 1) {
        $content = [regex]::Replace($content, '<meta\s+name=["\']twitter:card["\'][^>]*>', '', 1)
        $issuesInFile++
        Write-Host "  ✓ Removed duplicate twitter:card tag" -ForegroundColor Green
    }
    
    # Check for duplicate og:image tags and remove the first occurrence if found
    $ogImageMatches = [regex]::Matches($content, '<meta\s+property=["\']og:image["\'][^>]*>', 'IgnoreCase')
    if ($ogImageMatches.Count -gt 1) {
        $content = [regex]::Replace($content, '<meta\s+property=["\']og:image["\'][^>]*>', '', 1)
        $issuesInFile++
        Write-Host "  ✓ Removed duplicate og:image tag" -ForegroundColor Green
    }
    
    # Check for duplicate og:site_name tags and remove the first occurrence if found
    $ogSiteMatches = [regex]::Matches($content, '<meta\s+property=["\']og:site_name["\'][^>]*>', 'IgnoreCase')
    if ($ogSiteMatches.Count -gt 1) {
        $content = [regex]::Replace($content, '<meta\s+property=["\']og:site_name["\'][^>]*>', '', 1)
        $issuesInFile++
        Write-Host "  ✓ Removed duplicate og:site_name tag" -ForegroundColor Green
    }
    
    # Check for duplicate twitter:site tags and remove the first occurrence if found
    $twitterSiteMatches = [regex]::Matches($content, '<meta\s+name=["\']twitter:site["\'][^>]*>', 'IgnoreCase')
    if ($twitterSiteMatches.Count -gt 1) {
        $content = [regex]::Replace($content, '<meta\s+name=["\']twitter:site["\'][^>]*>', '', 1)
        $issuesInFile++
        Write-Host "  ✓ Removed duplicate twitter:site tag" -ForegroundColor Green
    }
    
    # Save the file if changes were made
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        $filesFixed++
        $totalIssues += $issuesInFile
        Write-Host "  📝 File updated with $issuesInFile fixes" -ForegroundColor Blue
    } else {
        Write-Host "  ✅ No issues found" -ForegroundColor Gray
    }
}

Write-Host "`n🎉 Duplicate meta tag fix complete!" -ForegroundColor Green
Write-Host "Files processed: $($filesFixed)" -ForegroundColor White
Write-Host "Total issues fixed: $($totalIssues)" -ForegroundColor White

# Verify the fixes
Write-Host "`n🔍 Verification check..." -ForegroundColor Cyan
$remainingIssues = 0

Get-ChildItem -Path "F:\CalcuForMe" -Include "*.html" -Recurse | Where-Object {$_.FullName -notmatch "backups"} | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    
    $metaTitleCount = ([regex]::Matches($content, 'name=["\']title["\']', 'IgnoreCase')).Count
    $ogTypeCount = ([regex]::Matches($content, 'property=["\']og:type["\']', 'IgnoreCase')).Count
    $twitterCardCount = ([regex]::Matches($content, 'name=["\']twitter:card["\']', 'IgnoreCase')).Count
    
    if ($metaTitleCount -gt 0 -or $ogTypeCount -gt 1 -or $twitterCardCount -gt 1) {
        $remainingIssues++
        Write-Host "⚠️  $($_.Name): Still has issues - Title:$metaTitleCount, OG:Type:$ogTypeCount, Twitter:Card:$twitterCardCount" -ForegroundColor Red
    }
}

if ($remainingIssues -eq 0) {
    Write-Host "✅ All duplicate meta tag issues resolved!" -ForegroundColor Green
} else {
    Write-Host "⚠️  $remainingIssues files still have issues" -ForegroundColor Yellow
}