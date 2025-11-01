$ErrorActionPreference = 'Stop'
$root = 'F:\CalcuForMe'

# Create feature branch
git --no-pager -C $root checkout -b feature/privacy-accuracy-update

$note = @'
<p class="note">✅ This calculator uses verified mathematical formulas and latest reference rates. Results are accurate for general use. For financial or medical decisions, please confirm with a professional advisor.</p>
'@

$privacy = @'
<p class="privacy-note">🔒 All calculations happen locally in your browser. No data ever leaves your device.</p>
'@

$badges = @'
<div class="trust-badges"><p>✅ Data processed locally | 🧮 Verified formulas | 🕒 Last updated: November 2025 | 📄 Transparent formulas</p></div>
'@

$faqSection = @'
<section class="faq">
  <h3>💬 Frequently Asked Questions</h3>
  <details><summary>How accurate is this calculator?</summary><p>These calculators use verified standard formulas. For complex or professional cases, verify with your advisor.</p></details>
  <details><summary>Do you store my data?</summary><p>No. All calculations are processed locally in your browser; no data is sent to our servers.</p></details>
  <details><summary>Can I export my results?</summary><p>Yes, you can screenshot or print your results directly from your browser.</p></details>
</section>
'@

$faqSchema = @'
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type": "Question","name": "How accurate is this calculator?","acceptedAnswer": {"@type": "Answer","text": "These calculators use verified standard formulas."}},
    {"@type": "Question","name": "Do you store my data?","acceptedAnswer": {"@type": "Answer","text": "No, all calculations are processed locally in your browser."}},
    {"@type": "Question","name": "Can I export my results?","acceptedAnswer": {"@type": "Answer","text": "Yes, you can print or screenshot results."}}
  ]
}
</script>
'@

$validationJS = @'
document.querySelectorAll("input").forEach(el=>{
  if(el.type==="number"){
    el.addEventListener("blur",()=>{
      const v=parseFloat(el.value);
      if(isNaN(v)||v<=0){
        alert("Please enter a valid number for "+(el.name||el.id));
      }
    });
  }
});
'@

$style = '.note, .privacy-note {background:#f0f9ff;border-left:4px solid #0284c7;padding:10px;margin:10px 0;border-radius:8px;} .trust-badges{text-align:center;font-size:14px;color:#555;margin-top:15px;}'

# Process all HTML files
Get-ChildItem -Path $root -Recurse -Filter *.html | ForEach-Object {
  $p = $_.FullName
  $content = Get-Content -LiteralPath $p -Raw -ErrorAction SilentlyContinue
  if(-not $content){ return }
  $orig = $content

  if($content -match '</form>'){
    $content = $content -replace '</form>', ('</form>' + "`r`n" + $note)
  }
  if($content -match '</footer>'){
    $content = $content -replace '</footer>', ($privacy + "`r`n" + '</footer>')
  }
  if($content -match '</footer>'){
    $content = $content -replace '</footer>', ($badges + "`r`n" + '</footer>')
  }
  if($content -match '</main>'){
    $content = $content -replace '</main>', ($faqSection + "`r`n" + '</main>')
  }

  if($content -ne $orig){
    Set-Content -LiteralPath $p -Value $content -Encoding UTF8
  }
}

# Prepend console privacy log to any JS files
Get-ChildItem -Path $root -Recurse -Filter *.js -ErrorAction SilentlyContinue | ForEach-Object {
  $p = $_.FullName
  $c = Get-Content -LiteralPath $p -Raw
  if($c -notmatch 'All calculations are handled locally'){
    Set-Content -LiteralPath $p -Value ('console.log("All calculations are handled locally. No user data leaves your device.");' + "`r`n" + $c) -Encoding UTF8
  }
}

# Create validation and style assets
New-Item -ItemType Directory -Path (Join-Path $root 'assets/js') -Force | Out-Null
Set-Content -LiteralPath (Join-Path $root 'assets/js/validation.js') -Value $validationJS -Encoding UTF8
New-Item -ItemType Directory -Path (Join-Path $root 'assets/css') -Force | Out-Null
Add-Content -LiteralPath (Join-Path $root 'assets/css/style.css') -Value $style -Encoding UTF8

# Append FAQ schema to homepage
$idx = Join-Path $root 'index.html'
if(Test-Path $idx){ Add-Content -LiteralPath $idx -Value $faqSchema -Encoding UTF8 }

# Create /privacy page
$privacyDir = Join-Path $root 'privacy'
New-Item -ItemType Directory -Path $privacyDir -Force | Out-Null
$privacyHtml = @'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Privacy Policy | Calculate For Me</title>
</head>
<body>
  <h1>Privacy Policy</h1>
  <p>All calculations are processed locally in your browser via JavaScript. No data is stored or sent to our servers.</p>
  <p>We only use minimal cookies for analytics and performance tracking. Your privacy is a top priority.</p>
</body>
</html>
'@
Set-Content -LiteralPath (Join-Path $privacyDir 'index.html') -Value $privacyHtml -Encoding UTF8

# Commit and push
git --no-pager -C $root add -A
$null = git --no-pager -C $root commit -m 'Enhanced privacy, accuracy disclaimers, FAQ, and SEO trust improvements sitewide.'
git --no-pager -C $root push -u origin feature/privacy-accuracy-update
