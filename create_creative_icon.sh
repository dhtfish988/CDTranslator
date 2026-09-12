#!/bin/bash

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Create creative CD translation icons
# Design concept: Earth/speech bubble + CD brand

echo "Creating creative version CD translation icon..."

# Create temporary directory
TEMP_DIR="/tmp/cd_icon_creative"
mkdir -p "$TEMP_DIR"

# Create creative icons using Python
python3 << 'PYTHON'
from PIL import Image, ImageDraw, ImageFont
import math

# Create 1024x1024 image
size = 1024
img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)

# ===== Draw a rounded rectangular background (gradient effect) =====
for y in range(size):
    for x in range(size):
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
            # Radial gradient: from center outward
            center_x, center_y = size // 2, size // 2
            dist = math.sqrt((x - center_x) ** 2 + (y - center_y) ** 2)
            max_dist = math.sqrt(center_x ** 2 + center_y ** 2)
            ratio = min(dist / max_dist, 1.0)

            # From bright blue to deep purple
            r = int(100 + (90 - 100) * ratio)
            g = int(180 + (80 - 180) * ratio)
            b = int(255 + (200 - 255) * ratio)
            img.putpixel((x, y), (r, g, b, 255))

# ===== Draw a combination of speech bubbles (indicating language translation) =====
center_x, center_y = size // 2, size // 2 - 50

# left bubble (blue - source language)
bubble_left_x = center_x - 180
bubble_left_y = center_y - 30
bubble_size = 140

# Draw a circular bubble on the left
for y in range(bubble_left_y - bubble_size, bubble_left_y + bubble_size):
    for x in range(bubble_left_x - bubble_size, bubble_left_x + bubble_size):
        if 0 <= x < size and 0 <= y < size:
            dist = math.sqrt((x - bubble_left_x) ** 2 + (y - bubble_left_y) ** 2)
            if dist <= bubble_size:
                # translucent white bubbles
                alpha = int(200 * (1 - dist / bubble_size * 0.3))
                img.putpixel((x, y), (255, 255, 255, alpha))

# Left bubble tail
tail_left = [
    (bubble_left_x - 60, bubble_left_y + 80),
    (bubble_left_x - 90, bubble_left_y + 120),
    (bubble_left_x - 40, bubble_left_y + 90)
]
draw.polygon(tail_left, fill=(255, 255, 255, 180))

# Right bubble (slightly different position - target language)
bubble_right_x = center_x + 180
bubble_right_y = center_y + 30

# Draw a circular bubble on the right
for y in range(bubble_right_y - bubble_size, bubble_right_y + bubble_size):
    for x in range(bubble_right_x - bubble_size, bubble_right_x + bubble_size):
        if 0 <= x < size and 0 <= y < size:
            dist = math.sqrt((x - bubble_right_x) ** 2 + (y - bubble_right_y) ** 2)
            if dist <= bubble_size:
                alpha = int(200 * (1 - dist / bubble_size * 0.3))
                img.putpixel((x, y), (255, 255, 255, alpha))

# Small bubble tail on the right side
tail_right = [
    (bubble_right_x + 60, bubble_right_y + 80),
    (bubble_right_x + 90, bubble_right_y + 120),
    (bubble_right_x + 40, bubble_right_y + 90)
]
draw.polygon(tail_right, fill=(255, 255, 255, 180))

# ===== Draw a translation arrow in the middle of the bubble =====
arrow_center_y = center_y

# Arrow body (thicker and more obvious)
draw.ellipse(
    [center_x - 50, arrow_center_y - 50, center_x + 50, arrow_center_y + 50],
    fill=(255, 255, 255, 230)
)

# Draw circular arrow symbol
arrow_points_right = [
    (center_x - 20, arrow_center_y - 8),
    (center_x + 10, arrow_center_y - 8),
    (center_x + 10, arrow_center_y - 20),
    (center_x + 35, arrow_center_y),
    (center_x + 10, arrow_center_y + 20),
    (center_x + 10, arrow_center_y + 8),
    (center_x - 20, arrow_center_y + 8)
]
draw.polygon(arrow_points_right, fill=(100, 150, 255, 255))

# ===== Write "A" (representing source language) in the left bubble =====
try:
    font_bubble = ImageFont.truetype("/System/Library/Fonts/SFNSDisplay.ttf", 100)
except:
    try:
        font_bubble = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 100)
    except:
        font_bubble = ImageFont.load_default()

draw.text((bubble_left_x - 25, bubble_left_y - 50), "A", fill=(70, 130, 220, 255), font=font_bubble)

# Draw the English language label in the right bubble.
try:
    font_chinese = ImageFont.truetype("/System/Library/Fonts/PingFang.ttc", 90)
except:
    font_chinese = font_bubble

draw.text((bubble_right_x - 35, bubble_right_y - 45), "EN", fill=(70, 130, 220, 255), font=font_chinese)

# ===== Draw the CD brand logo at the bottom =====
try:
    font_brand = ImageFont.truetype("/System/Library/Fonts/SFNSDisplay.ttf", 180)
except:
    font_brand = font_bubble

cd_text = "CD"
bbox = draw.textbbox((0, 0), cd_text, font=font_brand)
text_width = bbox[2] - bbox[0]
cd_x = (size - text_width) // 2 - bbox[0]
cd_y = size - 240

# Add text shadow effect
draw.text((cd_x + 4, cd_y + 4), cd_text, fill=(0, 0, 0, 80), font=font_brand)
draw.text((cd_x, cd_y), cd_text, fill=(255, 255, 255, 255), font=font_brand)

# Save
output_path = "/tmp/cd_icon_creative/icon_1024.png"
img.save(output_path, 'PNG')
print(f"✅ Creative icon created: {output_path}")
PYTHON

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
echo "✅ Creative icon creation completed!"
echo ""
echo "Design description:"
echo "  • Speech bubbles - indicates verbal communication"
echo "  • A+EN - indicates multi-language translation"
echo "  • Middle arrow - indicates the conversion process"
echo "  • CD brand - clearly marked on the bottom"
echo "  • Gradient background - professional modern style"
echo ""
echo "File location:"
echo "  - ICNS file: ${PROJECT_DIR}/AppIcon.icns"
echo "  - Preview image: ${PROJECT_DIR}/icon_preview.png"
echo ""
