#!/bin/bash

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Create enlarged version of CD translation icon
# The words in the bubble are bigger, and the CD brand is also bigger.

echo "Creating a larger version of the CD translation icon..."

# Create temporary directory
TEMP_DIR="/tmp/cd_icon_bigger"
mkdir -p "$TEMP_DIR"

# Create icons using Python
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
center_x, center_y = size // 2, size // 2 - 80

# left bubble (source language)
bubble_left_x = center_x - 200
bubble_left_y = center_y
bubble_size = 160

# Draw a circular bubble on the left
for y in range(bubble_left_y - bubble_size, bubble_left_y + bubble_size):
    for x in range(bubble_left_x - bubble_size, bubble_left_x + bubble_size):
        if 0 <= x < size and 0 <= y < size:
            dist = math.sqrt((x - bubble_left_x) ** 2 + (y - bubble_left_y) ** 2)
            if dist <= bubble_size:
                # white bubbles
                alpha = int(220 * (1 - dist / bubble_size * 0.2))
                img.putpixel((x, y), (255, 255, 255, alpha))

# Right bubble (target language)
bubble_right_x = center_x + 200
bubble_right_y = center_y

# Draw a circular bubble on the right
for y in range(bubble_right_y - bubble_size, bubble_right_y + bubble_size):
    for x in range(bubble_right_x - bubble_size, bubble_right_x + bubble_size):
        if 0 <= x < size and 0 <= y < size:
            dist = math.sqrt((x - bubble_right_x) ** 2 + (y - bubble_right_y) ** 2)
            if dist <= bubble_size:
                alpha = int(220 * (1 - dist / bubble_size * 0.2))
                img.putpixel((x, y), (255, 255, 255, alpha))

# ===== Draw a translation arrow in the middle of the bubble =====
arrow_center_y = center_y

# Arrow background circle
draw.ellipse(
    [center_x - 60, arrow_center_y - 60, center_x + 60, arrow_center_y + 60],
    fill=(255, 255, 255, 240)
)

# Draw larger arrows
arrow_points = [
    (center_x - 25, arrow_center_y - 10),
    (center_x + 15, arrow_center_y - 10),
    (center_x + 15, arrow_center_y - 25),
    (center_x + 45, arrow_center_y),
    (center_x + 15, arrow_center_y + 25),
    (center_x + 15, arrow_center_y + 10),
    (center_x - 25, arrow_center_y + 10)
]
draw.polygon(arrow_points, fill=(80, 140, 255, 255))

# ===== Write a very large "A" in the left bubble =====
try:
    font_letter = ImageFont.truetype("/System/Library/Fonts/SFNSDisplay.ttf", 180)
except:
    try:
        font_letter = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 180)
    except:
        font_letter = ImageFont.load_default()

# Calculate the position of A (centered)
text_a = "A"
bbox_a = draw.textbbox((0, 0), text_a, font=font_letter)
text_width_a = bbox_a[2] - bbox_a[0]
text_height_a = bbox_a[3] - bbox_a[1]
a_x = bubble_left_x - text_width_a // 2 - bbox_a[0]
a_y = bubble_left_y - text_height_a // 2 - bbox_a[1]

draw.text((a_x, a_y), text_a, fill=(60, 120, 220, 255), font=font_letter)

# Draw the English language label in the right bubble.
try:
    font_chinese = ImageFont.truetype("/System/Library/Fonts/PingFang.ttc", 160)
except:
    font_chinese = font_letter

text_wen = "EN"
bbox_wen = draw.textbbox((0, 0), text_wen, font=font_chinese)
text_width_wen = bbox_wen[2] - bbox_wen[0]
text_height_wen = bbox_wen[3] - bbox_wen[1]
wen_x = bubble_right_x - text_width_wen // 2 - bbox_wen[0]
wen_y = bubble_right_y - text_height_wen // 2 - bbox_wen[1]

draw.text((wen_x, wen_y), text_wen, fill=(60, 120, 220, 255), font=font_chinese)

# ===== Draw extra large CD branding at the bottom =====
try:
    font_brand = ImageFont.truetype("/System/Library/Fonts/SFNSDisplay.ttf", 280)
except:
    font_brand = font_letter

cd_text = "CD"
bbox_cd = draw.textbbox((0, 0), cd_text, font=font_brand)
text_width_cd = bbox_cd[2] - bbox_cd[0]
text_height_cd = bbox_cd[3] - bbox_cd[1]
cd_x = (size - text_width_cd) // 2 - bbox_cd[0]
cd_y = size - 300

# Add text shadow effect
draw.text((cd_x + 5, cd_y + 5), cd_text, fill=(0, 0, 0, 100), font=font_brand)
# Draw white main text
draw.text((cd_x, cd_y), cd_text, fill=(255, 255, 255, 255), font=font_brand)

# Save
output_path = "/tmp/cd_icon_bigger/icon_1024.png"
img.save(output_path, 'PNG')
print(f"✅ Amplified version icon has been created: {output_path}")
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
echo "✅ The enlarged version of the icon has been created!"
echo ""
echo "Improvement instructions:"
echo "  • Letter A enlarged to 180pt"
echo "  • Text enlarged to 160pt"
echo "  • CD branding enlarged to 280pt"
echo "  • All elements are clearer and more eye-catching"
echo ""
echo "File location:"
echo "  - ICNS file: ${PROJECT_DIR}/AppIcon.icns"
echo "  - Preview image: ${PROJECT_DIR}/icon_preview.png"
echo ""
