"""
HTML to Image Converter for Car Insurance Calculator Infographics
Converts all 45 HTML infographics to PNG images
"""

import os
import time
from pathlib import Path

# Method 1: Using html2image (Recommended)
def convert_with_html2image():
    """Convert HTML files to images using html2image library"""
    try:
        from html2image import Html2Image
        
        print("🎨 Starting HTML to Image conversion with html2image...")
        
        # Setup paths
        generated_dir = Path("Generated")
        images_dir = Path("Images")
        images_dir.mkdir(exist_ok=True)
        
        # Initialize converter
        hti = Html2Image(output_path=str(images_dir))
        
        # Get all HTML files
        html_files = list(generated_dir.glob("*.html"))
        total_files = len(html_files)
        
        print(f"📁 Found {total_files} HTML files to convert")
        
        # Convert each file
        for i, html_file in enumerate(html_files, 1):
            output_name = html_file.stem + ".png"
            
            # Read HTML content
            with open(html_file, 'r', encoding='utf-8') as f:
                html_content = f.read()
            
            # Fix CSS path for local file
            css_path = Path("CSS/infographic-styles.css").resolve()
            html_content = html_content.replace(
                '../CSS/infographic-styles.css',
                f'file:///{css_path}'.replace('\\', '/')
            )
            
            # Convert to image
            print(f"[{i}/{total_files}] Converting: {html_file.name} → {output_name}")
            
            hti.screenshot(
                html_str=html_content,
                save_as=output_name,
                size=(1200, 628)
            )
            
            print(f"    ✅ Saved: {output_name}")
        
        print(f"\n✨ Successfully converted all {total_files} infographics!")
        print(f"📁 Images saved in: {images_dir.resolve()}")
        return True
        
    except ImportError:
        print("❌ html2image not installed. Installing...")
        os.system("pip install html2image")
        return convert_with_html2image()
    except Exception as e:
        print(f"❌ Error with html2image: {e}")
        return False

# Method 2: Using Selenium with Chrome
def convert_with_selenium():
    """Convert HTML files using Selenium WebDriver"""
    try:
        from selenium import webdriver
        from selenium.webdriver.chrome.options import Options
        
        print("🎨 Starting HTML to Image conversion with Selenium...")
        
        # Setup paths
        generated_dir = Path("Generated")
        images_dir = Path("Images")
        images_dir.mkdir(exist_ok=True)
        
        # Setup Chrome options
        chrome_options = Options()
        chrome_options.add_argument("--headless")
        chrome_options.add_argument("--window-size=1200,628")
        chrome_options.add_argument("--disable-gpu")
        chrome_options.add_argument("--no-sandbox")
        
        # Initialize driver
        driver = webdriver.Chrome(options=chrome_options)
        
        # Get all HTML files
        html_files = list(generated_dir.glob("*.html"))
        total_files = len(html_files)
        
        print(f"📁 Found {total_files} HTML files to convert")
        
        # Convert each file
        for i, html_file in enumerate(html_files, 1):
            output_path = images_dir / (html_file.stem + ".png")
            
            # Open HTML file
            file_url = f"file:///{html_file.resolve()}".replace('\\', '/')
            driver.get(file_url)
            
            # Wait for page to load
            time.sleep(2)
            
            # Take screenshot
            print(f"[{i}/{total_files}] Converting: {html_file.name} → {output_path.name}")
            driver.save_screenshot(str(output_path))
            print(f"    ✅ Saved: {output_path.name}")
        
        driver.quit()
        print(f"\n✨ Successfully converted all {total_files} infographics!")
        print(f"📁 Images saved in: {images_dir.resolve()}")
        return True
        
    except ImportError:
        print("❌ Selenium not installed. Installing...")
        os.system("pip install selenium")
        return convert_with_selenium()
    except Exception as e:
        print(f"❌ Error with Selenium: {e}")
        return False

# Method 3: Using wkhtmltoimage (External tool)
def convert_with_wkhtmltoimage():
    """Convert HTML files using wkhtmltoimage command line tool"""
    try:
        import subprocess
        
        print("🎨 Starting HTML to Image conversion with wkhtmltoimage...")
        
        # Check if wkhtmltoimage is installed
        result = subprocess.run(['wkhtmltoimage', '--version'], 
                              capture_output=True, text=True)
        
        if result.returncode != 0:
            print("❌ wkhtmltoimage not installed.")
            print("📥 Download from: https://wkhtmltopdf.org/downloads.html")
            return False
        
        # Setup paths
        generated_dir = Path("Generated")
        images_dir = Path("Images")
        images_dir.mkdir(exist_ok=True)
        
        # Get all HTML files
        html_files = list(generated_dir.glob("*.html"))
        total_files = len(html_files)
        
        print(f"📁 Found {total_files} HTML files to convert")
        
        # Convert each file
        for i, html_file in enumerate(html_files, 1):
            output_path = images_dir / (html_file.stem + ".png")
            
            print(f"[{i}/{total_files}] Converting: {html_file.name} → {output_path.name}")
            
            # Run wkhtmltoimage
            subprocess.run([
                'wkhtmltoimage',
                '--width', '1200',
                '--height', '628',
                '--quality', '95',
                str(html_file),
                str(output_path)
            ])
            
            print(f"    ✅ Saved: {output_path.name}")
        
        print(f"\n✨ Successfully converted all {total_files} infographics!")
        print(f"📁 Images saved in: {images_dir.resolve()}")
        return True
        
    except Exception as e:
        print(f"❌ Error with wkhtmltoimage: {e}")
        return False

