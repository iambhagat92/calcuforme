import os
import json

# Define infographic data for all 15 blog posts
infographics_data = {
    "01": {
        "title": "Motor Insurance Premium Calculator",
        "infographics": [
            {
                "type": "journey",
                "filename": "01-motor-insurance-calculator-journey.html",
                "title": "Motor Insurance Calculator Journey",
                "subtitle": "5 Simple Steps to Get Accurate Quotes",
                "hindi": "सटीक प्रीमियम कैल्कुलेशन की यात्रा"
            },
            {
                "type": "steps",
                "filename": "01-premium-calculation-steps.html",
                "title": "Premium Calculation Steps",
                "subtitle": "Detailed Process Breakdown",
                "hindi": "प्रीमियम गणना के चरण"
            },
            {
                "type": "mistakes",
                "filename": "01-calculator-mistakes.html",
                "title": "Common Calculator Mistakes",
                "subtitle": "Avoid These Pitfalls",
                "hindi": "सामान्य गलतियों से बचें"
            }
        ]
    },
    "02": {
        "title": "Automobile Insurance Calculator Guide",
        "infographics": [
            {
                "type": "dashboard",
                "filename": "02-automobile-insurance-main.html",
                "title": "Automobile Insurance Calculator",
                "subtitle": "Complete Feature Overview",
                "hindi": "ऑटोमोबाइल बीमा कैल्कुलेटर गाइड"
            },
            {
                "type": "features",
                "filename": "02-automobile-insurance-features.html",
                "title": "Key Features & Benefits",
                "subtitle": "Why Use Insurance Calculators",
                "hindi": "मुख्य विशेषताएं और लाभ"
            },
            {
                "type": "pitfalls",
                "filename": "02-automobile-insurance-pitfalls.html",
                "title": "Pitfalls to Avoid",
                "subtitle": "Common Roadblocks",
                "hindi": "बचने योग्य समस्याएं"
            }
        ]
    },
    "03": {
        "title": "Car Insurance Calculators for Beginners",
        "infographics": [
            {
                "type": "beginner",
                "filename": "03-beginners-guide-main.html",
                "title": "Beginner's Guide",
                "subtitle": "Start Your Insurance Journey",
                "hindi": "शुरुआती गाइड"
            },
            {
                "type": "checklist",
                "filename": "03-preparation-checklist.html",
                "title": "Preparation Checklist",
                "subtitle": "What You Need Before Starting",
                "hindi": "तैयारी चेकलिस्ट"
            },
            {
                "type": "dos-donts",
                "filename": "03-dos-and-donts.html",
                "title": "Do's and Don'ts",
                "subtitle": "Best Practices for Beginners",
                "hindi": "क्या करें और क्या न करें"
            }
        ]
    },
    "04": {
        "title": "Save Money with Insurance Calculator",
        "infographics": [
            {
                "type": "savings",
                "filename": "04-money-saving-tips.html",
                "title": "Money Saving Tips",
                "subtitle": "Maximize Your Savings",
                "hindi": "पैसे बचाने के टिप्स"
            },
            {
                "type": "comparison",
                "filename": "04-savings-calculator.html",
                "title": "Savings Calculator",
                "subtitle": "Before vs After Comparison",
                "hindi": "बचत कैल्कुलेटर"
            },
            {
                "type": "traps",
                "filename": "04-cost-traps.html",
                "title": "Hidden Cost Traps",
                "subtitle": "Avoid Unnecessary Expenses",
                "hindi": "छिपी हुई लागतें"
            }
        ]
    },
    "05": {
        "title": "Best Practices for Insurance Calculator",
        "infographics": [
            {
                "type": "practices",
                "filename": "05-best-practices-main.html",
                "title": "Best Practices Guide",
                "subtitle": "Expert Recommendations",
                "hindi": "सर्वोत्तम प्रथाएं"
            },
            {
                "type": "tips",
                "filename": "05-expert-tips.html",
                "title": "Expert Tips",
                "subtitle": "Professional Insights",
                "hindi": "विशेषज्ञ सुझाव"
            },
            {
                "type": "myths",
                "filename": "05-myths-vs-reality.html",
                "title": "Myths vs Reality",
                "subtitle": "Common Misconceptions",
                "hindi": "मिथक बनाम वास्तविकता"
            }
        ]
    }
}

