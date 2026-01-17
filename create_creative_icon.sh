#!/bin/bash

# 创建创意版 CD 翻译图标
# 设计理念：地球/语言泡泡 + CD 品牌

echo "正在创建创意版 CD 翻译图标..."

# 创建临时目录
TEMP_DIR="/tmp/cd_icon_creative"
mkdir -p "$TEMP_DIR"

# 使用 Python 创建创意图标
python3 << 'PYTHON'
from PIL import Image, ImageDraw, ImageFont
import math

# 创建 1024x1024 图像
size = 1024
img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)

# ===== 绘制圆角矩形背景（渐变效果）=====
for y in range(size):
    for x in range(size):
        rx, ry = 230, 230  # 圆角半径
        in_rect = False

        # 四个角的圆角判断
        if x < rx and y < ry:  # 左上角
            if (x - rx) ** 2 + (y - ry) ** 2 <= rx ** 2:
                in_rect = True
        elif x > size - rx and y < ry:  # 右上角
            if (x - (size - rx)) ** 2 + (y - ry) ** 2 <= rx ** 2:
                in_rect = True
        elif x < rx and y > size - ry:  # 左下角
            if (x - rx) ** 2 + (y - (size - ry)) ** 2 <= rx ** 2:
                in_rect = True
        elif x > size - rx and y > size - ry:  # 右下角
            if (x - (size - rx)) ** 2 + (y - (size - ry)) ** 2 <= rx ** 2:
                in_rect = True
        elif rx <= x <= size - rx or ry <= y <= size - ry:
            in_rect = True

        if in_rect:
            # 径向渐变：从中心向外
            center_x, center_y = size // 2, size // 2
            dist = math.sqrt((x - center_x) ** 2 + (y - center_y) ** 2)
            max_dist = math.sqrt(center_x ** 2 + center_y ** 2)
            ratio = min(dist / max_dist, 1.0)

            # 从亮蓝色到深紫色
            r = int(100 + (90 - 100) * ratio)
            g = int(180 + (80 - 180) * ratio)
            b = int(255 + (200 - 255) * ratio)
            img.putpixel((x, y), (r, g, b, 255))

# ===== 绘制对话气泡组合（表示语言翻译）=====
center_x, center_y = size // 2, size // 2 - 50

# 左侧气泡（蓝色 - 源语言）
bubble_left_x = center_x - 180
bubble_left_y = center_y - 30
bubble_size = 140

# 绘制左侧圆形气泡
for y in range(bubble_left_y - bubble_size, bubble_left_y + bubble_size):
    for x in range(bubble_left_x - bubble_size, bubble_left_x + bubble_size):
        if 0 <= x < size and 0 <= y < size:
            dist = math.sqrt((x - bubble_left_x) ** 2 + (y - bubble_left_y) ** 2)
            if dist <= bubble_size:
                # 半透明白色气泡
                alpha = int(200 * (1 - dist / bubble_size * 0.3))
                img.putpixel((x, y), (255, 255, 255, alpha))

# 左侧气泡小尾巴
tail_left = [
    (bubble_left_x - 60, bubble_left_y + 80),
    (bubble_left_x - 90, bubble_left_y + 120),
    (bubble_left_x - 40, bubble_left_y + 90)
]
draw.polygon(tail_left, fill=(255, 255, 255, 180))

# 右侧气泡（稍微不同的位置 - 目标语言）
bubble_right_x = center_x + 180
bubble_right_y = center_y + 30

# 绘制右侧圆形气泡
for y in range(bubble_right_y - bubble_size, bubble_right_y + bubble_size):
    for x in range(bubble_right_x - bubble_size, bubble_right_x + bubble_size):
        if 0 <= x < size and 0 <= y < size:
            dist = math.sqrt((x - bubble_right_x) ** 2 + (y - bubble_right_y) ** 2)
            if dist <= bubble_size:
                alpha = int(200 * (1 - dist / bubble_size * 0.3))
                img.putpixel((x, y), (255, 255, 255, alpha))

