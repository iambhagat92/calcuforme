# Currency Component - Reusable for All Financial Calculators

## HTML Currency Dropdown (Add at top of form)

```html
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
```

## JavaScript Functions (Add to script section)

```javascript
// Get current currency symbol
function getCurrencySymbol() {
    const currencySelect = document.getElementById('currency');
    const selectedOption = currencySelect.options[currencySelect.selectedIndex];
    return selectedOption.getAttribute('data-symbol');
}

// Update all currency symbols in the page
function updateCurrencySymbols() {
    const symbol = getCurrencySymbol();
    document.querySelectorAll('.currency-symbol').forEach(el => {
        el.textContent = symbol;
    });
}

// Format currency with symbol
function formatCurrency(amount) {
    const symbol = getCurrencySymbol();
    return symbol + Math.round(amount).toLocaleString('en-US');
}
```

## Usage in Display Elements

Replace hardcoded $ with:
```html
<span class="currency-symbol">$</span>
```

When updating values via JavaScript:
```javascript
// Instead of:
element.textContent = '$' + value.toFixed(2);

// Use:
element.innerHTML = '<span class="currency-symbol">' + getCurrencySymbol() + '</span>' + Math.round(value).toLocaleString();

// Or use the helper:
element.innerHTML = formatCurrency(value);
```

## Calculators to Update
1. ✅ Freelancer Tax Calculator (DONE)
2. ⏳ Loan Calculator
3. ⏳ Mortgage Calculator
4. ⏳ Investment Calculator
5. ⏳ ROI Calculator
6. ⏳ Discount Calculator
7. ⏳ Salary Calculator (if exists)
8. ⏳ Compound Interest Calculator
9. ⏳ Savings Calculator
10. ⏳ Retirement Calculator
