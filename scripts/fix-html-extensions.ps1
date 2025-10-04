# Fix HTML Extensions for Vercel cleanUrls
# This script removes .html extensions from links to prevent 404 errors

Write-Host "🔧 Fixing HTML extensions for Vercel cleanUrls compatibility..." -ForegroundColor Green

# Define the files to process
$files = @(
    "index.html",
    "about.html", 
    "blog.html",
    "saved-calculations.html",
    "privacy-policy.html",
    "terms-of-service.html"
)

# Add calculator files
$calculatorFiles = Get-ChildItem -Path "calculators\*.html" | ForEach-Object { "calculators\$($_.Name)" }
$files += $calculatorFiles

# Add category files  
$categoryFiles = Get-ChildItem -Path "categories\*.html" | ForEach-Object { "categories\$($_.Name)" }
$files += $categoryFiles

$totalFixed = 0

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "Processing: $file" -ForegroundColor Yellow
        
        $content = Get-Content $file -Raw
        $originalContent = $content
        
        # Fix common navigation links
        $content = $content -replace 'href="index\.html"', 'href="index"'
        $content = $content -replace 'href="about\.html"', 'href="about"'
        $content = $content -replace 'href="blog\.html"', 'href="blog"'
        $content = $content -replace 'href="saved-calculations\.html"', 'href="saved-calculations"'
        $content = $content -replace 'href="privacy-policy\.html"', 'href="privacy-policy"'
        $content = $content -replace 'href="terms-of-service\.html"', 'href="terms-of-service"'
        
        # Fix relative navigation links
        $content = $content -replace 'href="\.\./index\.html"', 'href="../index"'
        $content = $content -replace 'href="\.\./about\.html"', 'href="../about"'
        $content = $content -replace 'href="\.\./blog\.html"', 'href="../blog"'
        $content = $content -replace 'href="\.\./privacy-policy\.html"', 'href="../privacy-policy"'
        $content = $content -replace 'href="\.\./terms-of-service\.html"', 'href="../terms-of-service"'
        
        # Fix calculator links
        $content = $content -replace 'href="calculators/([^"]+)\.html"', 'href="calculators/$1"'
        $content = $content -replace 'href="\.\./calculators/([^"]+)\.html"', 'href="../calculators/$1"'
        
        # Fix onclick handlers for blog posts
        $content = $content -replace "onclick=`"window\.location\.href='blog/([^']+)\.html'`"", "onclick=`"window.location.href='blog/`$1'`""
        
        if ($content -ne $originalContent) {
            Set-Content -Path $file -Value $content -NoNewline
            $fixCount = ([regex]::Matches($originalContent, '\.html')).Count - ([regex]::Matches($content, '\.html')).Count
            Write-Host "  ✅ Fixed $fixCount .html extensions" -ForegroundColor Green
            $totalFixed += $fixCount
        } else {
            Write-Host "  ℹ️  No changes needed" -ForegroundColor Cyan
        }
    } else {
        Write-Host "  ⚠️  File not found: $file" -ForegroundColor Red
    }
}

Write-Host "`n🎉 Complete! Fixed $totalFixed .html extensions across all files." -ForegroundColor Green
Write-Host "Your website should now work correctly with Vercel's cleanUrls configuration." -ForegroundColor Green