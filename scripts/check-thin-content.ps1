# Check for thin content pages (less than 200 words)
param(
    [string]$Directory = "F:\CalcuForMe",
    [int]$MinWords = 200
)

function Count-Words {
    param([string]$HtmlContent)
    
    # Remove script and style tags
    $content = $HtmlContent -replace '<script[^>]*>.*?</script>', '' -replace '<style[^>]*>.*?</style>', ''
    # Remove HTML tags
    $content = $content -replace '<[^>]+>', ' '
    # Decode HTML entities
    $content = [System.Web.HttpUtility]::HtmlDecode($content)
    # Split into words and count
    $words = $content -split '\s+' | Where-Object { $_ -match '\w' }
    return $words.Count
}

Add-Type -AssemblyName System.Web

$htmlFiles = Get-ChildItem -Path $Directory -Filter "*.html" -Recurse | Where-Object { 
    $_.Name -notlike "*.bak" -and 
    $_.Directory.Name -ne "scripts" -and
    $_.Directory.Name -ne "backups"
}

$thinPages = @()

Write-Host "Analyzing $($htmlFiles.Count) HTML files for thin content..." -ForegroundColor Yellow
Write-Host "Minimum word count: $MinWords" -ForegroundColor Yellow
Write-Host ""

foreach ($file in $htmlFiles) {
    try {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        $wordCount = Count-Words $content
        
        if ($wordCount -lt $MinWords) {
            $relativePath = $file.FullName -replace [regex]::Escape($Directory), ""
            $thinPages += [PSCustomObject]@{
                File = $relativePath.TrimStart('\')
                WordCount = $wordCount
                Shortfall = $MinWords - $wordCount
            }
        }
    }
    catch {
        Write-Warning "Error processing $($file.FullName): $($_.Exception.Message)"
    }
}

if ($thinPages.Count -gt 0) {
    Write-Host "Found $($thinPages.Count) pages with thin content:" -ForegroundColor Red
    Write-Host ""
    
    $thinPages | Sort-Object WordCount | Format-Table -Property File, WordCount, Shortfall -AutoSize
    
    Write-Host ""
    Write-Host "Pages that need the most content:" -ForegroundColor Yellow
    $thinPages | Sort-Object WordCount | Select-Object -First 5 | ForEach-Object {
        Write-Host "  $($_.File) - $($_.WordCount) words (need $($_.Shortfall) more)" -ForegroundColor Red
    }
}
else {
    Write-Host "✓ All pages have sufficient content ($MinWords+ words)" -ForegroundColor Green
}

Write-Host ""
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  Total pages analyzed: $($htmlFiles.Count)"
Write-Host "  Pages with thin content: $($thinPages.Count)"
Write-Host "  Pages with sufficient content: $($htmlFiles.Count - $thinPages.Count)"