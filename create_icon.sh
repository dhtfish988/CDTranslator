#!/bin/bash

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Create application icon
# CDTranslator - a simple translation icon

ICON_DIR="${PROJECT_DIR}/icon_temp"
mkdir -p "$ICON_DIR"

# Create icons of different sizes using sips
# We first create a 1024x1024 PNG icon, and then generate other sizes

cat > "$ICON_DIR/create_base_icon.py" << 'PYTHON_SCRIPT'
from PIL import Image, ImageDraw, ImageFont
import os

# Create 1024x1024 icon
size = 1024
img = Image.new('RGBA', (size, size), (255, 255, 255, 0))
draw = ImageDraw.Draw(img)

# Background gradient color (blue to purple)
for i in range(size):
    color_r = int(66 + (138 - 66) * i / size)
    color_g = int(133 + (43 - 133) * i / size)
    color_b = int(244 + (226 - 244) * i / size)
    draw.rectangle([(0, i), (size, i+1)], fill=(color_r, color_g, color_b, 255))

# Add rounded corners
mask = Image.new('L', (size, size), 0)
mask_draw = ImageDraw.Draw(mask)
mask_draw.rounded_rectangle([(0, 0), (size, size)], radius=180, fill=255)
img.putalpha(mask)

# Draw "CD" text
try:
    # Try using system fonts
    font_size = 420
    font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", font_size)
except:
    font = ImageFont.load_default()

text = "CD"
# Get text boundary
bbox = draw.textbbox((0, 0), text, font=font)
text_width = bbox[2] - bbox[0]
text_height = bbox[3] - bbox[1]

# Draw text in the center
x = (size - text_width) // 2 - bbox[0]
y = (size - text_height) // 2 - bbox[1] - 20

# Text shadow
draw.text((x+4, y+4), text, font=font, fill=(0, 0, 0, 80))
# Main text
draw.text((x, y), text, font=font, fill=(255, 255, 255, 255))

# Small text "Translation" at the bottom
try:
    small_font = ImageFont.truetype("/System/Library/Fonts/PingFang.ttc", 120)
except:
    small_font = ImageFont.load_default()

small_text = "EN"
bbox2 = draw.textbbox((0, 0), small_text, font=small_font)
small_width = bbox2[2] - bbox2[0]
small_x = (size - small_width) // 2 - bbox2[0]
small_y = size - 200

draw.text((small_x+2, small_y+2), small_text, font=small_font, fill=(0, 0, 0, 60))
draw.text((small_x, small_y), small_text, font=small_font, fill=(255, 255, 255, 220))

# Save
output_dir = os.path.dirname(os.path.abspath(__file__))
img.save(os.path.join(output_dir, 'icon_1024.png'))
print("Icon created successfully!")
PYTHON_SCRIPT

# Check if Python and Pillow are installed
if command -v python3 &> /dev/null; then
    echo "Creating icon..."
    cd "$ICON_DIR"

    # Install Pillow
    python3 -m pip install Pillow --quiet --user 2>/dev/null || true

    # Run script to create basic icons
    python3 create_base_icon.py

    if [ -f "icon_1024.png" ]; then
        echo "✅ Basic icon created successfully"

        # Create iconset directory
        ICONSET="AppIcon.iconset"
        mkdir -p "$ICONSET"

        # Generate icons of different sizes
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

        # Generate .icns file
        iconutil -c icns "$ICONSET" -o AppIcon.icns

        if [ -f "AppIcon.icns" ]; then
            echo "✅ The icon file was generated successfully: AppIcon.icns"
            cp AppIcon.icns "${PROJECT_DIR}/"
            echo "✅ The icon has been copied to the project directory"
        else
            echo "❌ Failed to generate .icns file"
        fi
    else
        echo "❌ Failed to create basic icon"
    fi
else
    echo "❌ Python3 not found, unable to create icon"
    echo "Use simple text icon replacement..."
fi

echo ""
echo "================================"
echo "Icon creation completed"
echo "================================"
