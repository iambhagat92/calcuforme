# CalcuForMe - Complete Feature Addition Script
# Adds share, save, and export buttons to all calculators

Write-Host "`n✨ CalcuForMe - Adding Share/Save/Export Features`n" -ForegroundColor Cyan

$calculators = @(
    "loan-calculator",
    "discount-calculator",
    "roi-calculator",
    "gpa-calculator",
    "paint-calculator",
    "mortgage-calculator",
    "calorie-calculator",
    "date-calculator",
    "currency-converter",
    "compound-interest-calculator",
    "investment-calculator",
    "retirement-calculator",
    "savings-calculator",
    "freelancer-tax-calculator"
)

$completed = 0
$skipped = 0

foreach ($calc in $calculators) {
    $filePath = "F:\CalcuForMe\calculators\$calc.html"
    
    Write-Host "Processing: $calc..." -ForegroundColor Cyan
    
    if (-not (Test-Path $filePath)) {
        Write-Host "  ⚠️  File not found" -ForegroundColor Yellow
        $skipped++
        continue
    }
    
    $content = Get-Content $filePath -Raw -Encoding UTF8
    
    # Check if already has calculator-utils.js
    if ($content -notmatch 'calculator-utils\.js') {
        # Add calculator-utils.js script reference
        $content = $content -replace '(<script src="\.\./js/main\.js"></script>)', "`$1`n    <script src=`"../js/calculator-utils.js`"></script>"
        Write-Host "  ✓ Added calculator-utils.js reference" -ForegroundColor Green
    } else {
        Write-Host "  ⏭️  Features already added" -ForegroundColor Yellow
        $skipped++
        continue
    }
    
    # Save the modified content
    $content | Set-Content $filePath -Encoding UTF8 -NoNewline
    Write-Host "  ✅ Successfully updated" -ForegroundColor Green
    $completed++
}

Write-Host "`n═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "📊 Summary:" -ForegroundColor Cyan
Write-Host "  ✅ Completed: $completed" -ForegroundColor Green
Write-Host "  ⏭️  Skipped: $skipped" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════`n" -ForegroundColor Cyan
