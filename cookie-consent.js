// Cookie Consent Banner
(function() {
    'use strict';
    
    // Check if user has already consented
    if (localStorage.getItem('cookieConsent') === 'accepted') {
        return;
    }
    
    // Create cookie consent banner
    const banner = document.createElement('div');
    banner.id = 'cookieConsentBanner';
    banner.innerHTML = `
        <div style="position: fixed; bottom: 0; left: 0; right: 0; background: #1f2937; color: white; padding: 1.5rem; box-shadow: 0 -4px 12px rgba(0,0,0,0.3); z-index: 9999; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;">
            <div style="max-width: 1200px; margin: 0 auto; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 1rem;">
                <div style="flex: 1; min-width: 300px;">
                    <p style="margin: 0; font-size: 0.95rem; line-height: 1.6;">
                        <strong>🍪 We use cookies</strong><br>
                        We use cookies and similar technologies to improve your experience on our website. 
                        This includes cookies from Google AdSense for personalized advertising. 
                        By clicking "Accept", you consent to the use of these cookies. 
                        <a href="/privacy-policy.html" style="color: #60a5fa; text-decoration: underline;">Learn more in our Privacy Policy</a>
                    </p>
                </div>
                <div style="display: flex; gap: 1rem; align-items: center;">
                    <button id="cookieAccept" style="background: #10b981; color: white; border: none; padding: 0.75rem 1.5rem; border-radius: 8px; font-size: 1rem; font-weight: 600; cursor: pointer; transition: all 0.2s;">
                        Accept All
                    </button>
                    <button id="cookieDecline" style="background: transparent; color: white; border: 2px solid #6b7280; padding: 0.75rem 1.5rem; border-radius: 8px; font-size: 1rem; font-weight: 600; cursor: pointer; transition: all 0.2s;">
                        Decline
                    </button>
                    <a href="https://www.google.com/settings/ads" target="_blank" rel="noopener noreferrer" style="color: #60a5fa; font-size: 0.9rem; text-decoration: underline; white-space: nowrap;">
                        Ad Settings
                    </a>
                </div>
            </div>
        </div>
    `;
    
    // Append to body
    document.body.appendChild(banner);
    
    // Add hover effects
    const acceptBtn = document.getElementById('cookieAccept');
    const declineBtn = document.getElementById('cookieDecline');
    
    acceptBtn.addEventListener('mouseenter', function() {
        this.style.background = '#059669';
        this.style.transform = 'scale(1.05)';
    });
    
    acceptBtn.addEventListener('mouseleave', function() {
        this.style.background = '#10b981';
        this.style.transform = 'scale(1)';
    });
    
    declineBtn.addEventListener('mouseenter', function() {
        this.style.background = '#374151';
    });
    
    declineBtn.addEventListener('mouseleave', function() {
        this.style.background = 'transparent';
    });
    
    // Handle accept
    acceptBtn.addEventListener('click', function() {
        localStorage.setItem('cookieConsent', 'accepted');
        banner.style.animation = 'slideDown 0.3s ease-out';
        setTimeout(function() {
            banner.remove();
        }, 300);
        
        // Enable Google Analytics and AdSense tracking
        if (typeof gtag !== 'undefined') {
            gtag('consent', 'update', {
                'ad_storage': 'granted',
                'analytics_storage': 'granted'
            });
        }
    });
    
    // Handle decline
    declineBtn.addEventListener('click', function() {
        localStorage.setItem('cookieConsent', 'declined');
        banner.style.animation = 'slideDown 0.3s ease-out';
        setTimeout(function() {
            banner.remove();
        }, 300);
        
        // Disable Google Analytics and AdSense tracking
        if (typeof gtag !== 'undefined') {
            gtag('consent', 'update', {
                'ad_storage': 'denied',
                'analytics_storage': 'denied'
            });
        }
    });
    
    // Add animation styles
    const style = document.createElement('style');
    style.textContent = `
        @keyframes slideDown {
            from { transform: translateY(0); opacity: 1; }
            to { transform: translateY(100%); opacity: 0; }
        }
    `;
    document.head.appendChild(style);
})();
