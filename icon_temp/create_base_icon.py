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
