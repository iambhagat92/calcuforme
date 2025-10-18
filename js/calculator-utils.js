/**
 * Calculate For Me - Calculator Utilities
 * Reusable functions for save, share, and export features
 */

// ==================== SHARE FUNCTIONS ====================

/**
 * Share calculator results using Web Share API or fallback
 */
function shareCalculator(title = 'Check out this calculator!', text = 'I just used Calculate For Me - great free calculator!') {
    const shareData = {
        title: title,
        text: text,
        url: window.location.href
    };
    
    if (navigator.share) {
        navigator.share(shareData)
            .then(() => console.log('Successfully shared'))
            .catch((error) => console.log('Error sharing:', error));
    } else {
        // Fallback: copy link to clipboard
        copyToClipboard(window.location.href);
        showNotification('Link copied to clipboard!', 'success');
    }
}

/**
 * Share on Twitter
 */
function shareOnTwitter(text = 'Check out this awesome calculator on Calculate For Me!') {
    const url = window.location.href;
    const twitterUrl = `https://twitter.com/intent/tweet?text=${encodeURIComponent(text)}&url=${encodeURIComponent(url)}`;
    window.open(twitterUrl, '_blank', 'width=600,height=400');
}

/**
 * Share on Facebook
 */
function shareOnFacebook() {
    const url = window.location.href;
    const facebookUrl = `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(url)}`;
    window.open(facebookUrl, '_blank', 'width=600,height=400');
}

/**
 * Share on LinkedIn
 */
function shareOnLinkedIn(title = 'Calculate For Me Calculator') {
    const url = window.location.href;
    const linkedInUrl = `https://www.linkedin.com/sharing/share-offsite/?url=${encodeURIComponent(url)}`;
    window.open(linkedInUrl, '_blank', 'width=600,height=400');
}

/**
 * Share on WhatsApp
 */
function shareOnWhatsApp(text = 'Check out this calculator!') {
    const url = window.location.href;
    const whatsappUrl = `https://wa.me/?text=${encodeURIComponent(text + ' ' + url)}`;
    window.open(whatsappUrl, '_blank');
}

/**
 * Copy link to clipboard
 */
function copyToClipboard(text) {
    if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(text)
            .then(() => {
                showNotification('Link copied to clipboard!', 'success');
            })
            .catch(err => {
                console.error('Failed to copy:', err);
                fallbackCopyToClipboard(text);
            });
    } else {
        fallbackCopyToClipboard(text);
    }
}

/**
 * Fallback copy method for older browsers
 */
function fallbackCopyToClipboard(text) {
    const textArea = document.createElement('textarea');
    textArea.value = text;
    textArea.style.position = 'fixed';
    textArea.style.left = '-9999px';
    document.body.appendChild(textArea);
    textArea.focus();
    textArea.select();
    
    try {
        document.execCommand('copy');
        showNotification('Link copied!', 'success');
    } catch (err) {
        showNotification('Failed to copy link', 'error');
    }
    
    document.body.removeChild(textArea);
}

// ==================== SAVE FUNCTIONS ====================

/**
 * Save calculation results to localStorage
 */
function saveCalculation(calculatorName, inputs, results) {
    const calculation = {
        id: Date.now(),
        calculator: calculatorName,
        inputs: inputs,
        results: results,
        date: new Date().toISOString(),
        url: window.location.href
    };
    
    try {
        let saved = JSON.parse(localStorage.getItem('Calculate For Me_calculations') || '[]');
        saved.unshift(calculation); // Add to beginning
        
        // Keep only last 50 calculations
        if (saved.length > 50) {
            saved = saved.slice(0, 50);
        }
        
        localStorage.setItem('Calculate For Me_calculations', JSON.stringify(saved));
        showNotification('Calculation saved!', 'success');
        return true;
    } catch (error) {
        console.error('Error saving calculation:', error);
        showNotification('Failed to save calculation', 'error');
        return false;
    }
}

/**
 * Get all saved calculations
 */
function getSavedCalculations() {
    try {
        return JSON.parse(localStorage.getItem('Calculate For Me_calculations') || '[]');
    } catch (error) {
        console.error('Error loading calculations:', error);
        return [];
    }
}

/**
 * Delete a saved calculation
 */
function deleteCalculation(calculationId) {
    try {
        let saved = getSavedCalculations();
        saved = saved.filter(calc => calc.id !== calculationId);
        localStorage.setItem('Calculate For Me_calculations', JSON.stringify(saved));
        showNotification('Calculation deleted', 'success');
        return true;
    } catch (error) {
        console.error('Error deleting calculation:', error);
        return false;
    }
}

/**
 * Clear all saved calculations
 */
function clearAllCalculations() {
    if (confirm('Are you sure you want to clear all saved calculations?')) {
        localStorage.removeItem('Calculate For Me_calculations');
        showNotification('All calculations cleared', 'success');
        return true;
    }
    return false;
}

// ==================== EXPORT FUNCTIONS ====================

/**
 * Export results as text
 */
function exportAsText(title, data) {
    let text = `${title}\n`;
    text += `Generated on: ${new Date().toLocaleString()}\n`;
    text += `Website: ${window.location.href}\n\n`;
    text += `Results:\n`;
    text += `${'='.repeat(50)}\n`;
    
    for (const [key, value] of Object.entries(data)) {
        text += `${key}: ${value}\n`;
    }
    
    downloadFile(text, `${title.replace(/\s+/g, '_')}_${Date.now()}.txt`, 'text/plain');
}

