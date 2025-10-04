// CalcuForMe - Main JavaScript File

// Calculator Database
const calculators = [
    // Financial & Business
    { name: 'ROI Calculator', category: 'Financial', url: 'calculators/roi-calculator.html', icon: 'fa-chart-pie', keywords: 'roi return investment profit' },
    { name: 'Break-Even Calculator', category: 'Financial', url: 'calculators/breakeven-calculator.html', icon: 'fa-chart-line', keywords: 'breakeven break even cost revenue' },
    { name: 'Profit Margin Calculator', category: 'Financial', url: 'calculators/profit-calculator.html', icon: 'fa-percentage', keywords: 'profit margin revenue' },
    { name: 'Loan Calculator', category: 'Financial', url: 'calculators/loan-calculator.html', icon: 'fa-money-bill-wave', keywords: 'loan emi mortgage payment interest' },
    { name: 'Tip Calculator', category: 'Financial', url: 'calculators/tip-calculator.html', icon: 'fa-receipt', keywords: 'tip gratuity bill split restaurant' },
    { name: 'Discount Calculator', category: 'Financial', url: 'calculators/discount-calculator.html', icon: 'fa-tag', keywords: 'discount sale savings percentage' },
    { name: 'Sales Tax Calculator', category: 'Financial', url: 'calculators/tax-calculator.html', icon: 'fa-file-invoice-dollar', keywords: 'tax sales vat gst' },
    
    // Health & Wellness
    { name: 'BMI Calculator', category: 'Health', url: 'calculators/bmi-calculator.html', icon: 'fa-weight', keywords: 'bmi body mass index weight height' },
    { name: 'BMR Calculator', category: 'Health', url: 'calculators/bmr-calculator.html', icon: 'fa-heartbeat', keywords: 'bmr basal metabolic rate calories' },
    { name: 'Calorie Calculator', category: 'Health', url: 'calculators/calorie-calculator.html', icon: 'fa-fire', keywords: 'calorie tdee deficit surplus diet' },
    { name: 'Body Fat Calculator', category: 'Health', url: 'calculators/bodyfat-calculator.html', icon: 'fa-user', keywords: 'body fat percentage lean mass' },
    { name: 'Pregnancy Calculator', category: 'Health', url: 'calculators/pregnancy-calculator.html', icon: 'fa-baby', keywords: 'pregnancy due date trimester' },
    { name: 'Water Intake Calculator', category: 'Health', url: 'calculators/water-calculator.html', icon: 'fa-tint', keywords: 'water hydration intake daily' },
    
    // Home & Garden
    { name: 'Paint Calculator', category: 'Home', url: 'calculators/paint-calculator.html', icon: 'fa-paint-roller', keywords: 'paint wall room gallon' },
    { name: 'Tile Calculator', category: 'Home', url: 'calculators/tile-calculator.html', icon: 'fa-th', keywords: 'tile flooring square feet' },
    { name: 'Mortgage Calculator', category: 'Home', url: 'calculators/mortgage-calculator.html', icon: 'fa-home', keywords: 'mortgage home loan payment piti' },
    { name: 'Concrete Calculator', category: 'Home', url: 'calculators/concrete-calculator.html', icon: 'fa-cube', keywords: 'concrete cement cubic yards' },
    
    // Education & Science
    { name: 'GPA Calculator', category: 'Education', url: 'calculators/gpa-calculator.html', icon: 'fa-user-graduate', keywords: 'gpa grade point average college' },
    { name: 'Grade Calculator', category: 'Education', url: 'calculators/grade-calculator.html', icon: 'fa-graduation-cap', keywords: 'grade marks percentage score' },
    { name: 'Percentage Calculator', category: 'Education', url: 'calculators/percentage-calculator.html', icon: 'fa-percent', keywords: 'percentage calculator math' },
    { name: 'Scientific Calculator', category: 'Education', url: 'calculators/scientific-calculator.html', icon: 'fa-calculator', keywords: 'scientific calculator math trigonometry' },
    
    // Creative & Misc
    { name: 'Age Calculator', category: 'Creative', url: 'calculators/age-calculator.html', icon: 'fa-birthday-cake', keywords: 'age birthday years months days' },
    { name: 'Date Calculator', category: 'Creative', url: 'calculators/date-calculator.html', icon: 'fa-calendar', keywords: 'date duration difference days' },
    { name: 'Time Calculator', category: 'Creative', url: 'calculators/time-calculator.html', icon: 'fa-clock', keywords: 'time hours minutes duration' },
    { name: 'Random Number Generator', category: 'Creative', url: 'calculators/random-generator.html', icon: 'fa-random', keywords: 'random number generator luck' },
];

