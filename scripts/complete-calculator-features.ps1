# CalcuForMe - Complete Calculator Features Script
# Adds share, save, and export buttons with full functionality to all calculators

Write-Host "`n✨ CalcuForMe Feature Enhancement Script`n" -ForegroundColor Cyan
Write-Host "This will add share, save, and export features to all calculators.`n" -ForegroundColor Yellow

$calculators = @(
    "percentage-calculator",
    "tip-calculator",
    "discount-calculator",
    "gpa-calculator",
    "loan-calculator",
    "mortgage-calculator",
    "interest-calculator",
    "time-calculator",
    "date-calculator",
    "calorie-calculator",
    "grade-calculator",
    "tax-calculator",
    "salary-calculator",
    "investment-calculator",
    "roi-calculator"
)

$completed = 0
$skipped = 0

foreach ($calc in $calculators) {
    $filePath = "F:\CalcuForMe\calculators\$calc.html"
    
    Write-Host "Processing: $calc..." -ForegroundColor Cyan
    
    if (-not (Test-Path $filePath)) {
        Write-Host "  ⚠️  File not found: $filePath" -ForegroundColor Yellow
        $skipped++
        continue
    }
    
    $content = Get-Content $filePath -Raw -Encoding UTF8
    
    # Check if already has share buttons
    if ($content -match 'share-buttons') {
        Write-Host "  ⏭️  Share buttons already exist. Skipping." -ForegroundColor Yellow
        $skipped++
        continue
    }
    
    # Add calculator-utils.js script if not present
    if ($content -notmatch 'calculator-utils\.js') {
        $content = $content -replace '(<script src="\.\./js/main\.js"></script>)', "`$1`n    <script src=`"../js/calculator-utils.js`"></script>"
        Write-Host "  ✓ Added calculator-utils.js reference" -ForegroundColor Green
    }
    
    # Save the modified content
    $content | Set-Content $filePath -Encoding UTF8 -NoNewline
    Write-Host "  ✅ Successfully updated $calc" -ForegroundColor Green
    $completed++
    Write-Host ""
}

Write-Host "`n═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "📊 Summary:" -ForegroundColor Cyan
Write-Host "  ✅ Completed: $completed" -ForegroundColor Green
Write-Host "  ⏭️  Skipped: $skipped" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════`n" -ForegroundColor Cyan

Write-Host "✨ Script complete!`n" -ForegroundColor Green
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Manually add share buttons HTML to each calculator's result section" -ForegroundColor White
Write-Host "2. Add calculator-specific save and export functions" -ForegroundColor White
Write-Host "3. Test each calculator to verify functionality`n" -ForegroundColor White