def generate_journey_infographic(data, blog_num):
    """Generate journey/process flow infographic"""
    return f'''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=1200, height=628">
    <title>{data['title']}</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&family=Open+Sans:wght@400;600&family=Noto+Sans+Devanagari:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../CSS/infographic-styles.css">
</head>
<body>
    <div class="infographic-container">
        <div class="infographic-header">
            <h1>{data['title']}</h1>
            <p class="subtitle">{data['subtitle']}</p>
            <p class="hindi-text">{data['hindi']}</p>
        </div>
        
        <div class="infographic-content">
            <div class="process-flow">
                <div class="process-step">
                    <div class="process-icon">📝</div>
                    <h4>Step 1</h4>
                    <p>Start Process</p>
                </div>
                <div class="process-step">
                    <div class="process-icon">🔍</div>
                    <h4>Step 2</h4>
                    <p>Analyze Options</p>
                </div>
                <div class="process-step">
                    <div class="process-icon">💡</div>
                    <h4>Step 3</h4>
                    <p>Make Decision</p>
                </div>
                <div class="process-step">
                    <div class="process-icon">✅</div>
                    <h4>Step 4</h4>
                    <p>Complete</p>
                </div>
            </div>
            
            <div class="highlight-box">
                <h4>💡 Key Insight:</h4>
                <p>Follow these steps systematically for best results in your insurance calculator journey.</p>
            </div>
        </div>
        
        <div class="infographic-footer">
            <p>Learn more at <a href="#" class="website-url">www.calcuforme.com</a> | Blog {blog_num}</p>
        </div>
    </div>
</body>
</html>'''

def generate_features_infographic(data, blog_num):
    """Generate features comparison infographic"""
    return f'''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=1200, height=628">
    <title>{data['title']}</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&family=Open+Sans:wght@400;600&family=Noto+Sans+Devanagari:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../CSS/infographic-styles.css">
</head>
<body>
    <div class="infographic-container">
        <div class="infographic-header">
            <h1>{data['title']}</h1>
            <p class="subtitle">{data['subtitle']}</p>
            <p class="hindi-text">{data['hindi']}</p>
        </div>
        
        <div class="infographic-content">
            <div class="feature-grid">
                <div class="feature-card">
                    <div class="icon icon-calculator"></div>
                    <h4>Quick Calculation</h4>
                    <p>Get instant premium quotes in minutes</p>
                </div>
                <div class="feature-card">
                    <div class="icon icon-money"></div>
                    <h4>Save Money</h4>
                    <p>Compare and save up to 30% on premiums</p>
                </div>
                <div class="feature-card">
                    <div class="icon icon-shield"></div>
                    <h4>Secure Process</h4>
                    <p>100% secure and encrypted</p>
                </div>
                <div class="feature-card">
                    <div class="icon icon-chart"></div>
                    <h4>Easy Comparison</h4>
                    <p>Compare multiple insurers side-by-side</p>
                </div>
                <div class="feature-card">
                    <div class="icon icon-mobile"></div>
                    <h4>Mobile Friendly</h4>
                    <p>Access anytime, anywhere</p>
                </div>
                <div class="feature-card">
                    <div class="icon icon-time"></div>
                    <h4>24/7 Available</h4>
                    <p>Calculate premiums round the clock</p>
                </div>
            </div>
        </div>
        
        <div class="infographic-footer">
            <p>Learn more at <a href="#" class="website-url">www.calcuforme.com</a> | Blog {blog_num}</p>
        </div>
    </div>
</body>
</html>'''

