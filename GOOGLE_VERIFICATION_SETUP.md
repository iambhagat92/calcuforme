# Google Search Console Verification Setup

## Quick Setup (5 Minutes)

### Step 1: Get Your Verification Code
1. Visit: https://search.google.com/search-console
2. Click "Add Property"
3. Enter: `https://calculateforme.xyz`
4. Select "HTML tag" method
5. Copy the code like: `abc123xyz456...`

### Step 2: Replace Verification Code

**File:** `index.html` (Line 26)

**Current:**
```html
<meta name="google-site-verification" content="YOUR_GOOGLE_VERIFICATION_CODE_HERE" />
```

**Replace with your code:**
```html
<meta name="google-site-verification" content="YOUR_ACTUAL_CODE_FROM_GOOGLE" />
```

### Step 3: Push to Git
```bash
git add index.html
git commit -m "Add Google verification code"
git push
```

### Step 4: Verify in Google Search Console
1. Wait 2-3 minutes for Vercel deployment
2. Go back to Google Search Console
3. Click "Verify" button
4. Done! ✅

---

## After Verification

### Submit Sitemap
1. Go to "Sitemaps" section
2. Enter: `sitemap.xml`
3. Click "Submit"

### Request Indexing
1. Go to "URL Inspection"
2. Enter your homepage URL
3. Click "Request Indexing"

---

## Verification Code Location
**Line 26 in index.html:**
```html
<meta name="google-site-verification" content="REPLACE_THIS_WITH_YOUR_CODE" />
```

The code is already in place, just need to replace with actual code from Google!

---

## Alternative: DNS Verification (If HTML tag doesn't work)

If you have access to your domain's DNS settings (like Vercel DNS), you can use TXT record:

1. Get TXT record from Google
2. Add to Vercel DNS settings
3. Verify

---

## Need Help?
Email: bhagatpaaji@gmail.com

