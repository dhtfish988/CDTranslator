#!/bin/bash

# 创建橙色主题翻译图标
# 仿照 iBooks 风格，带透明高光效果

echo "正在创建橙色主题翻译图标..."

# 创建临时目录
TEMP_DIR="/tmp/cd_icon_orange"
mkdir -p "$TEMP_DIR"

# 使用 Python 创建图标
python3 << 'PYTHON'
from PIL import Image, ImageDraw, ImageFont
import math
import os

# 创建 1024x1024 图像
size = 1024
img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)

# ===== 绘制圆角矩形背景（橙色渐变）=====
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
            # 从上到下的线性渐变：浅橙到深橙
            ratio = y / size
            # 亮橙色 (255, 179, 71) 到 深橙色 (238, 123, 38)
            r = int(255 - (255 - 238) * ratio)
            g = int(179 - (179 - 123) * ratio)
            b = int(71 - (71 - 38) * ratio)
            img.putpixel((x, y), (r, g, b, 255))

# ===== 绘制玻璃质感的对话气泡（左高右低，间距更大）=====
center_x = size // 2
center_y = size // 2

# 左侧气泡（位置更高，更靠左）
bubble_left_x = center_x - 240  # 增加间距
bubble_left_y = center_y - 100
bubble_size_left = 200

# 绘制左侧气泡 - 带玻璃质感
for y in range(bubble_left_y - bubble_size_left, bubble_left_y + bubble_size_left):
    for x in range(bubble_left_x - bubble_size_left, bubble_left_x + bubble_size_left):
        if 0 <= x < size and 0 <= y < size:
            dist = math.sqrt((x - bubble_left_x) ** 2 + (y - bubble_left_y) ** 2)
            if dist <= bubble_size_left:
                # 白色半透明气泡，边缘更透明
                base_alpha = int(200 * (1 - dist / bubble_size_left * 0.2))

                # 添加顶部高光效果（玻璃质感）
                highlight_offset = y - (bubble_left_y - bubble_size_left)
                if highlight_offset < bubble_size_left * 0.5:
                    # 顶部更亮
                    brightness = 1.0 + (1 - highlight_offset / (bubble_size_left * 0.5)) * 0.3
                    alpha = min(int(base_alpha * brightness), 255)
                else:
                    alpha = base_alpha

                img.putpixel((x, y), (255, 255, 255, alpha))

# 左侧气泡小尾巴
tail_left = [
    (bubble_left_x - 70, bubble_left_y + 110),
    (bubble_left_x - 110, bubble_left_y + 170),
    (bubble_left_x - 40, bubble_left_y + 120)
]
draw.polygon(tail_left, fill=(255, 255, 255, 200))

# 右侧气泡（位置更低，更靠右）
bubble_right_x = center_x + 240  # 增加间距
bubble_right_y = center_y + 100
bubble_size_right = 200

# 绘制右侧气泡 - 带玻璃质感
for y in range(bubble_right_y - bubble_size_right, bubble_right_y + bubble_size_right):
    for x in range(bubble_right_x - bubble_size_right, bubble_right_x + bubble_size_right):
        if 0 <= x < size and 0 <= y < size:
            dist = math.sqrt((x - bubble_right_x) ** 2 + (y - bubble_right_y) ** 2)
            if dist <= bubble_size_right:
                base_alpha = int(200 * (1 - dist / bubble_size_right * 0.2))

                # 添加顶部高光效果
                highlight_offset = y - (bubble_right_y - bubble_size_right)
                if highlight_offset < bubble_size_right * 0.5:
                    brightness = 1.0 + (1 - highlight_offset / (bubble_size_right * 0.5)) * 0.3
                    alpha = min(int(base_alpha * brightness), 255)
                else:
                    alpha = base_alpha

                img.putpixel((x, y), (255, 255, 255, alpha))

# 右侧气泡小尾巴
tail_right = [
    (bubble_right_x + 70, bubble_right_y + 90),
    (bubble_right_x + 110, bubble_right_y + 150),
    (bubble_right_x + 40, bubble_right_y + 100)
]
draw.polygon(tail_right, fill=(255, 255, 255, 200))

# ===== 在气泡中间绘制翻译箭头（带玻璃效果）=====
arrow_center_x = center_x
arrow_center_y = center_y

# 箭头背景圆 - 玻璃效果
for y in range(arrow_center_y - 65, arrow_center_y + 65):
    for x in range(arrow_center_x - 65, arrow_center_x + 65):
        if 0 <= x < size and 0 <= y < size:
            dist = math.sqrt((x - arrow_center_x) ** 2 + (y - arrow_center_y) ** 2)
            if dist <= 65:
                base_alpha = 220
                # 顶部高光
                highlight_offset = y - (arrow_center_y - 65)
                if highlight_offset < 50:
                    brightness = 1.0 + (1 - highlight_offset / 50) * 0.2
                    alpha = min(int(base_alpha * brightness), 255)
                else:
                    alpha = base_alpha
                img.putpixel((x, y), (255, 255, 255, alpha))

# 绘制箭头
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

# ===== 在左气泡中写 "A" =====
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

# 添加文字阴影（深橙色）
draw.text((a_x + 3, a_y + 3), text_a, fill=(200, 100, 30, 100), font=font_letter)
# 绘制主文字（深橙色）
draw.text((a_x, a_y), text_a, fill=(230, 110, 40, 255), font=font_letter)

# ===== 在右气泡中写 "中" =====
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

text_zh = "中"
bbox_zh = draw.textbbox((0, 0), text_zh, font=font_chinese)
text_width_zh = bbox_zh[2] - bbox_zh[0]
text_height_zh = bbox_zh[3] - bbox_zh[1]
zh_x = bubble_right_x - text_width_zh // 2 - bbox_zh[0]
zh_y = bubble_right_y - text_height_zh // 2 - bbox_zh[1]

# 添加文字阴影
draw.text((zh_x + 3, zh_y + 3), text_zh, fill=(200, 100, 30, 100), font=font_chinese)
# 绘制主文字
draw.text((zh_x, zh_y), text_zh, fill=(230, 110, 40, 255), font=font_chinese)

# 保存
output_path = "/tmp/cd_icon_orange/icon_1024.png"
img.save(output_path, 'PNG')
print(f"✅ 已创建橙色主题图标: {output_path}")
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
echo "✅ 橙色主题图标创建完成！"
echo ""
echo "设计说明："
echo "  • 橙色渐变背景（仿 iBooks）"
echo "  • 玻璃质感气泡（顶部高光）"
echo "  • 两个气泡间距加大"
echo "  • 左高右低布局"
echo "  • 深橙色文字"
echo ""
echo "文件位置："
echo "  - ICNS 文件: /Users/ffff/Desktop/ChatGpt翻译/AppIcon.icns"
echo "  - 预览图片: /Users/ffff/Desktop/ChatGpt翻译/icon_preview.png"
echo ""
