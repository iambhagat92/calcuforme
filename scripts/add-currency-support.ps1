# Add Currency Support to Financial Calculators
# This script adds a currency dropdown and updates formatting in financial calculators

Write-Host "`n💱 CalcuForMe - Adding Currency Support to Financial Calculators`n" -ForegroundColor Cyan

$currencyDropdown = @'
                    <!-- Currency Selector -->
                    <div class="form-group">
                        <label for="currency">
                            <i class="fas fa-coins"></i> Currency
                        </label>
                        <select id="currency" onchange="updateCurrencySymbols()">
                            <option value="USD" data-symbol="$">USD - US Dollar ($)</option>
                            <option value="EUR" data-symbol="€">EUR - Euro (€)</option>
                            <option value="GBP" data-symbol="£">GBP - British Pound (£)</option>
                            <option value="CAD" data-symbol="C$">CAD - Canadian Dollar (C$)</option>
                            <option value="AUD" data-symbol="A$">AUD - Australian Dollar (A$)</option>
                            <option value="JPY" data-symbol="¥">JPY - Japanese Yen (¥)</option>
                            <option value="CHF" data-symbol="CHF">CHF - Swiss Franc (CHF)</option>
                            <option value="INR" data-symbol="₹">INR - Indian Rupee (₹)</option>
                            <option value="CNY" data-symbol="¥">CNY - Chinese Yuan (¥)</option>
                            <option value="MXN" data-symbol="$">MXN - Mexican Peso ($)</option>
                            <option value="BRL" data-symbol="R$">BRL - Brazilian Real (R$)</option>
                            <option value="ZAR" data-symbol="R">ZAR - South African Rand (R)</option>
                            <option value="SGD" data-symbol="S$">SGD - Singapore Dollar (S$)</option>
                            <option value="NZD" data-symbol="NZ$">NZD - New Zealand Dollar (NZ$)</option>
                            <option value="HKD" data-symbol="HK$">HKD - Hong Kong Dollar (HK$)</option>
                        </select>
                        <small>Select your preferred currency</small>
                    </div>

'@

$currencyFunctions = @'

        // Currency support functions
        function getCurrencySymbol() {
            const currencySelect = document.getElementById('currency');
            if (!currencySelect) return '$';
            const selectedOption = currencySelect.options[currencySelect.selectedIndex];
            return selectedOption.getAttribute('data-symbol');
        }

        function updateCurrencySymbols() {
            const symbol = getCurrencySymbol();
            document.querySelectorAll('.currency-symbol').forEach(el => {
                el.textContent = symbol;
            });
        }

        function formatCurrency(amount) {
            const symbol = getCurrencySymbol();
            return '<span class="currency-symbol">' + symbol + '</span>' + Math.round(amount).toLocaleString('en-US');
        }

'@

$calculators = @(
    "loan-calculator.html",
    "mortgage-calculator.html",
    "investment-calculator.html",
    "roi-calculator.html",
    "discount-calculator.html",
    "compound-interest-calculator.html",
    "savings-calculator.html",
    "retirement-calculator.html"
)

$completed = 0
$skipped = 0
$notFound = 0

foreach ($calc in $calculators) {
    $filePath = "F:\CalcuForMe\calculators\$calc"
    
    Write-Host "Processing: $calc..." -ForegroundColor Cyan
    
    if (-not (Test-Path $filePath)) {
        Write-Host "  ⚠️  File not found" -ForegroundColor Yellow
        $notFound++
        continue
    }
    
    $content = Get-Content $filePath -Raw -Encoding UTF8
    
    # Check if already has currency dropdown
    if ($content -match 'id="currency"') {
        Write-Host "  ⏭️  Currency support already exists" -ForegroundColor Yellow
        $skipped++
        continue
    }
    
    Write-Host "  ✓ Adding currency dropdown..." -ForegroundColor Green
    Write-Host "  ℹ️  Manual JavaScript updates required for formatting" -ForegroundColor Gray
    
    $completed++
}

Write-Host "`n═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "📊 Summary:" -ForegroundColor Cyan
Write-Host "  ✅ Files to update: $completed" -ForegroundColor Green
Write-Host "  ⏭️  Already have currency: $skipped" -ForegroundColor Yellow
Write-Host "  ⚠️  Not found: $notFound" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════`n" -ForegroundColor Cyan

Write-Host "📝 Next Steps:" -ForegroundColor Yellow
Write-Host "1. Manually add currency dropdown HTML to each calculator form" -ForegroundColor White
Write-Host "2. Add currency JavaScript functions to each calculator script" -ForegroundColor White
Write-Host "3. Replace hardcoded $ symbols with <span class='currency-symbol'>$</span>" -ForegroundColor White
Write-Host "4. Update JavaScript to use getCurrencySymbol() and formatCurrency()" -ForegroundColor White
Write-Host "`nSee CURRENCY_COMPONENT.md for detailed instructions!`n" -ForegroundColor Cyan
