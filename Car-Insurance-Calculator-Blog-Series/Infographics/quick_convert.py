"""
Quick HTML to Image Converter using Chrome DevTools
Simple and fast conversion for all 45 infographics
"""

import os
import time
import webbrowser
from pathlib import Path

def open_all_for_manual_conversion():
    """Open all HTML files for manual screenshot conversion"""
    
    print("=" * 60)
    print("🎨 QUICK INFOGRAPHIC CONVERTER")
    print("=" * 60)
    
    # Get all HTML files
    generated_dir = Path("Generated")
    html_files = sorted(generated_dir.glob("*.html"))
    total_files = len(html_files)
    
    print(f"\n📁 Found {total_files} HTML files to convert")
    print("\n" + "=" * 60)
    print("📋 CONVERSION INSTRUCTIONS:")
    print("=" * 60)
    print("\n1. Each HTML file will open in Chrome")
    print("2. For each file, do the following:")
    print("   a) Press F12 to open DevTools")
    print("   b) Press Ctrl+Shift+M for Device Mode")
    print("   c) Set dimensions to: 1200 x 628")
    print("   d) Press Ctrl+Shift+P")
    print("   e) Type 'screenshot' and select 'Capture full size screenshot'")
    print("   f) Save with the same name in Images folder")
    print("\n3. After saving, close the tab and press Enter here")
    
    # Create Images directory
    images_dir = Path("Images")
    images_dir.mkdir(exist_ok=True)
    
    print("\n" + "=" * 60)
    input("Press Enter to start opening files...")
    print()
    
    # Open files in batches of 5
    batch_size = 5
    for i in range(0, total_files, batch_size):
        batch = html_files[i:i+batch_size]
        batch_num = i//batch_size + 1
        total_batches = (total_files + batch_size - 1) // batch_size
        
        print(f"\n📂 BATCH {batch_num}/{total_batches}")
        print("-" * 40)
        
        for j, html_file in enumerate(batch, 1):
            file_url = f"file:///{html_file.resolve()}".replace('\\', '/')
            print(f"{j}. {html_file.name} → {html_file.stem}.png")
            webbrowser.open(file_url)
            time.sleep(0.5)  # Small delay between opens
        
        print("\n💾 Save these files as PNG in the Images folder")
        input("Press Enter after saving this batch...")
    
    print("\n" + "=" * 60)
    print("✅ ALL FILES OPENED!")
    print("=" * 60)
    
    # Check results
    png_files = list(images_dir.glob("*.png"))
    print(f"\n📊 Conversion Results:")
    print(f"   HTML files: {total_files}")
    print(f"   PNG files created: {len(png_files)}")
    
    if len(png_files) == total_files:
        print("\n✨ SUCCESS! All infographics converted!")
    else:
        missing = total_files - len(png_files)
        print(f"\n⚠️  {missing} files still need to be converted")
        
        # Show which files are missing
        html_names = {f.stem for f in html_files}
        png_names = {f.stem for f in png_files}
        missing_files = html_names - png_names
        
        if missing_files:
            print("\nMissing files:")
            for name in sorted(missing_files):
                print(f"   - {name}.html")
    
    print(f"\n📁 Images location: {images_dir.resolve()}")

def create_html_viewer():
    """Create an HTML page to view all infographics at once"""
    
    print("\n🌐 Creating HTML viewer for all infographics...")
    
    generated_dir = Path("Generated")
    html_files = sorted(generated_dir.glob("*.html"))
    
    viewer_content = """<!DOCTYPE html>
<html>
<head>
    <title>All Infographics Viewer</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f0f0f0;
            padding: 20px;
        }
        h1 {
            color: #333;
            text-align: center;
        }
        .container {
            max-width: 1400px;
            margin: 0 auto;
        }
        .infographic-frame {
            margin: 20px 0;
            border: 2px solid #ddd;
            background: white;
            padding: 10px;
            border-radius: 8px;
        }
        .infographic-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 10px;
            color: #0066CC;
        }
        iframe {
            width: 100%;
            height: 650px;
            border: 1px solid #ccc;
        }
        .instructions {
            background: #fffbf0;
            border: 1px solid #ffa500;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎨 Car Insurance Calculator Infographics - All 45 Designs</h1>
        
        <div class="instructions">
            <h3>📋 Screenshot Instructions:</h3>
            <ol>
                <li>Right-click on each infographic below</li>
                <li>Select "Take Screenshot" or use browser extension</li>
                <li>Save as PNG with the filename shown</li>
                <li>Alternatively, use Chrome DevTools (F12) → Device Mode → Screenshot</li>
            </ol>
        </div>
"""
    
    for html_file in html_files:
        file_url = f"Generated/{html_file.name}"
        viewer_content += f"""
        <div class="infographic-frame">
            <div class="infographic-title">📄 {html_file.name} → Save as: {html_file.stem}.png</div>
            <iframe src="{file_url}" frameborder="0"></iframe>
        </div>
"""
    
    viewer_content += """
    </div>
</body>
</html>"""
    
    viewer_path = Path("all_infographics_viewer.html")
    viewer_path.write_text(viewer_content, encoding='utf-8')
    
    print(f"✅ Viewer created: {viewer_path.resolve()}")
    print("\nOpening viewer in browser...")
    
    viewer_url = f"file:///{viewer_path.resolve()}".replace('\\', '/')
    webbrowser.open(viewer_url)
    
    print("\n💡 TIP: You can take screenshots of each infographic from this single page!")

if __name__ == "__main__":
    os.chdir(Path(__file__).parent)
    
    print("\n🎯 Select conversion method:")
    print("1. Open files in batches for manual screenshots")
    print("2. Create single HTML viewer page")
    print("3. Both options")
    
    choice = input("\nEnter choice (1-3): ").strip()
    
    if choice == "1":
        open_all_for_manual_conversion()
    elif choice == "2":
        create_html_viewer()
    elif choice == "3":
        create_html_viewer()
        print("\n" + "=" * 60)
        input("Press Enter to continue with batch opening...")
        open_all_for_manual_conversion()
    else:
        print("Invalid choice!")