# Method 4: Simple browser automation with pyautogui
def convert_with_browser_automation():
    """Simple method using browser and screenshots"""
    try:
        import webbrowser
        import pyautogui
        import time
        
        print("🎨 Starting manual browser conversion...")
        print("⚠️  This method requires manual interaction")
        
        # Setup paths
        generated_dir = Path("Generated")
        images_dir = Path("Images")
        images_dir.mkdir(exist_ok=True)
        
        # Get all HTML files
        html_files = list(generated_dir.glob("*.html"))
        
        print("\n📋 Instructions:")
        print("1. Each HTML file will open in your browser")
        print("2. Press F12 to open DevTools")
        print("3. Press Ctrl+Shift+M for responsive mode")
        print("4. Set size to 1200x628px")
        print("5. Press Ctrl+Shift+P and type 'screenshot'")
        print("6. Select 'Capture full size screenshot'")
        print("7. Save with the same name as HTML file")
        print("\nPress Enter to start...")
        input()
        
        for html_file in html_files:
            file_url = f"file:///{html_file.resolve()}".replace('\\', '/')
            print(f"\n📂 Opening: {html_file.name}")
            print(f"💾 Save as: {html_file.stem}.png")
            webbrowser.open(file_url)
            input("Press Enter after saving the screenshot...")
        
        print("\n✨ Manual conversion complete!")
        return True
        
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

# Main conversion function
def convert_all_infographics():
    """Main function to convert all infographics"""
    print("=" * 60)
    print("🎨 CAR INSURANCE CALCULATOR INFOGRAPHICS CONVERTER")
    print("=" * 60)
    print("\nSelect conversion method:")
    print("1. html2image (Recommended - Automatic)")
    print("2. Selenium WebDriver (Requires Chrome)")
    print("3. wkhtmltoimage (Requires installation)")
    print("4. Manual Browser Screenshots")
    print("5. Try all methods automatically")
    
    choice = input("\nEnter your choice (1-5): ").strip()
    
    success = False
    
    if choice == "1":
        success = convert_with_html2image()
    elif choice == "2":
        success = convert_with_selenium()
    elif choice == "3":
        success = convert_with_wkhtmltoimage()
    elif choice == "4":
        success = convert_with_browser_automation()
    elif choice == "5":
        # Try all methods in order
        methods = [
            ("html2image", convert_with_html2image),
            ("Selenium", convert_with_selenium),
            ("wkhtmltoimage", convert_with_wkhtmltoimage),
        ]
        
        for method_name, method_func in methods:
            print(f"\n🔄 Trying {method_name}...")
            success = method_func()
            if success:
                break
        
        if not success:
            print("\n⚠️  All automatic methods failed. Try manual conversion:")
            success = convert_with_browser_automation()
    else:
        print("❌ Invalid choice!")
        return convert_all_infographics()
    
    if success:
        print("\n" + "=" * 60)
        print("✅ CONVERSION COMPLETE!")
        print("=" * 60)
        optimize_images()
    else:
        print("\n❌ Conversion failed. Please try another method.")

# Image optimization function
def optimize_images():
    """Optimize images for web"""
    try:
        from PIL import Image
        import os
        
        print("\n📦 Starting image optimization...")
        
        images_dir = Path("Images")
        optimized_dir = Path("Optimized")
        optimized_dir.mkdir(exist_ok=True)
        
        # Get all PNG files
        png_files = list(images_dir.glob("*.png"))
        
        if not png_files:
            print("❌ No images found to optimize")
            return
        
        total_size_before = 0
        total_size_after = 0
        
        for png_file in png_files:
            # Open image
            img = Image.open(png_file)
            
            # Get original size
            original_size = os.path.getsize(png_file)
            total_size_before += original_size
            
            # Save optimized version
            output_path = optimized_dir / png_file.name
            
            # Convert to RGB if needed (removes alpha channel)
            if img.mode in ('RGBA', 'LA'):
                background = Image.new('RGB', img.size, (255, 255, 255))
                background.paste(img, mask=img.split()[-1] if img.mode == 'RGBA' else None)
                img = background
            
            # Save with optimization
            img.save(output_path, "PNG", optimize=True, quality=85)
            
            # Get optimized size
            optimized_size = os.path.getsize(output_path)
            total_size_after += optimized_size
            
            reduction = (1 - optimized_size/original_size) * 100
            print(f"✅ {png_file.name}: {original_size//1024}KB → {optimized_size//1024}KB (-{reduction:.1f}%)")
        
        total_reduction = (1 - total_size_after/total_size_before) * 100
        print(f"\n📊 Total size reduction: {total_size_before//1024}KB → {total_size_after//1024}KB (-{total_reduction:.1f}%)")
        print(f"📁 Optimized images saved in: {optimized_dir.resolve()}")
        
    except ImportError:
        print("❌ Pillow not installed. Installing...")
        os.system("pip install Pillow")
        optimize_images()
    except Exception as e:
        print(f"❌ Error optimizing images: {e}")

if __name__ == "__main__":
    # Change to the correct directory
    os.chdir(Path(__file__).parent)
    convert_all_infographics()