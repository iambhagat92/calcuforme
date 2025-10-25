# Site Audit Script for calculateforme.xyz
Write-Host "🔍 Starting Site Audit..." -ForegroundColor Cyan

$results = @{
    "missing_title" = @()
    "missing_description" = @()
    "missing_canonical" = @()
    "missing_h1" = @()
    "duplicate_titles" = @{}
    "duplicate_descriptions" = @{}
    "broken_internal_links" = @()
    "missing_alt_images" = @()
    "large_images" = @()
}

$htmlFiles = Get-ChildItem -Recurse -Include "*.html" -Exclude "*backup*","*old*","*temp*"
$totalFiles = $htmlFiles.Count

Write-Host "📊 Found $totalFiles HTML files to audit" -ForegroundColor Green

$i = 0
foreach ($file in $htmlFiles) {
    $i++
    Write-Progress -Activity "Auditing" -Status "$i of $totalFiles" -PercentComplete (($i/$totalFiles)*100)
    
    $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
    if (!$content) { continue }
    
    $relativePath = $file.FullName.Replace("$PWD\", "")
    
    # Check for missing title
    if ($content -notmatch '<title>.*?</title>') {
        $results.missing_title += $relativePath
    } else {
        # Extract title for duplicate check
        if ($content -match '<title>(.*?)</title>') {
            $title = $matches[1]
            if ($results.duplicate_titles.ContainsKey($title)) {
                $results.duplicate_titles[$title] += $relativePath
            } else {
                $results.duplicate_titles[$title] = @($relativePath)
            }
        }
    }
    
    # Check for missing meta description
    if ($content -notmatch '<meta\s+name="description"') {
        $results.missing_description += $relativePath
    } else {
        # Extract description for duplicate check
        if ($content -match 'name="description"\s+content="(.*?)"') {
            $desc = $matches[1]
            if ($results.duplicate_descriptions.ContainsKey($desc)) {
                $results.duplicate_descriptions[$desc] += $relativePath
            } else {
                $results.duplicate_descriptions[$desc] = @($relativePath)
            }
        }
    }
    
    # Check for missing canonical
    if ($content -notmatch '<link\s+rel="canonical"') {
        $results.missing_canonical += $relativePath
    }
    
    # Check for missing H1
    if ($content -notmatch '<h1[^>]*>.*?</h1>') {
        $results.missing_h1 += $relativePath
    }
    
    # Check for images without alt text
    $imgMatches = [regex]::Matches($content, '<img[^>]*>')
    foreach ($img in $imgMatches) {
        if ($img.Value -notmatch 'alt=') {
            if ($results.missing_alt_images -notcontains $relativePath) {
                $results.missing_alt_images += $relativePath
            }
            break
        }
    }
}

Write-Progress -Activity "Auditing" -Completed

# Generate Report
$report = @"
# 🔍 Site Audit Report - calculateforme.xyz
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Total Files Scanned: $totalFiles

## ⚠️ Critical Issues

### Missing Title Tags ($(($results.missing_title).Count) files)
$(if ($results.missing_title.Count -gt 0) { $results.missing_title | ForEach-Object { "- $_" } | Out-String } else { "✅ No issues found" })

### Missing Meta Descriptions ($(($results.missing_description).Count) files)
$(if ($results.missing_description.Count -gt 0) { ($results.missing_description | Select-Object -First 20) | ForEach-Object { "- $_" } | Out-String } else { "✅ No issues found" })

### Missing Canonical Tags ($(($results.missing_canonical).Count) files)
$(if ($results.missing_canonical.Count -gt 0) { ($results.missing_canonical | Select-Object -First 20) | ForEach-Object { "- $_" } | Out-String } else { "✅ No issues found" })

### Missing H1 Tags ($(($results.missing_h1).Count) files)
$(if ($results.missing_h1.Count -gt 0) { ($results.missing_h1 | Select-Object -First 20) | ForEach-Object { "- $_" } | Out-String } else { "✅ No issues found" })

### Images Missing Alt Text ($(($results.missing_alt_images).Count) files)
$(if ($results.missing_alt_images.Count -gt 0) { ($results.missing_alt_images | Select-Object -First 20) | ForEach-Object { "- $_" } | Out-String } else { "✅ No issues found" })

## 📋 Duplicate Content Issues

### Duplicate Title Tags
$(
$dupTitles = $results.duplicate_titles.GetEnumerator() | Where-Object { $_.Value.Count -gt 1 }
if ($dupTitles) {
    $dupTitles | ForEach-Object {
        "**Title:** $($_.Key.Substring(0, [Math]::Min(80, $_.Key.Length)))...`n" +
        "Files: $($_.Value.Count)`n" +
        ($_.Value | Select-Object -First 3 | ForEach-Object { "  - $_" } | Out-String)
    } | Out-String
} else { "✅ No duplicate titles found" }
)

### Duplicate Meta Descriptions
$(
$dupDescs = $results.duplicate_descriptions.GetEnumerator() | Where-Object { $_.Value.Count -gt 1 }
if ($dupDescs) {
    ($dupDescs | Select-Object -First 5) | ForEach-Object {
        "**Description:** $($_.Key.Substring(0, [Math]::Min(80, $_.Key.Length)))...`n" +
        "Files: $($_.Value.Count)`n" +
        ($_.Value | Select-Object -First 3 | ForEach-Object { "  - $_" } | Out-String)
    } | Out-String
} else { "✅ No duplicate descriptions found" }
)

## 📊 Summary Statistics

| Metric | Count | Status |
|--------|-------|--------|
| Total Files | $totalFiles | ℹ️ |
| Missing Titles | $(($results.missing_title).Count) | $(if ($results.missing_title.Count -eq 0) { '✅' } else { '⚠️' }) |
| Missing Descriptions | $(($results.missing_description).Count) | $(if ($results.missing_description.Count -eq 0) { '✅' } else { '⚠️' }) |
| Missing Canonicals | $(($results.missing_canonical).Count) | $(if ($results.missing_canonical.Count -eq 0) { '✅' } else { '⚠️' }) |
| Missing H1 | $(($results.missing_h1).Count) | $(if ($results.missing_h1.Count -eq 0) { '✅' } else { '⚠️' }) |
| Missing Alt Text | $(($results.missing_alt_images).Count) | $(if ($results.missing_alt_images.Count -eq 0) { '✅' } else { '⚠️' }) |

## 🎯 Priority Actions

1. **High Priority:**
   - Fix missing title tags ($(($results.missing_title).Count) files)
   - Fix missing meta descriptions ($(($results.missing_description).Count) files)
   - Add missing H1 tags ($(($results.missing_h1).Count) files)

2. **Medium Priority:**
   - Add canonical tags ($(($results.missing_canonical).Count) files)
   - Fix duplicate titles/descriptions
   - Add alt text to images ($(($results.missing_alt_images).Count) files)

---
Report saved to: site-audit-report.md
"@

# Save report
$report | Out-File "site-audit-report.md" -Encoding UTF8

# Display summary
Write-Host "`n✅ Audit Complete!" -ForegroundColor Green
Write-Host "📄 Report saved to: site-audit-report.md" -ForegroundColor Cyan
Write-Host "`n📊 Quick Summary:" -ForegroundColor Yellow
Write-Host "   Missing Titles: $(($results.missing_title).Count)" -ForegroundColor $(if ($results.missing_title.Count -eq 0) { 'Green' } else { 'Red' })
Write-Host "   Missing Descriptions: $(($results.missing_description).Count)" -ForegroundColor $(if ($results.missing_description.Count -eq 0) { 'Green' } else { 'Red' })
Write-Host "   Missing Canonicals: $(($results.missing_canonical).Count)" -ForegroundColor $(if ($results.missing_canonical.Count -eq 0) { 'Green' } else { 'Red' })
Write-Host "   Missing H1: $(($results.missing_h1).Count)" -ForegroundColor $(if ($results.missing_h1.Count -eq 0) { 'Green' } else { 'Red' })
Write-Host "   Missing Alt Text: $(($results.missing_alt_images).Count)" -ForegroundColor $(if ($results.missing_alt_images.Count -eq 0) { 'Green' } else { 'Red' })
