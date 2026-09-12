#!/bin/bash

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Create orange theme translation icon
# iBooks style with transparent highlight effect

echo "Creating orange theme translation icon..."

# Create temporary directory
TEMP_DIR="/tmp/cd_icon_orange"
mkdir -p "$TEMP_DIR"

# Create icons using Python
python3 << 'PYTHON'
from PIL import Image, ImageDraw, ImageFont
import math
import os

# Create 1024x1024 image
size = 1024
img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)

# ===== Draw a rounded rectangular background (orange gradient) =====
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
            # linear gradient from top to bottom: light orange to dark orange
            ratio = y / size
            # bright orange (255, 179, 71) to dark orange (238, 123, 38)
            r = int(255 - (255 - 238) * ratio)
            g = int(179 - (179 - 123) * ratio)
            b = int(71 - (71 - 38) * ratio)
            img.putpixel((x, y), (r, g, b, 255))

# ===== Draw glass-textured speech bubbles (higher on the left and lower on the right, wider spacing) =====
center_x = size // 2
center_y = size // 2

# left bubble (higher, further to the left)
bubble_left_x = center_x - 240  # Increase spacing
bubble_left_y = center_y - 100
bubble_size_left = 200

# Draw bubbles on the left - with glass texture
for y in range(bubble_left_y - bubble_size_left, bubble_left_y + bubble_size_left):
    for x in range(bubble_left_x - bubble_size_left, bubble_left_x + bubble_size_left):
        if 0 <= x < size and 0 <= y < size:
            dist = math.sqrt((x - bubble_left_x) ** 2 + (y - bubble_left_y) ** 2)
            if dist <= bubble_size_left:
                # White translucent bubbles with more transparent edges
                base_alpha = int(200 * (1 - dist / bubble_size_left * 0.2))

                # Add top highlight effect (glass texture)
                highlight_offset = y - (bubble_left_y - bubble_size_left)
                if highlight_offset < bubble_size_left * 0.5:
                    # The top is brighter
                    brightness = 1.0 + (1 - highlight_offset / (bubble_size_left * 0.5)) * 0.3
                    alpha = min(int(base_alpha * brightness), 255)
                else:
                    alpha = base_alpha

                img.putpixel((x, y), (255, 255, 255, alpha))

# Left bubble tail
tail_left = [
    (bubble_left_x - 70, bubble_left_y + 110),
    (bubble_left_x - 110, bubble_left_y + 170),
    (bubble_left_x - 40, bubble_left_y + 120)
]
draw.polygon(tail_left, fill=(255, 255, 255, 200))

# Bubble on the right (lower, further to the right)
bubble_right_x = center_x + 240  # Increase spacing
bubble_right_y = center_y + 100
bubble_size_right = 200

# Draw bubbles on the right - with glass texture
for y in range(bubble_right_y - bubble_size_right, bubble_right_y + bubble_size_right):
    for x in range(bubble_right_x - bubble_size_right, bubble_right_x + bubble_size_right):
        if 0 <= x < size and 0 <= y < size:
            dist = math.sqrt((x - bubble_right_x) ** 2 + (y - bubble_right_y) ** 2)
            if dist <= bubble_size_right:
                base_alpha = int(200 * (1 - dist / bubble_size_right * 0.2))

                # Add top highlight effect
                highlight_offset = y - (bubble_right_y - bubble_size_right)
                if highlight_offset < bubble_size_right * 0.5:
                    brightness = 1.0 + (1 - highlight_offset / (bubble_size_right * 0.5)) * 0.3
                    alpha = min(int(base_alpha * brightness), 255)
                else:
                    alpha = base_alpha

                img.putpixel((x, y), (255, 255, 255, alpha))

# Small bubble tail on the right side
tail_right = [
    (bubble_right_x + 70, bubble_right_y + 90),
    (bubble_right_x + 110, bubble_right_y + 150),
    (bubble_right_x + 40, bubble_right_y + 100)
]
draw.polygon(tail_right, fill=(255, 255, 255, 200))

# ===== Draw a translation arrow in the middle of the bubble (with glass effect) =====
arrow_center_x = center_x
arrow_center_y = center_y

