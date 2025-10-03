# Fix Footer Links in All Calculator Pages
Write-Host "`n🔧 Adding Proper Footer Links to All Pages`n" -ForegroundColor Cyan

$calculatorFiles = Get-ChildItem "F:\CalcuForMe\calculators" -Filter "*.html"

$oldFooter = @"
                <div class="footer-section">
                    <h4>Quick Links</h4>
                    <ul>
                        <li><a href="../index.html">Home</a></li>
                        <li><a href="../index.html#categories">Categories</a></li>
                    </ul>
                </div>
"@

$newFooter = @"
                <div class="footer-section">
                    <h4>Quick Links</h4>
                    <ul>
                        <li><a href="../index.html">Home</a></li>
                        <li><a href="../index.html#categories">Categories</a></li>
                        <li><a href="../about.html">About Us</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h4>Legal</h4>
                    <ul>
                        <li><a href="../privacy-policy.html">Privacy Policy</a></li>
                        <li><a href="../terms-of-service.html">Terms of Service</a></li>
                    </ul>
                </div>
"@

$count = 0
foreach ($file in $calculatorFiles) {
    Write-Host "Processing: $($file.Name)..." -ForegroundColor Cyan
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    
    if ($content -match [regex]::Escape($oldFooter)) {
        $content = $content -replace [regex]::Escape($oldFooter), $newFooter
        $content | Set-Content $file.FullName -Encoding UTF8 -NoNewline
        Write-Host "  ✅ Updated footer" -ForegroundColor Green
        $count++
    } else {
        Write-Host "  ⏭️  Footer not found or already updated" -ForegroundColor Yellow
    }
}

Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host "✅ Updated $count calculator files" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Gray
