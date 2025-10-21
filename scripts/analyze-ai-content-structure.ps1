# Analyze content structure for AI search optimization
param(
    [string]$Directory = "F:\CalcuForMe"
)

function Analyze-ContentStructure {
    param([string]$HtmlContent, [string]$FilePath)
    
    # Extract headings
    $h1Count = ([regex]::Matches($HtmlContent, '<h1[^>]*>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)).Count
    $h2Count = ([regex]::Matches($HtmlContent, '<h2[^>]*>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)).Count
    $h3Count = ([regex]::Matches($HtmlContent, '<h3[^>]*>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)).Count
    
    # Check for structured data
    $hasJsonLd = $HtmlContent -match 'application/ld\+json'
    $hasMetaDescription = $HtmlContent -match '<meta name="description"'
    $hasMetaTitle = $HtmlContent -match '<title>'
    
    # Check for lists and structured content
    $listCount = ([regex]::Matches($HtmlContent, '<(ul|ol)[^>]*>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)).Count
    $paragraphCount = ([regex]::Matches($HtmlContent, '<p[^>]*>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)).Count
    
    # Calculate content density (text to HTML ratio)
    $textContent = $HtmlContent -replace '<[^>]+>', ' ' -replace '\s+', ' '
    $textLength = $textContent.Trim().Length
    $htmlLength = $HtmlContent.Length
    $contentDensity = if ($htmlLength -gt 0) { [math]::Round(($textLength / $htmlLength) * 100, 2) } else { 0 }
    
    return [PSCustomObject]@{
        File = $FilePath
        H1Count = $h1Count
        H2Count = $h2Count
        H3Count = $h3Count
        HasJsonLd = $hasJsonLd
        HasMetaDescription = $hasMetaDescription
        HasMetaTitle = $hasMetaTitle
        ListCount = $listCount
        ParagraphCount = $paragraphCount
        ContentDensity = $contentDensity
        TextLength = $textLength
        AIOptimizationScore = (
            ($h1Count -eq 1 ? 20 : 0) +  # Single H1
            ($h2Count -ge 2 ? 20 : ($h2Count * 10)) +  # Multiple H2s
            ($h3Count -ge 1 ? 10 : 0) +  # Has H3s
            ($hasJsonLd ? 15 : 0) +  # Structured data
            ($hasMetaDescription ? 10 : 0) +  # Meta description
            ($listCount -ge 2 ? 15 : ($listCount * 7)) +  # Lists for structure
            ($contentDensity -gt 30 ? 10 : 0)  # Good content density
        )
    }
}

$htmlFiles = Get-ChildItem -Path $Directory -Filter "*.html" -Recurse | Where-Object { 
    $_.Name -notlike "*.bak" -and 
    $_.Directory.Name -ne "scripts" -and
    $_.Directory.Name -ne "backups"
}

$results = @()

Write-Host "Analyzing $($htmlFiles.Count) HTML files for AI content optimization..." -ForegroundColor Yellow
Write-Host ""

foreach ($file in $htmlFiles) {
    try {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        $relativePath = $file.FullName -replace [regex]::Escape($Directory), ""
        $analysis = Analyze-ContentStructure $content $relativePath.TrimStart('\')
        $results += $analysis
    }
    catch {
        Write-Warning "Error processing $($file.FullName): $($_.Exception.Message)"
    }
}

# Sort by AI optimization score (lowest first - needs most work)
$results = $results | Sort-Object AIOptimizationScore

Write-Host "AI Content Optimization Analysis Results:" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host ""

# Pages needing most optimization
$needsWork = $results | Where-Object { $_.AIOptimizationScore -lt 60 } | Select-Object -First 10
if ($needsWork.Count -gt 0) {
    Write-Host "Pages needing AI optimization (Score < 60):" -ForegroundColor Red
    $needsWork | Format-Table -Property File, AIOptimizationScore, H1Count, H2Count, H3Count, ListCount, ContentDensity -AutoSize
    Write-Host ""
}

# Well-optimized pages
$wellOptimized = $results | Where-Object { $_.AIOptimizationScore -ge 80 } | Select-Object -First 5
if ($wellOptimized.Count -gt 0) {
    Write-Host "Well-optimized pages (Score >= 80):" -ForegroundColor Green
    $wellOptimized | Format-Table -Property File, AIOptimizationScore, H1Count, H2Count, H3Count, ListCount, ContentDensity -AutoSize
    Write-Host ""
}

# Overall statistics
$avgScore = ($results | Measure-Object AIOptimizationScore -Average).Average
$lowScoreCount = ($results | Where-Object { $_.AIOptimizationScore -lt 60 }).Count
$highScoreCount = ($results | Where-Object { $_.AIOptimizationScore -ge 80 }).Count

Write-Host "Summary Statistics:" -ForegroundColor Cyan
Write-Host "  Total pages analyzed: $($results.Count)"
Write-Host "  Average AI optimization score: $([math]::Round($avgScore, 1))"
Write-Host "  Pages needing optimization (< 60): $lowScoreCount"
Write-Host "  Well-optimized pages (>= 80): $highScoreCount"
Write-Host ""

# Specific recommendations
Write-Host "Key Issues Found:" -ForegroundColor Yellow
$missingH1 = ($results | Where-Object { $_.H1Count -ne 1 }).Count
$fewH2s = ($results | Where-Object { $_.H2Count -lt 2 }).Count
$noLists = ($results | Where-Object { $_.ListCount -eq 0 }).Count
$lowDensity = ($results | Where-Object { $_.ContentDensity -lt 30 }).Count

Write-Host "  Pages with incorrect H1 count (should be 1): $missingH1"
Write-Host "  Pages with few H2 headings (< 2): $fewH2s"
Write-Host "  Pages without lists/structured content: $noLists"
Write-Host "  Pages with low content density (< 30%): $lowDensity"