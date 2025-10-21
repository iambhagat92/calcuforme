// Newsletter Backend Integration Options
// Choose one of these methods to implement real newsletter functionality

// =====================================================
// OPTION 1: FREE - Netlify Forms (Recommended for static sites)
// =====================================================

function setupNetlifyForms() {
    // Update your newsletter form HTML to:
    /*
    <form name="newsletter" method="POST" data-netlify="true" netlify-honeypot="bot-field">
        <input type="hidden" name="form-name" value="newsletter" />
        <input type="hidden" name="bot-field" style="display: none" />
        <!-- Your existing form fields -->
    </form>
    */
    
    // Then use this JavaScript:
    document.getElementById('newsletterForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        const formData = new FormData(this);
        
        fetch('/', {
            method: 'POST',
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: new URLSearchParams(formData).toString()
        })
        .then(response => {
            if (response.ok) {
                showSuccessMessage('Thank you for subscribing!');
                this.reset();
            } else {
                showErrorMessage('Subscription failed. Please try again.');
            }
        })
        .catch(error => {
            showErrorMessage('Network error. Please try again.');
            console.error('Error:', error);
        });
    });
}

// =====================================================
// OPTION 2: FREE - Formspree (Easy integration)
// =====================================================

function setupFormspree() {
    // 1. Sign up at formspree.io
    // 2. Get your form endpoint: https://formspree.io/f/YOUR_FORM_ID
    // 3. Use this code:
    
    const FORMSPREE_ENDPOINT = 'https://formspree.io/f/YOUR_FORM_ID'; // Replace with your actual endpoint
    
    document.getElementById('newsletterForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        const formData = new FormData(this);
        
        // Add custom fields
        formData.append('_subject', 'New Newsletter Subscription');
        formData.append('_next', window.location.origin + '/thank-you.html');
        
        fetch(FORMSPREE_ENDPOINT, {
            method: 'POST',
            body: formData,
            headers: {
                'Accept': 'application/json'
            }
        })
        .then(response => {
            if (response.ok) {
                showSuccessMessage('Thank you for subscribing! Please check your email.');
                this.reset();
            } else {
                showErrorMessage('Subscription failed. Please try again.');
            }
        })
        .catch(error => {
            showErrorMessage('Network error. Please try again.');
            console.error('Error:', error);
        });
    });
}

// =====================================================
// OPTION 3: PAID - Mailchimp Integration (Professional)
// =====================================================

function setupMailchimp() {
    // 1. Create Mailchimp account
    // 2. Get API key and List ID
    // 3. Use Mailchimp's API or embedded forms
    
    const MAILCHIMP_API_URL = 'https://YOUR_REGION.api.mailchimp.com/3.0/lists/YOUR_LIST_ID/members';
    const API_KEY = 'YOUR_API_KEY';
    
    document.getElementById('newsletterForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        const email = document.getElementById('email').value;
        const name = document.getElementById('name').value;
        const frequency = document.getElementById('frequency').value;
        
        // Get selected topics
        const topics = [];
        document.querySelectorAll('input[name="topics"]:checked').forEach(checkbox => {
            topics.push(checkbox.value);
        });
        
        const data = {
            email_address: email,
            status: 'subscribed',
            merge_fields: {
                FNAME: name.split(' ')[0],
                LNAME: name.split(' ').slice(1).join(' '),
                FREQUENCY: frequency,
                TOPICS: topics.join(', ')
            }
        };
        
        // Note: This requires server-side proxy due to CORS
        fetch('/api/subscribe', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data)
        })
        .then(response => response.json())
        .then(result => {
            if (result.success) {
                showSuccessMessage('Thank you for subscribing!');
                this.reset();
            } else {
                showErrorMessage('Subscription failed. Please try again.');
            }
        })
        .catch(error => {
            showErrorMessage('Network error. Please try again.');
            console.error('Error:', error);
        });
    });
}

// =====================================================
// OPTION 4: FREE - ConvertKit Integration
// =====================================================

function setupConvertKit() {
    // 1. Sign up for ConvertKit (free up to 1000 subscribers)
    // 2. Create a form and get the form ID
    // 3. Use this code:
    
    const CONVERTKIT_FORM_ID = 'YOUR_FORM_ID';
    const CONVERTKIT_API_KEY = 'YOUR_API_KEY';
    
    document.getElementById('newsletterForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        const email = document.getElementById('email').value;
        const name = document.getElementById('name').value;
        
        const data = {
            api_key: CONVERTKIT_API_KEY,
            email: email,
            first_name: name.split(' ')[0],
            fields: {
                last_name: name.split(' ').slice(1).join(' '),
                frequency: document.getElementById('frequency').value
            }
        };
        
        fetch(`https://api.convertkit.com/v3/forms/${CONVERTKIT_FORM_ID}/subscribe`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data)
        })
        .then(response => response.json())
        .then(result => {
            if (result.subscription) {
                showSuccessMessage('Thank you for subscribing! Please check your email.');
                this.reset();
            } else {
                showErrorMessage('Subscription failed. Please try again.');
            }
        })
        .catch(error => {
            showErrorMessage('Network error. Please try again.');
            console.error('Error:', error);
        });
    });
}

// =====================================================
// UTILITY FUNCTIONS
// =====================================================

function showSuccessMessage(message) {
    const successDiv = document.getElementById('successMessage');
    successDiv.innerHTML = `<i class="fas fa-check-circle"></i> ${message}`;
    successDiv.style.display = 'block';
    
    setTimeout(() => {
        successDiv.style.display = 'none';
    }, 5000);
}

function showErrorMessage(message) {
    const errorDiv = document.getElementById('errorMessage');
    document.getElementById('errorText').textContent = message;
    errorDiv.style.display = 'block';
    
    setTimeout(() => {
        errorDiv.style.display = 'none';
    }, 5000);
}

// =====================================================
// RECOMMENDATION FOR YOUR SITE
// =====================================================

/*
RECOMMENDED APPROACH FOR CALCULATE FOR ME:

1. IMMEDIATE FIX (Free): Use Formspree
   - Quick setup (5 minutes)
   - No server required
   - Handles 50 submissions/month for free
   - Perfect for starting

2. LONG-TERM (Paid): Use Mailchimp + ConvertKit
   - Professional email marketing
   - Automated sequences
   - Analytics and tracking
   - Better deliverability

STEPS TO IMPLEMENT:
1. Choose Formspree for quick fix
2. Sign up at formspree.io
3. Create a new form
4. Replace the newsletter form code
5. Test the functionality

This will make your newsletter actually work!
*/