/**
 * Export results as JSON
 */
function exportAsJSON(title, data) {
    const exportData = {
        calculator: title,
        date: new Date().toISOString(),
        url: window.location.href,
        results: data
    };
    
    const json = JSON.stringify(exportData, null, 2);
    downloadFile(json, `${title.replace(/\s+/g, '_')}_${Date.now()}.json`, 'application/json');
}

/**
 * Helper function to download a file
 */
function downloadFile(content, filename, contentType) {
    const blob = new Blob([content], { type: contentType });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = filename;
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    URL.revokeObjectURL(url);
    showNotification('File downloaded!', 'success');
}

/**
 * Print results
 */
function printResults() {
    window.print();
}

// ==================== NOTIFICATION SYSTEM ====================

/**
 * Show notification toast
 */
function showNotification(message, type = 'info') {
    // Remove existing notifications
    const existing = document.querySelector('.calc-notification');
    if (existing) {
        existing.remove();
    }
    
    // Create notification
    const notification = document.createElement('div');
    notification.className = `calc-notification calc-notification-${type}`;
    notification.textContent = message;
    
    // Add styles
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 1rem 1.5rem;
        background: ${type === 'success' ? '#43e97b' : type === 'error' ? '#f5576c' : '#667eea'};
        color: white;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        z-index: 10000;
        animation: slideIn 0.3s ease;
        font-weight: 500;
    `;
    
    document.body.appendChild(notification);
    
    // Auto-remove after 3 seconds
    setTimeout(() => {
        notification.style.animation = 'slideOut 0.3s ease';
        setTimeout(() => notification.remove(), 300);
    }, 3000);
}

// Add CSS animations
if (!document.querySelector('#calc-utils-styles')) {
    const style = document.createElement('style');
    style.id = 'calc-utils-styles';
    style.textContent = `
        @keyframes slideIn {
            from {
                transform: translateX(400px);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        
        @keyframes slideOut {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(400px);
                opacity: 0;
            }
        }
        
        .share-buttons {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid #e2e8f0;
        }
        
        .share-btn {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: 500;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .share-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        
        .share-btn-twitter {
            background: #1DA1F2;
            color: white;
        }
        
        .share-btn-facebook {
            background: #4267B2;
            color: white;
        }
        
        .share-btn-linkedin {
            background: #0077b5;
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
        
        .share-btn-save {
            background: #667eea;
            color: white;
        }
        
        .share-btn-export {
            background: #f093fb;
            color: white;
        }
        
        @media (max-width: 768px) {
            .share-buttons {
                flex-direction: column;
            }
            
            .share-btn {
                width: 100%;
                justify-content: center;
            }
            
            .calc-notification {
                left: 20px !important;
                right: 20px !important;
                top: 10px !important;
            }
        }
    `;
    document.head.appendChild(style);
}

/**
 * Export results as formatted text file
 */
function exportAsTextFile(content, filename = 'calculation') {
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, -5);
    const fullFilename = `${filename}_${timestamp}.txt`;
    downloadFile(content, fullFilename, 'text/plain');
}

// ==================== ANALYTICS ====================

/**
 * Track calculator usage (when GA is set up)
 */
function trackCalculatorUse(calculatorName, action = 'calculate') {
    if (typeof gtag !== 'undefined') {
        gtag('event', action, {
            'event_category': 'Calculator',
            'event_label': calculatorName,
            'value': 1
        });
    }
}

/**
 * Track share events
 */
function trackShare(platform, calculatorName) {
    if (typeof gtag !== 'undefined') {
        gtag('event', 'share', {
            'event_category': 'Social',
            'event_label': calculatorName,
            'method': platform
        });
    }
}

// ==================== UTILITY FUNCTIONS ====================

/**
 * Format currency
 */
function formatCurrency(amount, currency = 'USD', decimals = 2) {
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: currency,
        minimumFractionDigits: decimals,
        maximumFractionDigits: decimals
    }).format(amount);
}

/**
 * Format percentage
 */
function formatPercent(value, decimals = 2) {
    return (value * 100).toFixed(decimals) + '%';
}

/**
 * Format number with commas
 */
function formatNumber(num, decimals = 0) {
    return num.toLocaleString('en-US', {
        minimumFractionDigits: decimals,
        maximumFractionDigits: decimals
    });
}

/**
 * Parse number from string (removes commas, currency symbols)
 */
function parseNumber(str) {
    if (typeof str === 'number') return str;
    return parseFloat(str.toString().replace(/[^0-9.-]+/g, ''));
}

// ==================== EXPORT MODULE ====================

// Make functions available globally
window.CalcUtils = {
    // Share functions
    shareCalculator,
    shareOnTwitter,
    shareOnFacebook,
    shareOnLinkedIn,
    shareOnWhatsApp,
    copyToClipboard,
    
    // Save functions
    saveCalculation,
    getSavedCalculations,
    deleteCalculation,
    clearAllCalculations,
    
    // Export functions
    exportAsText,
    exportAsJSON,
    printResults,
    
    // Utility functions
    showNotification,
    trackCalculatorUse,
    trackShare,
    formatCurrency,
    formatPercent,
    formatNumber,
    parseNumber
};

console.log('✅ Calculate For Me Utilities Loaded');

