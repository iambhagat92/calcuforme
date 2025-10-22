# Optimize Title Tags Script
# This script shortens title tags to be 70 characters or less

Write-Host "🔧 Optimizing long title tags across HTML files..." -ForegroundColor Cyan

$titleOptimizations = @{
    "age-calculator-life-planning-guide.html" = "Age Calculator & Life Planning Guide | Calculate For Me"
    "bmi-calculator-ideal-weight-guide.html" = "BMI Calculator - Find Your Ideal Weight | Calculate For Me"
    "calorie-calculator-weight-loss-guide.html" = "Calorie Calculator for Weight Loss | Calculate For Me"
    "compound-interest-excel-guides.html" = "Compound Interest Excel Guide & Formulas | Calculate For Me"
    "compound-interest-formula-excel-with-monthly-contributions.html" = "Excel Compound Interest with Monthly Contributions | CalcuForMe"
    "email-newsletter-emi-tips.html" = "7 Ways to Reduce Home Loan EMI | Calculate For Me Newsletter"
    "epfo-new-rules-2025-epf-eps-withdrawal-guidelines.html" = "EPFO Rules 2025: EPF & EPS Withdrawal Guide | Calculate For Me"
    "home-loan-emi-calculation-guide.html" = "Home Loan EMI Calculator & Guide | Calculate For Me"
    "how-to-calculate-compound-interest-in-excel-for-days.html" = "Compound Interest in Excel for Days | Calculate For Me"
    "investment-calculator-complete-guide.html" = "Investment Calculator: SIP, Lump Sum & CAGR | Calculate For Me"
    "michigan-mortgage-calculator-home-buying-guide-2025.html" = "Michigan Mortgage Calculator 2025 | Calculate For Me"
    "monthly-compound-interest-calculator-india.html" = "Monthly Compound Interest Calculator India | Calculate For Me"
    "personal-loan-vs-credit-card-emi.html" = "Personal Loan vs Credit Card EMI Comparison | Calculate For Me"
    "reduce-home-loan-emi-tips.html" = "7 Tips to Reduce Home Loan EMI | Calculate For Me"
    "retirement-planning-guide.html" = "Retirement Planning Guide: Build ₹5 Cr Corpus | Calculate For Me"
    "salary-calculator-income-planning-guide.html" = "Salary Calculator & Income Planning | Calculate For Me"
    "scientific-calculator-functions-guide.html" = "Scientific Calculator Functions Guide | Calculate For Me"
    "sip-retirement-planning-guide.html" = "SIP Retirement Planning Guide | Calculate For Me"
    "quarterly-tax-calculator-freelancers-guide.html" = "Quarterly Tax Calculator for Freelancers | Calculate For Me"
    "tax-planning-guide-2025.html" = "Tax Planning Guide 2025 India | Calculate For Me"
    "about.html" = "About Us - Free Online Calculator Suite | Calculate For Me"
    "contact.html" = "Contact Us - Calculator Support | Calculate For Me"
    "privacy-policy.html" = "Privacy Policy - Calculator Privacy | Calculate For Me"
    "terms-of-service.html" = "Terms of Service - Calculator Terms | Calculate For Me"
    "emi-calculator.html" = "EMI Calculator - Home, Car, Personal Loan | Calculate For Me"
    "hra-calculator.html" = "HRA Calculator India - Tax Exemption | Calculate For Me"
    "investment-calculator.html" = "Investment Calculator - SIP & Lump Sum | Calculate For Me"
    "ppf-calculator.html" = "PPF Calculator India - Returns & Maturity | Calculate For Me"
    "currency-converter.html" = "Currency Converter - Live Exchange Rates | Calculate For Me"
    "income-tax-calculator-india.html" = "Income Tax Calculator India 2025 | Calculate For Me"
    "temperature-converter.html" = "Temperature Converter - C, F, K | Calculate For Me"
    "gratuity-calculator-india.html" = "Gratuity Calculator India - Payment Rules | Calculate For Me"
    "online-clock.html" = "Online Clock - Current Time & Timezones | Calculate For Me"
    "body-fat-percentage-calculator.html" = "Body Fat Percentage Calculator | Calculate For Me"
    "sip-calculator.html" = "SIP Calculator India - Returns & Growth | Calculate For Me"
    "epf-calculator.html" = "EPF Calculator India - Provident Fund | Calculate For Me"
    "detroit-property-tax-calculator.html" = "Detroit Property Tax Calculator 2025 | Calculate For Me"
    "self-employment-tax-calculator.html" = "Self Employment Tax Calculator 2025 | Calculate For Me"
    "countdown-timer.html" = "Countdown Timer Online - Days, Hours | Calculate For Me"
    "grade-calculator.html" = "Grade Calculator - GPA & Percentage | Calculate For Me"
    "gst-calculator-india.html" = "GST Calculator India - Tax Calculator | Calculate For Me"
    "michigan-income-tax-calculator.html" = "Michigan Income Tax Calculator 2025 | Calculate For Me"
    "time-calculator.html" = "Time Calculator - Hours, Minutes | Calculate For Me"
    "time-converter.html" = "Time Converter - Timezone & Format | Calculate For Me"
    "pf-calculator.html" = "PF Calculator India - Provident Fund | Calculate For Me"
    "scientific-calculator.html" = "Scientific Calculator Online | Calculate For Me"
    "fd-calculator.html" = "FD Calculator India - Fixed Deposit | Calculate For Me"
    "ecommerce-profit-calculator.html" = "eCommerce Profit Calculator | Calculate For Me"
    "compound-interest-calculator-india.html" = "Compound Interest Calculator India | Calculate For Me"
    "discount-calculator.html" = "Discount Calculator - Sale Price | Calculate For Me"
    "weight-calculator.html" = "Weight Calculator - Ideal Body Weight | Calculate For Me"
    "tax-calculator.html" = "Tax Calculator India 2025 | Calculate For Me"
    "savings-calculator.html" = "Savings Calculator - Growth & Returns | Calculate For Me"
    "ring-size-converter.html" = "Ring Size Converter - US, UK, EU | Calculate For Me"
    "salary-calculator.html" = "Salary Calculator India - Take Home Pay | Calculate For Me"
    "quarterly-tax-calculator.html" = "Quarterly Tax Calculator 2025 | Calculate For Me"
    "interest-calculator.html" = "Interest Calculator - Simple & Compound | Calculate For Me"
    "retirement-calculator.html" = "Retirement Calculator - Corpus & SIP | Calculate For Me"
}