// DOM Elements
const mobileMenuBtn = document.getElementById('mobileMenuBtn');
const mobileMenu = document.getElementById('mobileMenu');
const closeMenuBtn = document.getElementById('closeMenuBtn');
const searchInput = document.getElementById('searchInput');
const searchResults = document.getElementById('searchResults');

// Mobile Menu Toggle
if (mobileMenuBtn) {
    mobileMenuBtn.addEventListener('click', () => {
        mobileMenu.classList.add('active');
    });
}

if (closeMenuBtn) {
    closeMenuBtn.addEventListener('click', () => {
        mobileMenu.classList.remove('active');
    });
}

// Close mobile menu when clicking outside
document.addEventListener('click', (e) => {
    if (mobileMenu && !mobileMenu.contains(e.target) && !mobileMenuBtn.contains(e.target)) {
        mobileMenu.classList.remove('active');
    }
});

// Close mobile menu when clicking a link
if (mobileMenu) {
    const mobileLinks = mobileMenu.querySelectorAll('a');
    mobileLinks.forEach(link => {
        link.addEventListener('click', () => {
            mobileMenu.classList.remove('active');
        });
    });
}

// Search Functionality
if (searchInput) {
    searchInput.addEventListener('input', (e) => {
        const query = e.target.value.toLowerCase().trim();
        
        if (query.length < 2) {
            searchResults.classList.remove('active');
            searchResults.innerHTML = '';
            return;
        }
        
        const filtered = calculators.filter(calc => {
            return calc.name.toLowerCase().includes(query) || 
                   calc.keywords.toLowerCase().includes(query) ||
                   calc.category.toLowerCase().includes(query);
        });
        
        if (filtered.length > 0) {
            displaySearchResults(filtered.slice(0, 8)); // Show max 8 results
        } else {
            searchResults.innerHTML = '<div class="search-result-item" style="cursor: default;">No calculators found</div>';
            searchResults.classList.add('active');
        }
    });
    
    // Close search results when clicking outside
    document.addEventListener('click', (e) => {
        if (!searchInput.contains(e.target) && !searchResults.contains(e.target)) {
            searchResults.classList.remove('active');
        }
    });
}

function displaySearchResults(results) {
    searchResults.innerHTML = results.map(calc => `
        <a href="${calc.url}" class="search-result-item">
            <i class="fas ${calc.icon}"></i>
            <div>
                <div style="font-weight: 600; color: #2d3748;">${calc.name}</div>
                <div style="font-size: 0.85rem; color: #718096;">${calc.category}</div>
            </div>
        </a>
    `).join('');
    searchResults.classList.add('active');
}

// Smooth Scroll for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        const href = this.getAttribute('href');
        if (href !== '#') {
            e.preventDefault();
            const target = document.querySelector(href);
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        }
    });
});

// Scroll to top button (optional enhancement)
const scrollToTopBtn = document.createElement('button');
scrollToTopBtn.innerHTML = '<i class="fas fa-arrow-up"></i>';
scrollToTopBtn.className = 'scroll-to-top';
scrollToTopBtn.style.cssText = `
    position: fixed;
    bottom: 30px;
    right: 30px;
    width: 50px;
    height: 50px;
    border-radius: 50%;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    border: none;
    cursor: pointer;
    display: none;
    align-items: center;
    justify-content: center;
    font-size: 1.2rem;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
    transition: all 0.3s ease;
    z-index: 999;
`;

document.body.appendChild(scrollToTopBtn);

window.addEventListener('scroll', () => {
    if (window.pageYOffset > 300) {
        scrollToTopBtn.style.display = 'flex';
    } else {
        scrollToTopBtn.style.display = 'none';
    }
});

scrollToTopBtn.addEventListener('click', () => {
    window.scrollTo({
        top: 0,
        behavior: 'smooth'
    });
});

scrollToTopBtn.addEventListener('mouseenter', () => {
    scrollToTopBtn.style.transform = 'translateY(-5px)';
});

scrollToTopBtn.addEventListener('mouseleave', () => {
    scrollToTopBtn.style.transform = 'translateY(0)';
});

// Navbar background change on scroll
const navbar = document.querySelector('.navbar');
if (navbar) {
    window.addEventListener('scroll', () => {
        if (window.scrollY > 50) {
            navbar.style.boxShadow = '0 10px 30px rgba(0, 0, 0, 0.15)';
        } else {
            navbar.style.boxShadow = '0 10px 30px rgba(0, 0, 0, 0.1)';
        }
    });
}

// Animation on scroll (for future enhancements)
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -100px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, observerOptions);

