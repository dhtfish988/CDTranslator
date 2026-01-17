#!/bin/bash

# 创建放大版 CD 翻译图标
# 气泡里的字更大，CD 品牌也更大

echo "正在创建放大版 CD 翻译图标..."

# 创建临时目录
TEMP_DIR="/tmp/cd_icon_bigger"
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

# ===== 绘制对话气泡组合（表示语言翻译）=====
center_x, center_y = size // 2, size // 2 - 80

# 左侧气泡（源语言）
bubble_left_x = center_x - 200
bubble_left_y = center_y
bubble_size = 160

# 绘制左侧圆形气泡
for y in range(bubble_left_y - bubble_size, bubble_left_y + bubble_size):
    for x in range(bubble_left_x - bubble_size, bubble_left_x + bubble_size):
        if 0 <= x < size and 0 <= y < size:
            dist = math.sqrt((x - bubble_left_x) ** 2 + (y - bubble_left_y) ** 2)
            if dist <= bubble_size:
                # 白色气泡
                alpha = int(220 * (1 - dist / bubble_size * 0.2))
                img.putpixel((x, y), (255, 255, 255, alpha))

# 右侧气泡（目标语言）
bubble_right_x = center_x + 200
bubble_right_y = center_y

# 绘制右侧圆形气泡
for y in range(bubble_right_y - bubble_size, bubble_right_y + bubble_size):
    for x in range(bubble_right_x - bubble_size, bubble_right_x + bubble_size):
        if 0 <= x < size and 0 <= y < size:
            dist = math.sqrt((x - bubble_right_x) ** 2 + (y - bubble_right_y) ** 2)
            if dist <= bubble_size:
                alpha = int(220 * (1 - dist / bubble_size * 0.2))
                img.putpixel((x, y), (255, 255, 255, alpha))

# ===== 在气泡中间绘制翻译箭头 =====
arrow_center_y = center_y

# 箭头背景圆
draw.ellipse(
    [center_x - 60, arrow_center_y - 60, center_x + 60, arrow_center_y + 60],
    fill=(255, 255, 255, 240)
)

# 绘制更大的箭头
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

# ===== 在左气泡中写超大 "A" =====
try:
    font_letter = ImageFont.truetype("/System/Library/Fonts/SFNSDisplay.ttf", 180)
except:
    try:
        font_letter = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 180)
    except:
        font_letter = ImageFont.load_default()

# 计算 A 的位置（居中）
text_a = "A"
bbox_a = draw.textbbox((0, 0), text_a, font=font_letter)
text_width_a = bbox_a[2] - bbox_a[0]
text_height_a = bbox_a[3] - bbox_a[1]
a_x = bubble_left_x - text_width_a // 2 - bbox_a[0]
a_y = bubble_left_y - text_height_a // 2 - bbox_a[1]

draw.text((a_x, a_y), text_a, fill=(60, 120, 220, 255), font=font_letter)

# ===== 在右气泡中写超大 "文" =====
try:
    font_chinese = ImageFont.truetype("/System/Library/Fonts/PingFang.ttc", 160)
except:
    font_chinese = font_letter

text_wen = "文"
bbox_wen = draw.textbbox((0, 0), text_wen, font=font_chinese)
text_width_wen = bbox_wen[2] - bbox_wen[0]
text_height_wen = bbox_wen[3] - bbox_wen[1]
wen_x = bubble_right_x - text_width_wen // 2 - bbox_wen[0]
wen_y = bubble_right_y - text_height_wen // 2 - bbox_wen[1]

draw.text((wen_x, wen_y), text_wen, fill=(60, 120, 220, 255), font=font_chinese)

# ===== 在底部绘制超大 CD 品牌标识 =====
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

# 添加文字阴影效果
draw.text((cd_x + 5, cd_y + 5), cd_text, fill=(0, 0, 0, 100), font=font_brand)
# 绘制白色主文字
draw.text((cd_x, cd_y), cd_text, fill=(255, 255, 255, 255), font=font_brand)

# 保存
output_path = "/tmp/cd_icon_bigger/icon_1024.png"
img.save(output_path, 'PNG')
print(f"✅ 已创建放大版图标: {output_path}")
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
echo "✅ 放大版图标创建完成！"
echo ""
echo "改进说明："
echo "  • A 字母放大到 180pt"
echo "  • 文 字放大到 160pt"
echo "  • CD 品牌放大到 280pt"
echo "  • 所有元素都更清晰醒目"
echo ""
echo "文件位置："
echo "  - ICNS 文件: /Users/ffff/Desktop/ChatGpt翻译/AppIcon.icns"
echo "  - 预览图片: /Users/ffff/Desktop/ChatGpt翻译/icon_preview.png"
echo ""
