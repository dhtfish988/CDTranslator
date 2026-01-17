#!/bin/bash

# 创建气泡版 CD 翻译图标
# 只有两个大气泡，左高右低，不要 CD 文字

echo "正在创建气泡版翻译图标..."

# 创建临时目录
TEMP_DIR="/tmp/cd_icon_bubble"
mkdir -p "$TEMP_DIR"

# 使用 Python 创建图标
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

# ===== 绘制超大对话气泡（左高右低）=====
center_x = size // 2

# 左侧气泡（位置更高，更大）
bubble_left_x = center_x - 180
bubble_left_y = center_y - 120  # 左边更高
bubble_size_left = 220  # 超大气泡

# 绘制左侧圆形气泡
for y in range(bubble_left_y - bubble_size_left, bubble_left_y + bubble_size_left):
    for x in range(bubble_left_x - bubble_size_left, bubble_left_x + bubble_size_left):
        if 0 <= x < size and 0 <= y < size:
            dist = math.sqrt((x - bubble_left_x) ** 2 + (y - bubble_left_y) ** 2)
            if dist <= bubble_size_left:
                # 白色气泡，边缘柔和
                alpha = int(240 * (1 - dist / bubble_size_left * 0.15))
                img.putpixel((x, y), (255, 255, 255, alpha))

# 左侧气泡小尾巴
tail_left = [
    (bubble_left_x - 80, bubble_left_y + 120),
    (bubble_left_x - 120, bubble_left_y + 180),
    (bubble_left_x - 50, bubble_left_y + 130)
]
draw.polygon(tail_left, fill=(255, 255, 255, 230))

# 右侧气泡（位置更低，更大）
bubble_right_x = center_x + 180
bubble_right_y = center_y + 80  # 右边更低
bubble_size_right = 220  # 超大气泡

# 绘制右侧圆形气泡
for y in range(bubble_right_y - bubble_size_right, bubble_right_y + bubble_size_right):
    for x in range(bubble_right_x - bubble_size_right, bubble_right_x + bubble_size_right):
        if 0 <= x < size and 0 <= y < size:
            dist = math.sqrt((x - bubble_right_x) ** 2 + (y - bubble_right_y) ** 2)
            if dist <= bubble_size_right:
                alpha = int(240 * (1 - dist / bubble_size_right * 0.15))
                img.putpixel((x, y), (255, 255, 255, alpha))

# 右侧气泡小尾巴
tail_right = [
    (bubble_right_x + 80, bubble_right_y + 100),
    (bubble_right_x + 120, bubble_right_y + 160),
    (bubble_right_x + 50, bubble_right_y + 110)
]
draw.polygon(tail_right, fill=(255, 255, 255, 230))

# ===== 在气泡中间绘制翻译箭头 =====
arrow_center_x = center_x
arrow_center_y = center_y - 20

# 箭头背景圆（稍微大一点）
draw.ellipse(
    [arrow_center_x - 70, arrow_center_y - 70, arrow_center_x + 70, arrow_center_y + 70],
    fill=(255, 255, 255, 250)
)

# 绘制更大更清晰的箭头
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

# ===== 在左气泡中写超大 "A" =====
try:
    font_letter = ImageFont.truetype("/System/Library/Fonts/SFNSDisplay.ttf", 240)
except:
    try:
        font_letter = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 240)
    except:
        font_letter = ImageFont.load_default()

# 计算 A 的位置（居中）
text_a = "A"
bbox_a = draw.textbbox((0, 0), text_a, font=font_letter)
text_width_a = bbox_a[2] - bbox_a[0]
text_height_a = bbox_a[3] - bbox_a[1]
a_x = bubble_left_x - text_width_a // 2 - bbox_a[0]
a_y = bubble_left_y - text_height_a // 2 - bbox_a[1]

# 添加文字阴影
draw.text((a_x + 3, a_y + 3), text_a, fill=(40, 100, 200, 80), font=font_letter)
# 绘制主文字
draw.text((a_x, a_y), text_a, fill=(50, 110, 230, 255), font=font_letter)

# ===== 在右气泡中写超大 "文" =====
try:
    font_chinese = ImageFont.truetype("/System/Library/Fonts/PingFang.ttc", 220)
except:
    font_chinese = font_letter

text_wen = "文"
bbox_wen = draw.textbbox((0, 0), text_wen, font=font_chinese)
text_width_wen = bbox_wen[2] - bbox_wen[0]
text_height_wen = bbox_wen[3] - bbox_wen[1]
wen_x = bubble_right_x - text_width_wen // 2 - bbox_wen[0]
wen_y = bubble_right_y - text_height_wen // 2 - bbox_wen[1]

# 添加文字阴影
draw.text((wen_x + 3, wen_y + 3), text_wen, fill=(40, 100, 200, 80), font=font_chinese)
# 绘制主文字
draw.text((wen_x, wen_y), text_wen, fill=(50, 110, 230, 255), font=font_chinese)

# 保存
output_path = "/tmp/cd_icon_bubble/icon_1024.png"
img.save(output_path, 'PNG')
print(f"✅ 已创建气泡版图标: {output_path}")
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
echo "✅ 气泡版图标创建完成！"
echo ""
echo "设计说明："
echo "  • 只有两个超大气泡"
echo "  • 左边气泡位置更高"
echo "  • 右边气泡位置更低"
echo "  • A 字母 240pt 超大"
echo "  • 文 字 220pt 超大"
echo "  • 去掉了 CD 文字"
echo "  • 中间箭头表示翻译"
echo ""
echo "文件位置："
echo "  - ICNS 文件: /Users/ffff/Desktop/ChatGpt翻译/AppIcon.icns"
echo "  - 预览图片: /Users/ffff/Desktop/ChatGpt翻译/icon_preview.png"
echo ""
