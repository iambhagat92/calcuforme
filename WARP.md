# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

Project overview
- Static site: plain HTML/CSS/JS; no package manager, build step, linter, or test suite configured.
- Deploys as static files (see vercel.json for headers and routing). Suitable for Vercel, Netlify, GitHub Pages.
- Primary entry points:
  - index.html (landing page, global nav, search, quick calculators)
  - calculators/*.html (individual calculators; most include inline logic + shared JS)
  - categories/*.html (category landing pages)
  - js/main.js (UI behavior and search index)
  - js/calculator-utils.js (shared share/save/export/format helpers; exposes window.CalcUtils)
  - css/style.css (global theme, responsive layout)

Common commands (PowerShell on Windows)
- Local preview (pick one):
  - Python (if installed):
    powershell
    python -m http.server 8000
  - Node (if installed):
    powershell
    npx http-server -p 8000
  - Vercel dev (if CLI installed):
    powershell
    vercel dev

- Open in browser:
  http://localhost:8000

- Git (basic):
  powershell
  git status
  git add .
  git commit -m "<message>"
  git push

- Helper scripts in this repo:
  - Generate scaffolding for remaining calculators and category pages:
    powershell
    .\generate-all-calculators.ps1
  - Add shared features (ensures calculators include js/calculator-utils.js; prints status for each page):
    powershell
    .\scripts\complete-calculator-features.ps1
  - Currency support audit for financial calculators (prints files to update, suggests next steps):
    powershell
    .\scripts\add-currency-support.ps1

Build, lint, tests
- Build: none required (static site).
- Lint: not configured.
- Tests: not configured. There is no single-test runner.

Deployment notes
- Vercel:
  - vercel.json enables cleanUrls and security headers; no build/output dir needed.
  - If CLI is available:
    powershell
    npm install -g vercel
    vercel
    vercel --prod
  - See VERCEL_DEPLOYMENT.md for GitHub-based and drag-and-drop flows.
- Netlify/GitHub Pages: See DEPLOYMENT_GUIDE.md for step-by-step instructions and link path considerations.

Big-picture architecture
- Page structure: Each calculator lives in calculators/*.html, typically with its own small inline script. All calculator pages include js/main.js (navigation/search behaviors) and js/calculator-utils.js for cross-cutting functionality (sharing, saving to localStorage, exporting, notifications, simple analytics wrappers).
- Shared JS (js/calculator-utils.js):
  - Sharing: Web Share API + fallbacks (Twitter/Facebook/LinkedIn/WhatsApp, copy link helper).
  - Persistence: saveCalculation/getSavedCalculations/deleteCalculation/clearAllCalculations using localStorage key Calculate For Me_calculations.
  - Export: exportAsText/exportAsJSON/printResults and download helper.
  - Notifications: lightweight toast system injected into the page with CSS animations.
  - Formatting: currency/percent/number helpers and parseNumber.
  - Global API: exposed as window.CalcUtils for use across calculators.
- Global UI (js/main.js):
  - Search index: in-file array of calculators (name/category/url/icon/keywords) powering the search box on index.html.
  - Navigation: mobile menu toggle, click-away behavior, smooth scrolling, minor scroll animations.
  - Theme: dark/light mode via data-theme on <html>, persisted in localStorage, toggle button injected at runtime.
  - Quick calculators on the homepage (basic arithmetic and percentage) with simple animations.
- Styles (css/style.css): CSS variables define theme; responsive grid-based layout; components for navbar, dropdowns, category and calculator cards, forms, and result containers. Dark mode styles use the data-theme attribute.
- Deployment config (vercel.json): cleanUrls: true, trailingSlash: false, and security headers (X-Content-Type-Options, X-Frame-Options, X-XSS-Protection).

Working effectively in this repo
- When adding a new calculator:
  - Start from an existing calculator in calculators/*.html to reuse structure and styles.
  - Include both ../js/main.js and ../js/calculator-utils.js.
  - Use CalcUtils helpers for share buttons, save/export features, notifications, and formatting.
  - If the calculator shows currency, wrap symbols in <span class="currency-symbol"> and (optionally) add a currency selector as demonstrated in calculators/roi-calculator.html; update symbols via updateCurrencySymbols().
- Search index: If you add new calculators and want them discoverable from the homepage search, add entries to the calculators array in js/main.js (name, category, url, icon, keywords).

Important docs in this repo
- README.md: quick start, structure, adding new calculators, tech stack.
- VERCEL_DEPLOYMENT.md: practical deployment options (GitHub → Vercel, direct upload, CLI) and troubleshooting.
- DEPLOYMENT_GUIDE.md: platform-specific deployment steps (GitHub Pages, Netlify, Vercel), custom domains, SEO/performance tips.

Notes
- .github/chatmodes/claude sonnet 4.5.chatmode.md exists but is empty; there are no additional agent-rules files (e.g., CLAUDE.md, Cursor, Copilot) to import.

