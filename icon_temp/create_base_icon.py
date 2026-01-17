from PIL import Image, ImageDraw, ImageFont
import os

# 创建 1024x1024 的图标
size = 1024
img = Image.new('RGBA', (size, size), (255, 255, 255, 0))
draw = ImageDraw.Draw(img)

# 背景渐变色 (蓝色到紫色)
for i in range(size):
    color_r = int(66 + (138 - 66) * i / size)
    color_g = int(133 + (43 - 133) * i / size)
    color_b = int(244 + (226 - 244) * i / size)
    draw.rectangle([(0, i), (size, i+1)], fill=(color_r, color_g, color_b, 255))

# 添加圆角
mask = Image.new('L', (size, size), 0)
mask_draw = ImageDraw.Draw(mask)
mask_draw.rounded_rectangle([(0, 0), (size, size)], radius=180, fill=255)
img.putalpha(mask)

# 绘制 "CD" 文字
try:
    # 尝试使用系统字体
    font_size = 420
    font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", font_size)
except:
    font = ImageFont.load_default()

text = "CD"
# 获取文字边界
bbox = draw.textbbox((0, 0), text, font=font)
text_width = bbox[2] - bbox[0]
text_height = bbox[3] - bbox[1]

# 居中绘制文字
x = (size - text_width) // 2 - bbox[0]
y = (size - text_height) // 2 - bbox[1] - 20

# 文字阴影
draw.text((x+4, y+4), text, font=font, fill=(0, 0, 0, 80))
# 主文字
draw.text((x, y), text, font=font, fill=(255, 255, 255, 255))

# 底部小文字 "翻译"
try:
    small_font = ImageFont.truetype("/System/Library/Fonts/PingFang.ttc", 120)
except:
    small_font = ImageFont.load_default()

small_text = "翻译"
bbox2 = draw.textbbox((0, 0), small_text, font=small_font)
small_width = bbox2[2] - bbox2[0]
small_x = (size - small_width) // 2 - bbox2[0]
small_y = size - 200

draw.text((small_x+2, small_y+2), small_text, font=small_font, fill=(0, 0, 0, 60))
draw.text((small_x, small_y), small_text, font=small_font, fill=(255, 255, 255, 220))

# 保存
output_dir = os.path.dirname(os.path.abspath(__file__))
img.save(os.path.join(output_dir, 'icon_1024.png'))
print("图标创建成功!")