# Arrow background circle - glass effect
for y in range(arrow_center_y - 65, arrow_center_y + 65):
    for x in range(arrow_center_x - 65, arrow_center_x + 65):
        if 0 <= x < size and 0 <= y < size:
            dist = math.sqrt((x - arrow_center_x) ** 2 + (y - arrow_center_y) ** 2)
            if dist <= 65:
                base_alpha = 220
                # Top highlight
                highlight_offset = y - (arrow_center_y - 65)
                if highlight_offset < 50:
                    brightness = 1.0 + (1 - highlight_offset / 50) * 0.2
                    alpha = min(int(base_alpha * brightness), 255)
                else:
                    alpha = base_alpha
                img.putpixel((x, y), (255, 255, 255, alpha))

# Draw arrows
arrow_points = [
    (arrow_center_x - 28, arrow_center_y - 11),
    (arrow_center_x + 18, arrow_center_y - 11),
    (arrow_center_x + 18, arrow_center_y - 28),
    (arrow_center_x + 50, arrow_center_y),
    (arrow_center_x + 18, arrow_center_y + 28),
    (arrow_center_x + 18, arrow_center_y + 11),
    (arrow_center_x - 28, arrow_center_y + 11)
]
draw.polygon(arrow_points, fill=(255, 140, 40, 255))

# ===== Write "A" in the left bubble =====
font_letter = None
english_fonts = [
    "/System/Library/Fonts/SFNS.ttf",
    "/System/Library/Fonts/SFNSDisplay.ttf",
    "/System/Library/Fonts/Helvetica.ttc",
]

for font_path in english_fonts:
    if os.path.exists(font_path):
        try:
            font_letter = ImageFont.truetype(font_path, 220)
            break
        except:
            continue

if not font_letter:
    font_letter = ImageFont.load_default()

text_a = "A"
bbox_a = draw.textbbox((0, 0), text_a, font=font_letter)
text_width_a = bbox_a[2] - bbox_a[0]
text_height_a = bbox_a[3] - bbox_a[1]
a_x = bubble_left_x - text_width_a // 2 - bbox_a[0]
a_y = bubble_left_y - text_height_a // 2 - bbox_a[1]

# Add text shadow (dark orange)
draw.text((a_x + 3, a_y + 3), text_a, fill=(200, 100, 30, 100), font=font_letter)
# Draw main text (dark orange)
draw.text((a_x, a_y), text_a, fill=(230, 110, 40, 255), font=font_letter)

# Draw the English language label in the right bubble.
font_chinese = None
chinese_fonts = [
    "/System/Library/Fonts/Hiragino Sans GB.ttc",
    "/System/Library/Fonts/PingFang.ttc",
    "/System/Library/Fonts/STHeiti Medium.ttc",
]

for font_path in chinese_fonts:
    if os.path.exists(font_path):
        try:
            font_chinese = ImageFont.truetype(font_path, 200)
            break
        except:
            continue

if not font_chinese:
    font_chinese = font_letter

text_zh = "EN"
bbox_zh = draw.textbbox((0, 0), text_zh, font=font_chinese)
text_width_zh = bbox_zh[2] - bbox_zh[0]
text_height_zh = bbox_zh[3] - bbox_zh[1]
zh_x = bubble_right_x - text_width_zh // 2 - bbox_zh[0]
zh_y = bubble_right_y - text_height_zh // 2 - bbox_zh[1]

# Add text shadow
draw.text((zh_x + 3, zh_y + 3), text_zh, fill=(200, 100, 30, 100), font=font_chinese)
# Draw main text
draw.text((zh_x, zh_y), text_zh, fill=(230, 110, 40, 255), font=font_chinese)

# Save
output_path = "/tmp/cd_icon_orange/icon_1024.png"
img.save(output_path, 'PNG')
print(f"✅ Orange theme icon has been created: {output_path}")
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
echo "✅ The orange theme icon is created!"
echo ""
echo "Design description:"
echo "  • Orange gradient background (imitation of iBooks)"
echo "  • Glass texture bubbles (top highlight)"
echo "  • The distance between the two bubbles increases"
echo "  • Left high right low layout"
echo "  • Dark orange text"
echo ""
echo "File location:"
echo "  - ICNS file: ${PROJECT_DIR}/AppIcon.icns"
echo "  - Preview image: ${PROJECT_DIR}/icon_preview.png"
echo ""
