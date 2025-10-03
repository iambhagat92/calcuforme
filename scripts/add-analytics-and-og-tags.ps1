# CalcuForMe - Add Analytics and Open Graph Meta Tags
# Adds GA4 placeholder and Open Graph tags to all HTML files

Write-Host "`n🎯 Adding Google Analytics & Open Graph Meta Tags`n" -ForegroundColor Cyan

# Google Analytics placeholder code
$gaCode = @"

    <!-- Google Analytics (Add your GA4 Measurement ID) -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
    <script>
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());
        gtag('config', 'G-XXXXXXXXXX');
    </script>
"@

# Open Graph meta tags template
$ogTags = @"

    <!-- Open Graph Meta Tags -->
    <meta property="og:site_name" content="CalcuForMe">
    <meta property="og:type" content="website">
    <meta property="og:image" content="https://calcuforme.com/favicon.svg">
    <meta property="og:image:width" content="1200">
    <meta property="og:image:height" content="630">
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:site" content="@CalcuForMe">
"@

# Get all HTML files
$files = Get-ChildItem "F:\CalcuForMe" -Filter "*.html" -Recurse

$completed = 0
$skipped = 0

foreach ($file in $files) {
    Write-Host "Processing: $($file.Name)..." -ForegroundColor Cyan
    
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    
    # Check if already has Google Analytics
    if ($content -match 'googletagmanager\.com') {
        Write-Host "  ⏭️  Already has analytics" -ForegroundColor Yellow
        $skipped++
        continue
    }
    
    # Add Google Analytics before closing </head>
    $content = $content -replace '(</head>)', "$gaCode`n`$1"
    
    # Add Open Graph tags after existing meta tags (before title or after viewport)
    if ($content -match '<meta name="description"[^>]*>') {
        $content = $content -replace '(<meta name="description"[^>]*>)', "`$1$ogTags"
    } elseif ($content -match '<meta name="viewport"[^>]*>') {
        $content = $content -replace '(<meta name="viewport"[^>]*>)', "`$1$ogTags"
    }
    
    # Save the modified content
    $content | Set-Content $file.FullName -Encoding UTF8 -NoNewline
    Write-Host "  ✅ Added analytics and OG tags" -ForegroundColor Green
    $completed++
}

Write-Host "`n═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "📊 Summary:" -ForegroundColor Cyan
Write-Host "  ✅ Completed: $completed files" -ForegroundColor Green
Write-Host "  ⏭️  Skipped: $skipped files" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════`n" -ForegroundColor Cyan
Write-Host "⚠️  Remember to replace G-XXXXXXXXXX with your actual GA4 Measurement ID!" -ForegroundColor Yellow