# 右侧气泡小尾巴
tail_right = [
    (bubble_right_x + 60, bubble_right_y + 80),
    (bubble_right_x + 90, bubble_right_y + 120),
    (bubble_right_x + 40, bubble_right_y + 90)
]
draw.polygon(tail_right, fill=(255, 255, 255, 180))

# ===== 在气泡中间绘制翻译箭头 =====
arrow_center_y = center_y

# 箭头主体（更粗更明显）
draw.ellipse(
    [center_x - 50, arrow_center_y - 50, center_x + 50, arrow_center_y + 50],
    fill=(255, 255, 255, 230)
)

# 绘制循环箭头符号
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

# ===== 在左气泡中写 "A" (代表源语言) =====
try:
    font_bubble = ImageFont.truetype("/System/Library/Fonts/SFNSDisplay.ttf", 100)
except:
    try:
        font_bubble = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 100)
    except:
        font_bubble = ImageFont.load_default()

draw.text((bubble_left_x - 25, bubble_left_y - 50), "A", fill=(70, 130, 220, 255), font=font_bubble)

# ===== 在右气泡中写 "文" (代表目标语言) =====
try:
    font_chinese = ImageFont.truetype("/System/Library/Fonts/PingFang.ttc", 90)
except:
    font_chinese = font_bubble

draw.text((bubble_right_x - 35, bubble_right_y - 45), "文", fill=(70, 130, 220, 255), font=font_chinese)

# ===== 在底部绘制 CD 品牌标识 =====
try:
    font_brand = ImageFont.truetype("/System/Library/Fonts/SFNSDisplay.ttf", 180)
except:
    font_brand = font_bubble

cd_text = "CD"
bbox = draw.textbbox((0, 0), cd_text, font=font_brand)
text_width = bbox[2] - bbox[0]
cd_x = (size - text_width) // 2 - bbox[0]
cd_y = size - 240

# 添加文字阴影效果
draw.text((cd_x + 4, cd_y + 4), cd_text, fill=(0, 0, 0, 80), font=font_brand)
draw.text((cd_x, cd_y), cd_text, fill=(255, 255, 255, 255), font=font_brand)

# 保存
output_path = "/tmp/cd_icon_creative/icon_1024.png"
img.save(output_path, 'PNG')
print(f"✅ 已创建创意图标: {output_path}")
PYTHON

# 创建 iconset 目录
ICONSET="$TEMP_DIR/AppIcon.iconset"
mkdir -p "$ICONSET"

# 生成所有需要的尺寸
echo "正在生成所有图标尺寸..."

sizes=(16 32 64 128 256 512)

for size in "${sizes[@]}"; do
    sips -z $size $size "$TEMP_DIR/icon_1024.png" --out "$ICONSET/icon_${size}x${size}.png" > /dev/null 2>&1

    # 生成 @2x 版本
    size2x=$((size * 2))
    sips -z $size2x $size2x "$TEMP_DIR/icon_1024.png" --out "$ICONSET/icon_${size}x${size}@2x.png" > /dev/null 2>&1
done

# 创建 .icns 文件
echo "正在创建 .icns 文件..."
iconutil -c icns "$ICONSET" -o "$TEMP_DIR/AppIcon.icns"

# 复制到项目目录
cp "$TEMP_DIR/AppIcon.icns" "/Users/ffff/Desktop/ChatGpt翻译/AppIcon.icns"
cp "$TEMP_DIR/icon_1024.png" "/Users/ffff/Desktop/ChatGpt翻译/icon_preview.png"

echo ""
echo "✅ 创意图标创建完成！"
echo ""
echo "设计说明："
echo "  • 对话气泡 - 表示语言交流"
echo "  • A + 文 - 表示多语言翻译"
echo "  • 中间箭头 - 表示转换过程"
echo "  • CD 品牌 - 底部清晰标识"
echo "  • 渐变背景 - 专业现代风格"
echo ""
echo "文件位置："
echo "  - ICNS 文件: /Users/ffff/Desktop/ChatGpt翻译/AppIcon.icns"
echo "  - 预览图片: /Users/ffff/Desktop/ChatGpt翻译/icon_preview.png"
echo ""
