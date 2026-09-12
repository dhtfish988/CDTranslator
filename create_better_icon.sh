#!/bin/bash

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Create better-looking CD translation icons
# Only keep the big CD letters and remove the small letters

echo "Creating new CD translation icon..."

# Create temporary directory
TEMP_DIR="/tmp/cd_icon_new"
mkdir -p "$TEMP_DIR"

# Create SVG Icons - Big CD letters, modern gradient design
cat > "$TEMP_DIR/icon.svg" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<svg width="1024" height="1024" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <!-- Background gradient: blue to purple -->
    <linearGradient id="bgGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#4A90E2;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#7B68EE;stop-opacity:1" />
    </linearGradient>

    <!-- Text gradient: white to light blue -->
    <linearGradient id="textGrad" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" style="stop-color:#FFFFFF;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#E3F2FD;stop-opacity:0.95" />
    </linearGradient>
  </defs>

  <!-- Rounded rectangle background -->
  <rect width="1024" height="1024" rx="230" ry="230" fill="url(#bgGrad)"/>

  <!-- CD Text - Large, centered -->
  <text x="512" y="620"
        font-family="SF Pro Display, -apple-system, BlinkMacSystemFont, Arial, sans-serif"
        font-size="420"
        font-weight="900"
        text-anchor="middle"
        fill="url(#textGrad)"
        letter-spacing="-10">CD</text>
</svg>
EOF

echo "✅ SVG icon created"

# Convert SVG to PNG (1024x1024)
echo "Converting SVG to PNG..."
qlmanage -t -s 1024 -o "$TEMP_DIR" "$TEMP_DIR/icon.svg" 2>/dev/null
mv "$TEMP_DIR/icon.svg.png" "$TEMP_DIR/icon_1024.png" 2>/dev/null

# Create from SVG using sips if qlmanage fails
if [ ! -f "$TEMP_DIR/icon_1024.png" ]; then
    echo "Use alternate method to create PNG..."
    # Create an easy way: directly with ImageMagick or other tools
    # Here we create a basic PNG
    python3 << 'PYTHON'
from PIL import Image, ImageDraw, ImageFont
import os

# Create 1024x1024 image
size = 1024
img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)

# Draw a rounded rectangular background (gradient effect)
for y in range(size):
    for x in range(size):
        # Calculate whether it is within a rounded rectangle
        rx, ry = 230, 230  # Corner radius
        in_rect = False

        # Judgment of rounded corners of four corners
        if x < rx and y < ry:  # Upper left corner
            if (x - rx) ** 2 + (y - ry) ** 2 <= rx ** 2:
                in_rect = True
        elif x > size - rx and y < ry:  # Upper right corner
            if (x - (size - rx)) ** 2 + (y - ry) ** 2 <= rx ** 2:
                in_rect = True
        elif x < rx and y > size - ry:  # Lower left corner
            if (x - rx) ** 2 + (y - (size - ry)) ** 2 <= rx ** 2:
                in_rect = True
        elif x > size - rx and y > size - ry:  # Lower right corner
            if (x - (size - rx)) ** 2 + (y - (size - ry)) ** 2 <= rx ** 2:
                in_rect = True
        elif rx <= x <= size - rx or ry <= y <= size - ry:
            in_rect = True

        if in_rect:
            # Calculate gradient color (from blue to purple)
            ratio = (x + y) / (2 * size)
            r = int(74 + (123 - 74) * ratio)
            g = int(144 + (104 - 144) * ratio)
            b = int(226 + (238 - 226) * ratio)
            img.putpixel((x, y), (r, g, b, 255))

# Add text "CD"
try:
    # Try using system fonts
    font = ImageFont.truetype("/System/Library/Fonts/SFNSDisplay.ttf", 380)
except:
    try:
        font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 380)
    except:
        font = ImageFont.load_default()

text = "CD"
# Get text bounding box
bbox = draw.textbbox((0, 0), text, font=font)
text_width = bbox[2] - bbox[0]
text_height = bbox[3] - bbox[1]

# Draw text in the center
x = (size - text_width) // 2 - bbox[0]
y = (size - text_height) // 2 - bbox[1] - 40 # Offset slightly upward

# Draw white text
draw.text((x, y), text, fill=(255, 255, 255, 255), font=font)

# Save
output_path = "/tmp/cd_icon_new/icon_1024.png"
img.save(output_path, 'PNG')
print(f"✅ Created PNG icon: {output_path}")
PYTHON
fi

# Create iconset directory
ICONSET="$TEMP_DIR/AppIcon.iconset"
mkdir -p "$ICONSET"

# Generate all required sizes
echo "Generating all icon sizes..."

sizes=(16 32 64 128 256 512)

for size in "${sizes[@]}"; do
    sips -z $size $size "$TEMP_DIR/icon_1024.png" --out "$ICONSET/icon_${size}x${size}.png" > /dev/null 2>&1

    # Generate @2x version
    size2x=$((size * 2))
    sips -z $size2x $size2x "$TEMP_DIR/icon_1024.png" --out "$ICONSET/icon_${size}x${size}@2x.png" > /dev/null 2>&1
done

# Create .icns file
echo "Creating .icns file..."
iconutil -c icns "$ICONSET" -o "$TEMP_DIR/AppIcon.icns"

# Copy to project directory
cp "$TEMP_DIR/AppIcon.icns" "${PROJECT_DIR}/AppIcon.icns"
cp "$TEMP_DIR/icon_1024.png" "${PROJECT_DIR}/icon_preview.png"

echo ""
echo "✅ New icon created!"
echo ""
echo "File location:"
echo "  - ICNS file: ${PROJECT_DIR}/AppIcon.icns"
echo "  - Preview image: ${PROJECT_DIR}/icon_preview.png"
echo ""
echo "Now run the following command to recompile the application:"
echo "  cd ${PROJECT_DIR}"
echo "  ./build_cd.sh"
echo ""
