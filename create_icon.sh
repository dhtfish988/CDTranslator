#!/bin/bash

# 创建应用图标
# CD翻译 - 一个简洁的翻译图标

ICON_DIR="/Users/ffff/Desktop/ChatGpt翻译/icon_temp"
mkdir -p "$ICON_DIR"

# 使用 sips 创建不同尺寸的图标
# 我们先创建一个 1024x1024 的 PNG 图标，然后生成其他尺寸

cat > "$ICON_DIR/create_base_icon.py" << 'PYTHON_SCRIPT'
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
PYTHON_SCRIPT

# 检查是否安装了 Python 和 Pillow
if command -v python3 &> /dev/null; then
    echo "正在创建图标..."
    cd "$ICON_DIR"

    # 安装 Pillow
    python3 -m pip install Pillow --quiet --user 2>/dev/null || true

    # 运行脚本创建基础图标
    python3 create_base_icon.py

    if [ -f "icon_1024.png" ]; then
        echo "✅ 基础图标创建成功"

        # 创建 iconset 目录
        ICONSET="AppIcon.iconset"
        mkdir -p "$ICONSET"

        # 生成不同尺寸的图标
        sips -z 16 16     icon_1024.png --out "$ICONSET/icon_16x16.png" > /dev/null 2>&1
        sips -z 32 32     icon_1024.png --out "$ICONSET/icon_16x16@2x.png" > /dev/null 2>&1
        sips -z 32 32     icon_1024.png --out "$ICONSET/icon_32x32.png" > /dev/null 2>&1
        sips -z 64 64     icon_1024.png --out "$ICONSET/icon_32x32@2x.png" > /dev/null 2>&1
        sips -z 128 128   icon_1024.png --out "$ICONSET/icon_128x128.png" > /dev/null 2>&1
        sips -z 256 256   icon_1024.png --out "$ICONSET/icon_128x128@2x.png" > /dev/null 2>&1
        sips -z 256 256   icon_1024.png --out "$ICONSET/icon_256x256.png" > /dev/null 2>&1
        sips -z 512 512   icon_1024.png --out "$ICONSET/icon_256x256@2x.png" > /dev/null 2>&1
        sips -z 512 512   icon_1024.png --out "$ICONSET/icon_512x512.png" > /dev/null 2>&1
        sips -z 1024 1024 icon_1024.png --out "$ICONSET/icon_512x512@2x.png" > /dev/null 2>&1

        # 生成 .icns 文件
        iconutil -c icns "$ICONSET" -o AppIcon.icns

        if [ -f "AppIcon.icns" ]; then
            echo "✅ 图标文件生成成功: AppIcon.icns"
            cp AppIcon.icns "/Users/ffff/Desktop/ChatGpt翻译/"
            echo "✅ 图标已复制到项目目录"
        else
            echo "❌ 生成 .icns 文件失败"
        fi
    else
        echo "❌ 创建基础图标失败"
    fi
else
    echo "❌ 未找到 Python3，无法创建图标"
    echo "使用简单的文字图标替代..."
fi

echo ""
echo "================================"
echo "图标创建完成"
echo "================================"
