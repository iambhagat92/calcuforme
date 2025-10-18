# Google Search Console Setup for calculateforme.xyz

## Step 1: Add New Property in Google Search Console

1. Go to [Google Search Console](https://search.google.com/search-console)
2. Click the property selector dropdown (top left)
3. Click "+ Add property"

## Step 2: Choose Property Type

You have two options:

### Option A: Domain Property (Recommended)
- Enter: `calculateforme.xyz`
- This will verify all subdomains and protocols (http, https, www, non-www)
- Requires DNS verification

### Option B: URL Prefix
- Enter: `https://calculateforme.xyz`
- Only verifies this specific URL version
- Can use HTML meta tag verification

## Step 3: Verification Methods

### Method 1: HTML Meta Tag (Already Implemented)
Your site already has the verification meta tag:
```html
<meta name="google-site-verification" content="l-g4wLIKrROeA-nAcZkmIL8xWnkfLB_3LQeGM6juwAo" />
```

**Note**: This tag might work for the new domain if you're using the same Google account. Try clicking "Verify" first.

### Method 2: DNS Verification (For Domain Property)
1. Google will provide a TXT record
2. Add it to your domain's DNS settings:
   - Log in to your domain registrar (where you bought calculateforme.xyz)
   - Go to DNS settings
   - Add a new TXT record:
     - Name/Host: @ (or leave blank)
     - Value: The verification string from Google
     - TTL: 3600 (or default)
3. Wait 5-10 minutes for DNS propagation
4. Click "Verify" in Google Search Console

### Method 3: New HTML Tag (If needed)
If the existing tag doesn't work:
1. Google will provide a new meta tag
2. Replace the existing tag in your index.html
3. The tag should be in the <head> section

## Step 4: Submit Your Sitemap

Once verified:
1. Go to "Sitemaps" in the left sidebar
2. Enter: `sitemap.xml`
3. Click "Submit"
4. Your full sitemap URL: `https://calculateforme.xyz/sitemap.xml`

## Step 5: Request Indexing

For important pages:
1. Go to "URL Inspection" tool
2. Enter your homepage: `https://calculateforme.xyz`
3. Click "Request Indexing"
4. Repeat for key calculator pages

## Step 6: Set Up Domain Preferences

### International Targeting
- Go to Settings → International Targeting
- Leave "Country" as "Unlisted" for global reach

### Preferred Domain
- Google now automatically handles www vs non-www
- Ensure both redirect to your preferred version

## Step 7: Monitor Performance

After a few days, check:
- **Performance Report**: Search queries, clicks, impressions
- **Coverage Report**: Indexed pages and errors
- **Mobile Usability**: Mobile-friendly issues
- **Core Web Vitals**: Page experience metrics

## Important Notes

### DNS Settings for Vercel
Make sure your DNS is properly configured:
1. A record pointing to Vercel's IP
2. CNAME for www subdomain (if using)
3. Vercel automatically handles SSL certificates

### Old Domain Redirect
Consider setting up 301 redirects from Calculate For Me.vercel.app to calculateforme.xyz:
- Helps preserve SEO value
- Transfers link equity
- Updates search results faster

### Update Other Properties
Don't forget to update:
- Google Analytics property URL
- Google My Business (if applicable)
- Bing Webmaster Tools
- Social media profiles
- Any backlinks you control

## Verification Checklist

- [ ] Property added to Google Search Console
- [ ] Verification completed
- [ ] Sitemap submitted
- [ ] Homepage indexed
- [ ] Key pages requested for indexing
- [ ] Old property (Calculate For Me.vercel.app) still accessible for data
- [ ] 301 redirects set up (if possible)
- [ ] Google Analytics updated
- [ ] Monitor for any crawl errors

## Timeline

- **Verification**: Immediate after DNS/HTML verification
- **Sitemap Processing**: 1-2 days
- **Initial Indexing**: 2-7 days
- **Full Indexing**: 2-4 weeks
- **Rankings Transfer**: 1-3 months

## Support Resources

- [Google Search Console Help](https://support.google.com/webmasters)
- [Moving site with URL changes](https://developers.google.com/search/docs/advanced/crawling/site-move-with-url-changes)
- [Sitemap Guidelines](https://developers.google.com/search/docs/advanced/sitemaps/overview)

## Contact Google Support

If you encounter issues:
- Use the feedback button in Search Console
- Post in [Google Search Central Community](https://support.google.com/webmasters/community)

---

Last Updated: January 13, 2025
Domain: calculateforme.xyz
Previous Domain: Calculate For Me.vercel.app