// Observe elements for animation (optional)
document.querySelectorAll('.category-card, .calculator-item, .feature-item').forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(20px)';
    el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
    observer.observe(el);
});

// Daily Use Calculator on Homepage
function calculateDaily() {
    const num1 = parseFloat(document.getElementById('num1').value);
    const num2 = parseFloat(document.getElementById('num2').value);
    const operator = document.getElementById('operator').value;
    const resultDiv = document.getElementById('dailyResult');
    const resultValue = document.getElementById('dailyResultValue');
    
    if (isNaN(num1) || isNaN(num2)) {
        alert('Please enter valid numbers');
        return;
    }
    
    let result;
    switch(operator) {
        case '+':
            result = num1 + num2;
            break;
        case '-':
            result = num1 - num2;
            break;
        case '*':
            result = num1 * num2;
            break;
        case '/':
            if (num2 === 0) {
                alert('Cannot divide by zero');
                return;
            }
            result = num1 / num2;
            break;
    }
    
    resultValue.textContent = result.toFixed(2);
    resultDiv.style.display = 'block';
    
    // Animate result
    resultDiv.style.opacity = '0';
    resultDiv.style.transform = 'translateY(-10px)';
    setTimeout(() => {
        resultDiv.style.transition = 'all 0.4s ease';
        resultDiv.style.opacity = '1';
        resultDiv.style.transform = 'translateY(0)';
    }, 10);
}

// Quick Percentage Calculator on Homepage
function calculateQuickPercentage() {
    const number = parseFloat(document.getElementById('quickNumber').value);
    const percent = parseFloat(document.getElementById('quickPercent').value);
    const resultDiv = document.getElementById('quickResult');
    const resultValue = document.getElementById('quickResultValue');
    const resultText = document.getElementById('quickResultText');
    
    if (isNaN(number) || isNaN(percent)) {
        alert('Please enter valid numbers');
        return;
    }
    
    const result = (number * percent) / 100;
    
    resultValue.textContent = result.toFixed(2);
    resultText.textContent = `${percent}% of ${number} is ${result.toFixed(2)}`;
    resultDiv.style.display = 'block';
    
    // Animate result
    resultDiv.style.opacity = '0';
    resultDiv.style.transform = 'translateY(-10px)';
    setTimeout(() => {
        resultDiv.style.transition = 'all 0.4s ease';
        resultDiv.style.opacity = '1';
        resultDiv.style.transform = 'translateY(0)';
    }, 10);
}

// Allow Enter key to calculate - Daily Calculator
if (document.getElementById('num1')) {
    document.getElementById('num1').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') calculateDaily();
    });
}

if (document.getElementById('num2')) {
    document.getElementById('num2').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') calculateDaily();
    });
}

// Allow Enter key to calculate - Percentage Calculator
if (document.getElementById('quickNumber')) {
    document.getElementById('quickNumber').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') calculateQuickPercentage();
    });
}

if (document.getElementById('quickPercent')) {
    document.getElementById('quickPercent').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') calculateQuickPercentage();
    });
}

// Dark Mode Toggle
const themeToggle = document.createElement('button');
themeToggle.className = 'theme-toggle';
themeToggle.innerHTML = '<i class="fas fa-moon"></i>';
themeToggle.setAttribute('aria-label', 'Toggle Dark Mode');
document.body.appendChild(themeToggle);

// Check for saved theme preference or default to light mode
const currentTheme = localStorage.getItem('theme') || 'light';
document.documentElement.setAttribute('data-theme', currentTheme);

// Update icon based on current theme
if (currentTheme === 'dark') {
    themeToggle.innerHTML = '<i class="fas fa-sun"></i>';
}

// Theme toggle functionality
themeToggle.addEventListener('click', () => {
    const theme = document.documentElement.getAttribute('data-theme');
    const newTheme = theme === 'light' ? 'dark' : 'light';
    
    document.documentElement.setAttribute('data-theme', newTheme);
    localStorage.setItem('theme', newTheme);
    
    // Update icon with animation
    themeToggle.style.transform = 'rotate(360deg)';
    setTimeout(() => {
        themeToggle.innerHTML = newTheme === 'dark' 
            ? '<i class="fas fa-sun"></i>' 
            : '<i class="fas fa-moon"></i>';
        themeToggle.style.transform = 'rotate(0deg)';
    }, 150);
});

// Console welcome message
console.log('%cCalcuForMe', 'color: #667eea; font-size: 24px; font-weight: bold;');
console.log('%cYour complete calculator suite!', 'color: #764ba2; font-size: 14px;');
console.log('Developed with ❤️ for everyone');
