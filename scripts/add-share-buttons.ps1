# CalcuForMe - Add Share/Save/Export Buttons to Calculators
# This script adds social share, save, and export functionality to calculator HTML files

param(
    [string]$CalculatorPath = "",
    [string]$CalculatorName = "",
    [switch]$ApplyToAll
)

function Get-ShareButtonsHTML {
    param([string]$CalcName)
    
    $calcNameSafe = $CalcName -replace ' ', ''
    
    return @"
                    
                    <!-- Share, Save, Export Buttons -->
                    <div class="share-buttons" id="shareButtons" style="display: none;">
                        <button class="share-btn share-btn-save" onclick="save${calcNameSafe}Calculation()" title="Save to browser">
                            <i class="fas fa-save"></i> Save Result
                        </button>
                        <button class="share-btn share-btn-twitter" onclick="shareOnTwitter('I just used the $CalcName on CalcuForMe! Check it out 💯')" title="Share on Twitter">
                            <i class="fab fa-twitter"></i> Tweet
                        </button>
                        <button class="share-btn share-btn-facebook" onclick="shareOnFacebook()" title="Share on Facebook">
                            <i class="fab fa-facebook"></i> Share
                        </button>
                        <button class="share-btn share-btn-whatsapp" onclick="shareOnWhatsApp('Check out this $CalcName!')" title="Share on WhatsApp">
                            <i class="fab fa-whatsapp"></i> WhatsApp
                        </button>
                        <button class="share-btn share-btn-copy" onclick="copyToClipboard(window.location.href)" title="Copy link">
                            <i class="fas fa-link"></i> Copy Link
                        </button>
                        <button class="share-btn share-btn-export" onclick="export${calcNameSafe}Results()" title="Export as text">
                            <i class="fas fa-download"></i> Export
                        </button>
                    </div>
"@
}

function Get-ShareButtonsCSS {
    return @"
    <style>
        /* Share buttons styling */
        .share-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 0.75rem;
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 2px solid #e2e8f0;
        }
        
        .share-btn {
            flex: 1;
            min-width: 120px;
            padding: 0.75rem 1rem;
            border: none;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .share-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        
        .share-btn i {
            font-size: 1.1rem;
        }
        
        .share-btn-save {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .share-btn-twitter {
            background: #1da1f2;
            color: white;
        }
        
        .share-btn-facebook {
            background: #4267B2;
            color: white;
        }
        
        .share-btn-whatsapp {
            background: #25D366;
            color: white;
        }
        
        .share-btn-copy {
            background: #718096;
            color: white;
        }
        
        .share-btn-export {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }
        
        @media (max-width: 768px) {
            .share-buttons {
                flex-direction: column;
            }
            
            .share-btn {
                width: 100%;
            }
        }
    </style>
"@
}

function Add-ShareFeaturesToCalculator {
    param(
        [string]$FilePath,
        [string]$CalculatorName
    )
    
    Write-Host "Processing: $CalculatorName ($FilePath)" -ForegroundColor Cyan
    
    if (-not (Test-Path $FilePath)) {
        Write-Host "  ❌ File not found: $FilePath" -ForegroundColor Red
        return
    }
    
    $content = Get-Content $FilePath -Raw -Encoding UTF8
    
    # Check if already has share buttons
    if ($content -match 'share-buttons') {
        Write-Host "  ⚠️  Share buttons already exist. Skipping." -ForegroundColor Yellow
        return
    }
    
    # Add CSS if not present
    if ($content -notmatch 'share-btn-save') {
        $cssToAdd = Get-ShareButtonsCSS
        $content = $content -replace '(</head>)', "$cssToAdd`n`$1"
        Write-Host "  ✓ Added share button CSS" -ForegroundColor Green
    }
    
    # Add calculator-utils.js script if not present
    if ($content -notmatch 'calculator-utils\.js') {
        $content = $content -replace '(<script src="\.\./js/main\.js"></script>)', "`$1`n    <script src=`"../js/calculator-utils.js`"></script>"
        Write-Host "  ✓ Added calculator-utils.js reference" -ForegroundColor Green
    }
    
    # Add share buttons HTML before closing result container
    $shareButtonsHTML = Get-ShareButtonsHTML -CalcName $CalculatorName
    $content = $content -replace '(</div>\s*</div>\s*<!-- Results -->|</div>\s*</div>\s*<!-- Info Section -->)', "$shareButtonsHTML`n`$1"
    
    # Save the modified content
    $content | Set-Content $FilePath -Encoding UTF8 -NoNewline
    Write-Host "  ✅ Successfully updated $CalculatorName" -ForegroundColor Green
}

# Main execution
if ($ApplyToAll) {
    Write-Host "`n🚀 Applying share features to all calculators...`n" -ForegroundColor Cyan
    
    $calculators = @(
        @{Path="F:\CalcuForMe\calculators\age-calculator.html"; Name="Age Calculator"},
        @{Path="F:\CalcuForMe\calculators\percentage-calculator.html"; Name="Percentage Calculator"},
        @{Path="F:\CalcuForMe\calculators\tip-calculator.html"; Name="Tip Calculator"},
        @{Path="F:\CalcuForMe\calculators\discount-calculator.html"; Name="Discount Calculator"},
        @{Path="F:\CalcuForMe\calculators\gpa-calculator.html"; Name="GPA Calculator"},
        @{Path="F:\CalcuForMe\calculators\loan-calculator.html"; Name="Loan Calculator"},
        @{Path="F:\CalcuForMe\calculators\mortgage-calculator.html"; Name="Mortgage Calculator"},
        @{Path="F:\CalcuForMe\calculators\interest-calculator.html"; Name="Interest Calculator"},
        @{Path="F:\CalcuForMe\calculators\time-calculator.html"; Name="Time Calculator"},
        @{Path="F:\CalcuForMe\calculators\date-calculator.html"; Name="Date Calculator"},
        @{Path="F:\CalcuForMe\calculators\calorie-calculator.html"; Name="Calorie Calculator"},
        @{Path="F:\CalcuForMe\calculators\grade-calculator.html"; Name="Grade Calculator"},
        @{Path="F:\CalcuForMe\calculators\tax-calculator.html"; Name="Tax Calculator"},
        @{Path="F:\CalcuForMe\calculators\salary-calculator.html"; Name="Salary Calculator"},
        @{Path="F:\CalcuForMe\calculators\investment-calculator.html"; Name="Investment Calculator"},
        @{Path="F:\CalcuForMe\calculators\roi-calculator.html"; Name="ROI Calculator"}
    )
    
    foreach ($calc in $calculators) {
        Add-ShareFeaturesToCalculator -FilePath $calc.Path -CalculatorName $calc.Name
        Write-Host ""
    }
    
    Write-Host "✨ Completed! Next step: Add calculator-specific save and export functions to each calculator." -ForegroundColor Green
    
} elseif ($CalculatorPath -and $CalculatorName) {
    Add-ShareFeaturesToCalculator -FilePath $CalculatorPath -CalculatorName $CalculatorName
} else {
    Write-Host @"
Usage:
  Add to single calculator:
    .\add-share-buttons.ps1 -CalculatorPath "path\to\calculator.html" -CalculatorName "Calculator Name"
  
  Add to all calculators:
    .\add-share-buttons.ps1 -ApplyToAll

"@ -ForegroundColor Yellow
}
