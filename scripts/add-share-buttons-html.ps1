# Add Share Buttons HTML to All Calculators
Write-Host "`n🎨 Adding Share Buttons to All Calculators`n" -ForegroundColor Cyan

$shareButtonsHTML = @"
                    <!-- Share Buttons -->
                    <div class="share-buttons" style="display: flex; margin-top: 1.5rem; padding-top: 1.5rem; border-top: 1px solid #e2e8f0;">
                        <button onclick="shareOnTwitter('Check out this calculator result on CalcuForMe!')" class="share-btn share-btn-twitter">
                            <i class="fab fa-twitter"></i> Tweet
                        </button>
                        <button onclick="shareOnFacebook()" class="share-btn share-btn-facebook">
                            <i class="fab fa-facebook-f"></i> Share
                        </button>
                        <button onclick="shareOnWhatsApp('Check out CalcuForMe calculators!')" class="share-btn share-btn-whatsapp">
                            <i class="fab fa-whatsapp"></i> WhatsApp
                        </button>
                        <button onclick="copyToClipboard(window.location.href)" class="share-btn share-btn-copy">
                            <i class="fas fa-link"></i> Copy Link
                        </button>
                    </div>
"@

$calculators = @(
    "discount-calculator",
    "roi-calculator",
    "gpa-calculator",
    "paint-calculator",
    "mortgage-calculator",
    "calorie-calculator",
    "date-calculator",
    "compound-interest-calculator",
    "investment-calculator",
    "retirement-calculator",
    "savings-calculator",
    "currency-converter",
    "freelancer-tax-calculator"
)

$count = 0
foreach ($calc in $calculators) {
    $file = "F:\CalcuForMe\calculators\$calc.html"
    
    if (!(Test-Path $file)) {
        Write-Host "  ⚠️  $calc.html not found" -ForegroundColor Yellow
        continue
    }
    
    Write-Host "Processing: $calc..." -ForegroundColor Cyan
    $content = Get-Content $file -Raw -Encoding UTF8
    
    # Check if share buttons already exist
    if ($content -match 'share-buttons') {
        Write-Host "  ⏭️  Share buttons already exist" -ForegroundColor Yellow
        continue
    }
    
    # Add share buttons before closing result container div
    # Look for common patterns
    if ($content -match '</div>\s*</div>\s*<div style="margin-top: 3rem') {
        $content = $content -replace '(</div>\s*</div>)\s*(<div style="margin-top: 3rem)', "`$1$shareButtonsHTML`n                `$2"
        $content | Set-Content $file -Encoding UTF8 -NoNewline
        Write-Host "  ✅ Added share buttons" -ForegroundColor Green
        $count++
    } else {
        Write-Host "  ⚠️  Couldn't find insertion point" -ForegroundColor Yellow
    }
}

Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host "✅ Updated $count calculators" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Gray
