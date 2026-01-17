#!/bin/bash

# 创建最终版 CD 翻译图标
# 大号 CD 字母 + 翻译箭头符号

echo "正在创建最终版 CD 翻译图标..."

# 创建临时目录
TEMP_DIR="/tmp/cd_icon_final"
mkdir -p "$TEMP_DIR"

# 创建 SVG 图标 - CD 字母 + 双向箭头
cat > "$TEMP_DIR/icon.svg" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<svg width="1024" height="1024" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <!-- 背景渐变：蓝色到紫色 -->
    <linearGradient id="bgGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#4A90E2;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#7B68EE;stop-opacity:1" />
    </linearGradient>

    <!-- 文字渐变：白色 -->
    <linearGradient id="textGrad" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" style="stop-color:#FFFFFF;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#F0F0F0;stop-opacity:1" />
    </linearGradient>
  </defs>

  <!-- 圆角矩形背景 -->
  <rect width="1024" height="1024" rx="230" ry="230" fill="url(#bgGrad)"/>

  <!-- CD 文字 - 大号，居中偏上 -->
  <text x="512" y="550"
        font-family="SF Pro Display, -apple-system, BlinkMacSystemFont, Arial, sans-serif"
        font-size="380"
        font-weight="900"
        text-anchor="middle"
        fill="url(#textGrad)"
        letter-spacing="-10">CD</text>

  <!-- 双向翻译箭头 - 在 CD 下方 -->
  <g transform="translate(512, 750)">
    <!-- 左箭头 -->
    <path d="M -80 0 L -50 -18 L -50 -8 L -10 -8 L -10 8 L -50 8 L -50 18 Z"
          fill="#FFFFFF" opacity="0.95"/>

    <!-- 右箭头 -->
    <path d="M 80 0 L 50 18 L 50 8 L 10 8 L 10 -8 L 50 -8 L 50 -18 Z"
          fill="#FFFFFF" opacity="0.95"/>
  </g>
</svg>
EOF

echo "✅ SVG 图标已创建"

# 将 SVG 转换为 PNG (1024x1024)
echo "正在转换 SVG 到 PNG..."
qlmanage -t -s 1024 -o "$TEMP_DIR" "$TEMP_DIR/icon.svg" 2>/dev/null
mv "$TEMP_DIR/icon.svg.png" "$TEMP_DIR/icon_1024.png" 2>/dev/null

# 如果 qlmanage 失败，使用 Python 创建
if [ ! -f "$TEMP_DIR/icon_1024.png" ]; then
    echo "使用 Python 创建 PNG..."
    python3 << 'PYTHON'
from PIL import Image, ImageDraw, ImageFont
import os

# 创建 1024x1024 图像
size = 1024
img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)

# 绘制圆角矩形背景（渐变效果）
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
            # 计算渐变颜色（从蓝色到紫色）
            ratio = (x + y) / (2 * size)
            r = int(74 + (123 - 74) * ratio)
            g = int(144 + (104 - 144) * ratio)
            b = int(226 + (238 - 226) * ratio)
            img.putpixel((x, y), (r, g, b, 255))

# 添加文字 "CD"
try:
    font = ImageFont.truetype("/System/Library/Fonts/SFNSDisplay.ttf", 360)
except:
    try:
        font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 360)
    except:
        font = ImageFont.load_default()

text = "CD"
bbox = draw.textbbox((0, 0), text, font=font)
text_width = bbox[2] - bbox[0]
text_height = bbox[3] - bbox[1]

# 居中绘制文字，稍微向上
x = (size - text_width) // 2 - bbox[0]
y = (size - text_height) // 2 - bbox[1] - 80

draw.text((x, y), text, fill=(255, 255, 255, 255), font=font)

# 绘制双向箭头（在 CD 下方）
arrow_y = 720
center_x = size // 2

# 左箭头 ←
left_arrow = [
    (center_x - 80, arrow_y),
    (center_x - 50, arrow_y - 18),
    (center_x - 50, arrow_y - 8),
    (center_x - 10, arrow_y - 8),
    (center_x - 10, arrow_y + 8),
    (center_x - 50, arrow_y + 8),
    (center_x - 50, arrow_y + 18),
]
draw.polygon(left_arrow, fill=(255, 255, 255, 242))

# 右箭头 →
right_arrow = [
    (center_x + 80, arrow_y),
    (center_x + 50, arrow_y + 18),
    (center_x + 50, arrow_y + 8),
    (center_x + 10, arrow_y + 8),
    (center_x + 10, arrow_y - 8),
    (center_x + 50, arrow_y - 8),
    (center_x + 50, arrow_y - 18),
]
draw.polygon(right_arrow, fill=(255, 255, 255, 242))

# 保存
output_path = "/tmp/cd_icon_final/icon_1024.png"
img.save(output_path, 'PNG')
print(f"✅ 已创建 PNG 图标: {output_path}")
PYTHON
fi

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
echo "✅ 最终版图标创建完成！"
echo ""
echo "设计说明："
echo "  • 大号 CD 字母 - 清晰醒目"
echo "  • 双向箭头 ⇄ - 表示翻译功能"
echo "  • 蓝紫渐变 - 现代专业"
echo ""
echo "文件位置："
echo "  - ICNS 文件: /Users/ffff/Desktop/ChatGpt翻译/AppIcon.icns"
echo "  - 预览图片: /Users/ffff/Desktop/ChatGpt翻译/icon_preview.png"
echo ""
echo "现在重新编译应用："
echo "  ./build_cd.sh"
echo ""
