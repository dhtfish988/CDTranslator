#!/bin/bash

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Create bubble version of CD translation icon
# Only two big bubbles, high on the left and low on the right, no CD text

echo "Creating bubble version translation icon..."

# Create temporary directory
TEMP_DIR="/tmp/cd_icon_bubble"
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

# ===== Draw super large dialogue bubbles (high on the left and low on the right) =====
center_x = size // 2

# Left bubble (higher, larger)
bubble_left_x = center_x - 180
bubble_left_y = center_y - 120  # The left side is higher
bubble_size_left = 220  # Extra large bubbles

# Draw a circular bubble on the left
for y in range(bubble_left_y - bubble_size_left, bubble_left_y + bubble_size_left):
    for x in range(bubble_left_x - bubble_size_left, bubble_left_x + bubble_size_left):
        if 0 <= x < size and 0 <= y < size:
            dist = math.sqrt((x - bubble_left_x) ** 2 + (y - bubble_left_y) ** 2)
            if dist <= bubble_size_left:
                # White bubbles with soft edges
                alpha = int(240 * (1 - dist / bubble_size_left * 0.15))
                img.putpixel((x, y), (255, 255, 255, alpha))

# Left bubble tail
tail_left = [
    (bubble_left_x - 80, bubble_left_y + 120),
    (bubble_left_x - 120, bubble_left_y + 180),
    (bubble_left_x - 50, bubble_left_y + 130)
]
draw.polygon(tail_left, fill=(255, 255, 255, 230))

# Right bubble (lower, larger)
bubble_right_x = center_x + 180
bubble_right_y = center_y + 80  # The right side is lower
bubble_size_right = 220  # Extra large bubbles

# Draw a circular bubble on the right
for y in range(bubble_right_y - bubble_size_right, bubble_right_y + bubble_size_right):
    for x in range(bubble_right_x - bubble_size_right, bubble_right_x + bubble_size_right):
        if 0 <= x < size and 0 <= y < size:
            dist = math.sqrt((x - bubble_right_x) ** 2 + (y - bubble_right_y) ** 2)
            if dist <= bubble_size_right:
                alpha = int(240 * (1 - dist / bubble_size_right * 0.15))
                img.putpixel((x, y), (255, 255, 255, alpha))

# Small bubble tail on the right side
tail_right = [
    (bubble_right_x + 80, bubble_right_y + 100),
    (bubble_right_x + 120, bubble_right_y + 160),
    (bubble_right_x + 50, bubble_right_y + 110)
]
draw.polygon(tail_right, fill=(255, 255, 255, 230))

# ===== Draw a translation arrow in the middle of the bubble =====
arrow_center_x = center_x
arrow_center_y = center_y - 20

# Arrow background circle (slightly larger)
draw.ellipse(
    [arrow_center_x - 70, arrow_center_y - 70, arrow_center_x + 70, arrow_center_y + 70],
    fill=(255, 255, 255, 250)
)

# Draw larger and clearer arrows
arrow_points = [
    (arrow_center_x - 30, arrow_center_y - 12),
    (arrow_center_x + 20, arrow_center_y - 12),
    (arrow_center_x + 20, arrow_center_y - 30),
    (arrow_center_x + 55, arrow_center_y),
    (arrow_center_x + 20, arrow_center_y + 30),
    (arrow_center_x + 20, arrow_center_y + 12),
    (arrow_center_x - 30, arrow_center_y + 12)
]
draw.polygon(arrow_points, fill=(70, 130, 255, 255))

# ===== Write a very large "A" in the left bubble =====
try:
    font_letter = ImageFont.truetype("/System/Library/Fonts/SFNSDisplay.ttf", 240)
except:
    try:
        font_letter = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 240)
    except:
        font_letter = ImageFont.load_default()

# Calculate the position of A (centered)
text_a = "A"
bbox_a = draw.textbbox((0, 0), text_a, font=font_letter)
text_width_a = bbox_a[2] - bbox_a[0]
text_height_a = bbox_a[3] - bbox_a[1]
a_x = bubble_left_x - text_width_a // 2 - bbox_a[0]
a_y = bubble_left_y - text_height_a // 2 - bbox_a[1]

# Add text shadow
draw.text((a_x + 3, a_y + 3), text_a, fill=(40, 100, 200, 80), font=font_letter)
# Draw main text
draw.text((a_x, a_y), text_a, fill=(50, 110, 230, 255), font=font_letter)

# Draw the English language label in the right bubble.
try:
    font_chinese = ImageFont.truetype("/System/Library/Fonts/PingFang.ttc", 220)
except:
    font_chinese = font_letter

text_wen = "EN"
bbox_wen = draw.textbbox((0, 0), text_wen, font=font_chinese)
text_width_wen = bbox_wen[2] - bbox_wen[0]
text_height_wen = bbox_wen[3] - bbox_wen[1]
wen_x = bubble_right_x - text_width_wen // 2 - bbox_wen[0]
wen_y = bubble_right_y - text_height_wen // 2 - bbox_wen[1]

# Add text shadow
draw.text((wen_x + 3, wen_y + 3), text_wen, fill=(40, 100, 200, 80), font=font_chinese)
# Draw main text
draw.text((wen_x, wen_y), text_wen, fill=(50, 110, 230, 255), font=font_chinese)

# Save
output_path = "/tmp/cd_icon_bubble/icon_1024.png"
img.save(output_path, 'PNG')
print(f"✅ Bubble version icon has been created: {output_path}")
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
echo "✅ The bubble version icon is created!"
echo ""
echo "Design description:"
echo "  • Only two very large bubbles"
echo "  • The left bubble is higher"
echo "  • The bubble on the right is lower"
echo "  • Letter A 240pt extra large"
echo "  • Text 220pt extra large"
echo "  • Removed CD text"
echo "  • The middle arrow indicates translation"
echo ""
echo "File location:"
echo "  - ICNS file: ${PROJECT_DIR}/AppIcon.icns"
echo "  - Preview image: ${PROJECT_DIR}/icon_preview.png"
echo ""