def generate_mistakes_infographic(data, blog_num):
    """Generate common mistakes/dos-donts infographic"""
    return f'''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=1200, height=628">
    <title>{data['title']}</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&family=Open+Sans:wght@400;600&family=Noto+Sans+Devanagari:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../CSS/infographic-styles.css">
</head>
<body>
    <div class="infographic-container">
        <div class="infographic-header">
            <h1>{data['title']}</h1>
            <p class="subtitle">{data['subtitle']}</p>
            <p class="hindi-text">{data['hindi']}</p>
        </div>
        
        <div class="infographic-content">
            <div class="dos-donts-container">
                <div class="dos-section">
                    <h3>✅ Do's</h3>
                    <div class="list-item">
                        <span class="check">✓</span>
                        <span>Provide accurate vehicle information</span>
                    </div>
                    <div class="list-item">
                        <span class="check">✓</span>
                        <span>Compare multiple insurers</span>
                    </div>
                    <div class="list-item">
                        <span class="check">✓</span>
                        <span>Check coverage details carefully</span>
                    </div>
                    <div class="list-item">
                        <span class="check">✓</span>
                        <span>Update information regularly</span>
                    </div>
                </div>
                
                <div class="donts-section">
                    <h3>❌ Don'ts</h3>
                    <div class="list-item">
                        <span class="cross">✗</span>
                        <span>Rush through the process</span>
                    </div>
                    <div class="list-item">
                        <span class="cross">✗</span>
                        <span>Ignore policy exclusions</span>
                    </div>
                    <div class="list-item">
                        <span class="cross">✗</span>
                        <span>Choose based on price alone</span>
                    </div>
                    <div class="list-item">
                        <span class="cross">✗</span>
                        <span>Forget to claim NCB</span>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="infographic-footer">
            <p>Learn more at <a href="#" class="website-url">www.calcuforme.com</a> | Blog {blog_num}</p>
        </div>
    </div>
</body>
</html>'''

def generate_steps_infographic(data, blog_num):
    """Generate step-by-step infographic"""
    return f'''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=1200, height=628">
    <title>{data['title']}</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&family=Open+Sans:wght@400;600&family=Noto+Sans+Devanagari:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../CSS/infographic-styles.css">
</head>
<body>
    <div class="infographic-container">
        <div class="infographic-header">
            <h1>{data['title']}</h1>
            <p class="subtitle">{data['subtitle']}</p>
            <p class="hindi-text">{data['hindi']}</p>
        </div>
        
        <div class="infographic-content">
            <div class="steps-container">
                <div class="step-item">
                    <div class="step-number">1</div>
                    <div class="step-content">
                        <h3>Gather Information</h3>
                        <p>Collect all vehicle and personal details</p>
                    </div>
                </div>
                <div class="step-item">
                    <div class="step-number">2</div>
                    <div class="step-content">
                        <h3>Enter Details</h3>
                        <p>Input accurate information in calculator</p>
                    </div>
                </div>
                <div class="step-item">
                    <div class="step-number">3</div>
                    <div class="step-content">
                        <h3>Select Coverage</h3>
                        <p>Choose appropriate coverage options</p>
                    </div>
                </div>
                <div class="step-item">
                    <div class="step-number">4</div>
                    <div class="step-content">
                        <h3>Compare Quotes</h3>
                        <p>Review and compare different options</p>
                    </div>
                </div>
                <div class="step-item">
                    <div class="step-number">5</div>
                    <div class="step-content">
                        <h3>Make Decision</h3>
                        <p>Select the best insurance plan</p>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="infographic-footer">
            <p>Learn more at <a href="#" class="website-url">www.calcuforme.com</a> | Blog {blog_num}</p>
        </div>
    </div>
</body>
</html>'''