$filesFixed = 0
$totalOptimizations = 0

foreach ($fileName in $titleOptimizations.Keys) {
    $filePath = Get-ChildItem -Path "F:\CalcuForMe" -Name $fileName -Recurse | Select-Object -First 1
    if ($filePath) {
        $fullPath = Join-Path "F:\CalcuForMe" $filePath
        $content = Get-Content $fullPath -Raw
        $newTitle = $titleOptimizations[$fileName]
        
        Write-Host "`nProcessing: $fileName" -ForegroundColor Yellow
        Write-Host "  New title: $newTitle ($($newTitle.Length) chars)" -ForegroundColor Green
        
        # Replace the title tag
        $updatedContent = $content -replace '<title[^>]*>[^<]*</title>', "<title>$newTitle</title>"
        
        if ($updatedContent -ne $content) {
            Set-Content -Path $fullPath -Value $updatedContent -Encoding UTF8
            $filesFixed++
            $totalOptimizations++
            Write-Host "  ✓ Title optimized!" -ForegroundColor Blue
        } else {
            Write-Host "  ⚠ No changes made" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  ❌ File not found: $fileName" -ForegroundColor Red
    }
}

Write-Host "`n🎉 Title optimization complete!" -ForegroundColor Green
Write-Host "Files processed: $filesFixed" -ForegroundColor White
Write-Host "Total optimizations: $totalOptimizations" -ForegroundColor White

# Verify the results
Write-Host "`n🔍 Verification check..." -ForegroundColor Cyan
$longTitles = 0

Get-ChildItem -Path "F:\CalcuForMe" -Include "*.html" -Recurse | Where-Object {$_.FullName -notmatch "backups"} | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match '<title[^>]*>([^<]*)</title>') {
        $title = $matches[1]
        if ($title.Length -gt 70) {
            $longTitles++
            Write-Host "⚠️  $($_.Name): $($title.Length) chars - $title" -ForegroundColor Red
        }
    }
}

if ($longTitles -eq 0) {
    Write-Host "✅ All title tags are now 70 characters or less!" -ForegroundColor Green
} else {
    Write-Host "⚠️  $longTitles files still have long titles" -ForegroundColor Yellow
}

Write-Host "`nOptimized titles follow SEO best practices:" -ForegroundColor Cyan
Write-Host "- 70 characters or less" -ForegroundColor Gray
Write-Host "- Include primary keywords" -ForegroundColor Gray
Write-Host "- Maintain brand consistency" -ForegroundColor Gray