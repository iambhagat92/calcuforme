# AdSense Policy Compliance Audit Script
param(
    [string]$Directory = "F:\CalcuForMe"
)

Write-Host "=== Google AdSense Policy Compliance Audit ===" -ForegroundColor Cyan
Write-Host "Scanning for common policy violations..." -ForegroundColor Yellow
Write-Host ""

$violations = @()
$warnings = @()
$recommendations = @()

# Get all HTML files
$htmlFiles = Get-ChildItem -Path $Directory -Filter "*.html" -Recurse | Where-Object { 
    $_.Name -notlike "*.bak" -and 
    $_.Directory.Name -ne "scripts" -and
    $_.Directory.Name -ne "backups"
}

Write-Host "Analyzing $($htmlFiles.Count) HTML files..." -ForegroundColor Green
Write-Host ""

foreach ($file in $htmlFiles) {
    try {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        $relativePath = $file.FullName -replace [regex]::Escape($Directory), ""
        $fileName = $relativePath.TrimStart('\')
        
        # Check for policy violations
        
        # 1. Check for insufficient content (thin content)
        $textContent = $content -replace '<[^>]+>', ' ' -replace '\s+', ' '
        $wordCount = ($textContent -split '\s+' | Where-Object { $_ -match '\w' }).Count
        
        if ($wordCount -lt 200) {
            $violations += [PSCustomObject]@{
                File = $fileName
                Issue = "Insufficient Content"
                Description = "Page has only $wordCount words (minimum 200+ recommended)"
                Severity = "High"
                Category = "Content Quality"
            }
        }
        
        # 2. Check for missing or poor meta descriptions
        if ($content -notmatch '<meta name="description"[^>]*content="[^"]{50,}') {
            $violations += [PSCustomObject]@{
                File = $fileName
                Issue = "Poor Meta Description"
                Description = "Missing or too short meta description (need 50+ characters)"
                Severity = "Medium"
                Category = "SEO/Content"
            }
        }
        
        # 3. Check for missing titles or poor titles
        if ($content -notmatch '<title>[^<]{10,}') {
            $violations += [PSCustomObject]@{
                File = $fileName
                Issue = "Poor Page Title"
                Description = "Missing or too short page title"
                Severity = "High"
                Category = "Content Quality"
            }
        }
        
        # 4. Check for placeholder/dummy content
        $placeholderPatterns = @(
            'lorem ipsum',
            'coming soon',
            'under construction',
            'placeholder',
            'dummy content',
            'test page',
            'example content'
        )
        
        foreach ($pattern in $placeholderPatterns) {
            if ($content -match $pattern -and $content -match $pattern) {
                $violations += [PSCustomObject]@{
                    File = $fileName
                    Issue = "Placeholder Content"
                    Description = "Contains placeholder/dummy content: '$pattern'"
                    Severity = "High"
                    Category = "Content Quality"
                }
            }
        }
        
        # 5. Check for duplicate content indicators
        if ($content -match 'This calculator is currently under development' -or 
            $content -match 'Please check back soon') {
            $warnings += [PSCustomObject]@{
                File = $fileName
                Issue = "Development Message"
                Description = "Contains development/placeholder messages"
                Severity = "Medium"
                Category = "Content Quality"
            }
        }
        
        # 6. Check for proper navigation
        if ($content -notmatch '<nav' -and $content -notmatch 'navbar') {
            $violations += [PSCustomObject]@{
                File = $fileName
                Issue = "Missing Navigation"
                Description = "Page lacks proper navigation structure"
                Severity = "Medium"
                Category = "User Experience"
            }
        }
        
        # 7. Check for mobile viewport meta tag
        if ($content -notmatch '<meta name="viewport"') {
            $violations += [PSCustomObject]@{
                File = $fileName
                Issue = "Not Mobile-Friendly"
                Description = "Missing viewport meta tag for mobile optimization"
                Severity = "High"
                Category = "Mobile Experience"
            }
        }
        
        # 8. Check for broken internal links (basic check)
        $internalLinks = [regex]::Matches($content, 'href="([^"]*\.html[^"]*)"')
        foreach ($match in $internalLinks) {
            $linkPath = $match.Groups[1].Value
            if ($linkPath -notmatch '^https?://') {
                $fullLinkPath = if ($linkPath.StartsWith('../')) {
                    Join-Path (Split-Path $file.FullName -Parent) $linkPath
                } elseif ($linkPath.StartsWith('./') -or -not $linkPath.StartsWith('/')) {
                    Join-Path (Split-Path $file.FullName -Parent) $linkPath
                } else {
                    Join-Path $Directory $linkPath.TrimStart('/')
                }
                
                $fullLinkPath = [System.IO.Path]::GetFullPath($fullLinkPath)
                
                if (-not (Test-Path $fullLinkPath)) {
                    $violations += [PSCustomObject]@{
                        File = $fileName
                        Issue = "Broken Internal Link"
                        Description = "Link to '$linkPath' points to non-existent file"
                        Severity = "Medium"
                        Category = "User Experience"
                    }
                }
            }
        }
        
        # 9. Check for proper structured data
        if ($content -notmatch 'application/ld\+json' -and $fileName -notmatch 'index\.html') {
            $recommendations += [PSCustomObject]@{
                File = $fileName
                Issue = "Missing Structured Data"
                Description = "No JSON-LD structured data found (recommended for better SEO)"
                Severity = "Low"
                Category = "SEO Enhancement"
            }
        }
        
    } catch {
        Write-Warning "Error processing ${fileName}: $($_.Exception.Message)"
    }
}

# Generate report
Write-Host "=== AUDIT RESULTS ===" -ForegroundColor Cyan
Write-Host ""

if ($violations.Count -gt 0) {
    Write-Host "🚨 POLICY VIOLATIONS FOUND: $($violations.Count)" -ForegroundColor Red
    Write-Host ""
    
    # Group by severity
    $highSeverity = $violations | Where-Object { $_.Severity -eq "High" }
    $mediumSeverity = $violations | Where-Object { $_.Severity -eq "Medium" }
    
    if ($highSeverity.Count -gt 0) {
        Write-Host "HIGH PRIORITY ISSUES ($($highSeverity.Count)):" -ForegroundColor Red
        $highSeverity | Format-Table -Property File, Issue, Description -Wrap -AutoSize
        Write-Host ""
    }
    
    if ($mediumSeverity.Count -gt 0) {
        Write-Host "MEDIUM PRIORITY ISSUES ($($mediumSeverity.Count)):" -ForegroundColor Yellow
        $mediumSeverity | Format-Table -Property File, Issue, Description -Wrap -AutoSize
        Write-Host ""
    }
} else {
    Write-Host "✅ No major policy violations found!" -ForegroundColor Green
}

if ($warnings.Count -gt 0) {
    Write-Host "⚠️ WARNINGS ($($warnings.Count)):" -ForegroundColor Yellow
    $warnings | Format-Table -Property File, Issue, Description -Wrap -AutoSize
    Write-Host ""
}

# Summary by category
Write-Host "=== ISSUES BY CATEGORY ===" -ForegroundColor Cyan
$allIssues = $violations + $warnings
if ($allIssues.Count -gt 0) {
    $allIssues | Group-Object Category | ForEach-Object {
        Write-Host "$($_.Name): $($_.Count) issues" -ForegroundColor White
    }
} else {
    Write-Host "No issues found by category!" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== RECOMMENDATIONS ===" -ForegroundColor Cyan
Write-Host "1. Fix all HIGH priority issues immediately"
Write-Host "2. Address MEDIUM priority issues within 1 week"
Write-Host "3. Focus on content quality - ensure all pages have 200+ meaningful words"
Write-Host "4. Ensure mobile-friendly design across all pages"
Write-Host "5. Fix broken links and navigation issues"
Write-Host "6. Add proper meta descriptions and titles to all pages"
Write-Host ""

# Export detailed report
$reportPath = Join-Path $Directory "scripts\adsense-audit-report.json"
$report = @{
    Violations = $violations
    Warnings = $warnings
    Recommendations = $recommendations
    Summary = @{
        TotalFiles = $htmlFiles.Count
        ViolationCount = $violations.Count
        WarningCount = $warnings.Count
        HighPriorityIssues = ($violations | Where-Object { $_.Severity -eq "High" }).Count
        MediumPriorityIssues = ($violations | Where-Object { $_.Severity -eq "Medium" }).Count
    }
    Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
}

$report | ConvertTo-Json -Depth 4 | Out-File $reportPath -Encoding UTF8
Write-Host "Detailed report exported to: $reportPath" -ForegroundColor Green