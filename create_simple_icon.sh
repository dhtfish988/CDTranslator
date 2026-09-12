#!/bin/bash

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

echo "Creating CDTranslator icon..."

ICON_DIR="${PROJECT_DIR}/icon_temp"
mkdir -p "$ICON_DIR"
cd "$ICON_DIR"

# Create a simple SVG icon
cat > icon.svg << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<svg width="1024" height="1024" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="bg" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" style="stop-color:#4285F4;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#8A2BE2;stop-opacity:1" />
    </linearGradient>
  </defs>

  <!-- Rounded rectangle background -->
  <rect width="1024" height="1024" rx="180" fill="url(#bg)"/>

  <!-- CD Text shadow -->
  <text x="512" y="580" font-family="Helvetica, Arial, sans-serif" font-size="420" font-weight="bold" text-anchor="middle" fill="rgba(0,0,0,0.2)">CD</text>

  <!-- CD Text -->
  <text x="512" y="576" font-family="Helvetica, Arial, sans-serif" font-size="420" font-weight="bold" text-anchor="middle" fill="white">CD</text>

  <!-- Translate text shadow -->
  <text x="512" y="832" font-family="PingFang SC, Helvetica, sans-serif" font-size="100" text-anchor="middle" fill="rgba(0,0,0,0.15)">EN</text>

  <!-- Translate text -->
  <text x="512" y="828" font-family="PingFang SC, Helvetica, sans-serif" font-size="100" text-anchor="middle" fill="rgba(255,255,255,0.9)">EN</text>
</svg>
EOF

echo "✅ SVG icon created successfully"

# Convert SVG to PNG
if command -v qlmanage &> /dev/null; then
    # Use qlmanage to generate previews
    qlmanage -t -s 1024 -o . icon.svg > /dev/null 2>&1

    if [ -f "icon.svg.png" ]; then
        mv icon.svg.png icon_1024.png
        echo "✅ PNG icon generated successfully"
    fi
fi

# If the above method does not work, try using sips from PDF
if [ ! -f "icon_1024.png" ] && command -v rsvg-convert &> /dev/null; then
    rsvg-convert -w 1024 -h 1024 icon.svg -o icon_1024.png 2>/dev/null
    echo "✅ PNG icon generated successfully"
fi

# If it still doesn’t exist, manually create it using system commands.
if [ ! -f "icon_1024.png" ]; then
    echo "Use alternate methods to create icons..."

    # Create solid color icons
    cat > create_fallback.sh << 'FALLBACK'
#!/bin/bash
# Use ImageMagick or other tools
# Here we create a simple gradient background
convert -size 1024x1024 gradient:"#4285F4"-"#8A2BE2" \
    \( -size 1024x1024 xc:none -draw "roundrectangle 0,0,1024,1024,180,180" \) \
    -alpha set -compose DstIn -composite \
    -gravity center -pointsize 420 -font Helvetica-Bold -fill white -annotate +0-50 "CD" \
    -gravity center -pointsize 100 -font PingFang-SC-Regular -fill "rgba(255,255,255,0.9)" -annotate +0+350 "Translation" \
    icon_1024.png 2>/dev/null
FALLBACK

    chmod +x create_fallback.sh
    ./create_fallback.sh 2>/dev/null || true
fi

# Check if PNG was created successfully
if [ -f "icon_1024.png" ]; then
    echo "✅ Basic icon created successfully"

    # Create iconset
    ICONSET="AppIcon.iconset"
    mkdir -p "$ICONSET"

    echo "Generating icons of different sizes..."

    # Generate all required sizes
    sips -z 16 16     icon_1024.png --out "$ICONSET/icon_16x16.png" > /dev/null 2>&1
    sips -z 32 32     icon_1024.png --out "$ICONSET/icon_16x16@2x.png" > /dev/null 2>&1
    sips -z 32 32     icon_1024.png --out "$ICONSET/icon_32x32.png" > /dev/null 2>&1
    sips -z 64 64     icon_1024.png --out "$ICONSET/icon_32x32@2x.png" > /dev/null 2>&1
    sips -z 128 128   icon_1024.png --out "$ICONSET/icon_128x128.png" > /dev/null 2>&1
    sips -z 256 256   icon_1024.png --out "$ICONSET/icon_128x128@2x.png" > /dev/null 2>&1
    sips -z 256 256   icon_1024.png --out "$ICONSET/icon_256x256.png" > /dev/null 2>&1
    sips -z 512 512   icon_1024.png --out "$ICONSET/icon_256x256@2x.png" > /dev/null 2>&1
    sips -z 512 512   icon_1024.png --out "$ICONSET/icon_512x512.png" > /dev/null 2>&1
    sips -z 1024 1024 icon_1024.png --out "$ICONSET/icon_512x512@2x.png" > /dev/null 2>&1

    echo "✅ Icons of various sizes are generated successfully"

    # Generate .icns file
    iconutil -c icns "$ICONSET" -o AppIcon.icns 2>/dev/null

    if [ -f "AppIcon.icns" ]; then
        echo "✅ .icns file generated successfully"
        cp AppIcon.icns "${PROJECT_DIR}/"
        cp icon_1024.png "${PROJECT_DIR}/icon_preview.png"
        echo "✅ The icon has been copied to the project directory"
    else
        echo "⚠️ .icns generation failed, but PNG icon available"
    fi
else
    echo "❌ Unable to create icon"
    echo "Please create the icon manually or use online tools"
fi

echo ""
echo "================================"
echo "Icon creation completed"
echo "================================"
