# Add Favicon to All HTML Files
# This script adds favicon links to all HTML files in the project

Write-Host "Adding favicon to all HTML files..." -ForegroundColor Cyan

# Get all HTML files
$htmlFiles = Get-ChildItem -Path "F:\CalcuForMe" -Filter "*.html" -Recurse | Where-Object { $_.Name -ne "SEO_TAGS_TEMPLATE.html" }

$faviconLinks = @'
    <link rel="icon" type="image/svg+xml" href="../favicon.svg">
    <link rel="apple-touch-icon" sizes="180x180" href="../favicon.svg">
'@

$faviconLinksRoot = @'
    <link rel="icon" type="image/svg+xml" href="favicon.svg">
    <link rel="apple-touch-icon" sizes="180x180" href="favicon.svg">
'@

$count = 0

foreach ($file in $htmlFiles) {
    try {
        $content = Get-Content $file.FullName -Raw
        
        # Check if favicon is already added
        if ($content -match 'favicon\.svg') {
            Write-Host "  ✓ Favicon already exists in: $($file.Name)" -ForegroundColor Yellow
            continue
        }
        
        # Determine if it's in root or subdirectory
        $isRoot = $file.DirectoryName -eq "F:\CalcuForMe"
        
        # Find the </head> tag and add favicon before it
        if ($content -match '</head>') {
            if ($isRoot) {
                $content = $content -replace '</head>', "$faviconLinksRoot`r`n    </head>"
            } else {
                $content = $content -replace '</head>', "$faviconLinks`r`n    </head>"
            }
            
            # Write back to file
            $content | Set-Content $file.FullName -NoNewline
            $count++
            Write-Host "  ✓ Added favicon to: $($file.Name)" -ForegroundColor Green
        } else {
            Write-Host "  ✗ No </head> tag found in: $($file.Name)" -ForegroundColor Red
        }
    } catch {
        Write-Host "  ✗ Error processing: $($file.Name) - $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n✓ Favicon added to $count HTML files!" -ForegroundColor Green
Write-Host "Files processed: $($htmlFiles.Count)" -ForegroundColor Cyan