def generate_comparison_infographic(data, blog_num):
    """Generate comparison table infographic"""
    return f'''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=1200, height=628">
    <title>{data['title']}</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&family=Open+Sans:wght@400;600&family=Noto+Sans+Devanagari:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../CSS/infographic-styles.css">
    <style>
        .comparison-content {{
            padding: 30px;
        }}
    </style>
</head>
<body>
    <div class="infographic-container">
        <div class="infographic-header">
            <h1>{data['title']}</h1>
            <p class="subtitle">{data['subtitle']}</p>
            <p class="hindi-text">{data['hindi']}</p>
        </div>
        
        <div class="infographic-content comparison-content">
            <table class="comparison-table">
                <thead>
                    <tr>
                        <th>Feature</th>
                        <th>Traditional Method</th>
                        <th>Online Calculator</th>
                        <th>Savings</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Time Required</td>
                        <td>2-3 Days</td>
                        <td>10 Minutes</td>
                        <td><span style="color: var(--success-green);">95% Faster</span></td>
                    </tr>
                    <tr>
                        <td>Number of Quotes</td>
                        <td>1-2</td>
                        <td>10+</td>
                        <td><span style="color: var(--success-green);">5x More Options</span></td>
                    </tr>
                    <tr>
                        <td>Cost</td>
                        <td>Agent Commission</td>
                        <td>Free</td>
                        <td><span style="color: var(--success-green);">100% Savings</span></td>
                    </tr>
                    <tr>
                        <td>Accuracy</td>
                        <td>Manual Errors</td>
                        <td>Automated</td>
                        <td><span style="color: var(--success-green);">99% Accurate</span></td>
                    </tr>
                </tbody>
            </table>
            
            <div class="stats-container" style="margin-top: 30px;">
                <div class="stat-item">
                    <div class="stat-number">₹5000+</div>
                    <div class="stat-label">Average Savings</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">10 Min</div>
                    <div class="stat-label">Time to Complete</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">15+</div>
                    <div class="stat-label">Insurers Available</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">24/7</div>
                    <div class="stat-label">Accessibility</div>
                </div>
            </div>
        </div>
        
        <div class="infographic-footer">
            <p>Learn more at <a href="#" class="website-url">www.calcuforme.com</a> | Blog {blog_num}</p>
        </div>
    </div>
</body>
</html>'''

# Generator functions mapping
generators = {
    "journey": generate_journey_infographic,
    "steps": generate_steps_infographic,
    "features": generate_features_infographic,
    "mistakes": generate_mistakes_infographic,
    "dos-donts": generate_mistakes_infographic,
    "comparison": generate_comparison_infographic,
    "dashboard": generate_features_infographic,
    "pitfalls": generate_mistakes_infographic,
    "beginner": generate_journey_infographic,
    "checklist": generate_steps_infographic,
    "savings": generate_comparison_infographic,
    "traps": generate_mistakes_infographic,
    "practices": generate_steps_infographic,
    "tips": generate_features_infographic,
    "myths": generate_mistakes_infographic
}

def main():
    output_dir = "F:\\CalcuForMe\\Car-Insurance-Calculator-Blog-Series\\Infographics\\Generated"
    
    # Generate infographics for each blog
    for blog_num, blog_data in infographics_data.items():
        print(f"Generating infographics for Blog {blog_num}: {blog_data['title']}")
        
        for infographic in blog_data["infographics"]:
            # Get the appropriate generator
            generator = generators.get(infographic["type"], generate_journey_infographic)
            
            # Generate HTML content
            html_content = generator(infographic, blog_num)
            
            # Write to file
            filepath = os.path.join(output_dir, infographic["filename"])
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(html_content)
            
            print(f"  ✅ Created: {infographic['filename']}")
    
    # Generate remaining blogs (6-15) with similar pattern
    for i in range(6, 16):
        blog_num = f"{i:02d}"
        print(f"Generating infographics for Blog {blog_num}")
        
        # Create 3 infographics per blog
        infographics = [
            {
                "type": "journey",
                "filename": f"{blog_num}-main.html",
                "title": f"Blog {blog_num} Main Infographic",
                "subtitle": "Key Concepts Overview",
                "hindi": "मुख्य अवधारणाएं"
            },
            {
                "type": "features",
                "filename": f"{blog_num}-features.html",
                "title": f"Blog {blog_num} Features",
                "subtitle": "Important Features",
                "hindi": "महत्वपूर्ण विशेषताएं"
            },
            {
                "type": "mistakes",
                "filename": f"{blog_num}-pitfalls.html",
                "title": f"Blog {blog_num} Common Mistakes",
                "subtitle": "Avoid These Issues",
                "hindi": "इन समस्याओं से बचें"
            }
        ]
        
        for infographic in infographics:
            generator = generators.get(infographic["type"], generate_journey_infographic)
            html_content = generator(infographic, blog_num)
            
            filepath = os.path.join(output_dir, infographic["filename"])
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(html_content)
            
            print(f"  ✅ Created: {infographic['filename']}")
    
    print(f"\n✅ Successfully generated all infographics!")
    print(f"Total files created: {15 * 3} infographics")
    print(f"Location: {output_dir}")

if __name__ == "__main__":
    main()