#!/bin/bash

echo "正在创建 CD翻译 图标..."

ICON_DIR="/Users/ffff/Desktop/ChatGpt翻译/icon_temp"
mkdir -p "$ICON_DIR"
cd "$ICON_DIR"

# 创建一个简单的 SVG 图标
cat > icon.svg << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<svg width="1024" height="1024" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="bg" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" style="stop-color:#4285F4;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#8A2BE2;stop-opacity:1" />
    </linearGradient>
  </defs>

  <!-- 圆角矩形背景 -->
  <rect width="1024" height="1024" rx="180" fill="url(#bg)"/>

  <!-- CD 文字阴影 -->
  <text x="512" y="580" font-family="Helvetica, Arial, sans-serif" font-size="420" font-weight="bold" text-anchor="middle" fill="rgba(0,0,0,0.2)">CD</text>

  <!-- CD 文字 -->
  <text x="512" y="576" font-family="Helvetica, Arial, sans-serif" font-size="420" font-weight="bold" text-anchor="middle" fill="white">CD</text>

  <!-- 翻译文字阴影 -->
  <text x="512" y="832" font-family="PingFang SC, Helvetica, sans-serif" font-size="100" text-anchor="middle" fill="rgba(0,0,0,0.15)">翻译</text>

  <!-- 翻译文字 -->
  <text x="512" y="828" font-family="PingFang SC, Helvetica, sans-serif" font-size="100" text-anchor="middle" fill="rgba(255,255,255,0.9)">翻译</text>
</svg>
EOF

echo "✅ SVG 图标创建成功"

# 将 SVG 转换为 PNG
if command -v qlmanage &> /dev/null; then
    # 使用 qlmanage 生成预览
    qlmanage -t -s 1024 -o . icon.svg > /dev/null 2>&1

    if [ -f "icon.svg.png" ]; then
        mv icon.svg.png icon_1024.png
        echo "✅ PNG 图标生成成功"
    fi
fi

# 如果上面的方法不行，尝试使用 sips 从 PDF
if [ ! -f "icon_1024.png" ] && command -v rsvg-convert &> /dev/null; then
    rsvg-convert -w 1024 -h 1024 icon.svg -o icon_1024.png 2>/dev/null
    echo "✅ PNG 图标生成成功"
fi

# 如果还是没有，手动使用系统命令创建
if [ ! -f "icon_1024.png" ]; then
    echo "使用备用方法创建图标..."

    # 创建纯色图标
    cat > create_fallback.sh << 'FALLBACK'
#!/bin/bash
# 使用 ImageMagick 或其他工具
# 这里我们创建一个简单的渐变背景
convert -size 1024x1024 gradient:"#4285F4"-"#8A2BE2" \
    \( -size 1024x1024 xc:none -draw "roundrectangle 0,0,1024,1024,180,180" \) \
    -alpha set -compose DstIn -composite \
    -gravity center -pointsize 420 -font Helvetica-Bold -fill white -annotate +0-50 "CD" \
    -gravity center -pointsize 100 -font PingFang-SC-Regular -fill "rgba(255,255,255,0.9)" -annotate +0+350 "翻译" \
    icon_1024.png 2>/dev/null
FALLBACK

    chmod +x create_fallback.sh
    ./create_fallback.sh 2>/dev/null || true
fi

# 检查是否成功创建 PNG
if [ -f "icon_1024.png" ]; then
    echo "✅ 基础图标创建成功"

    # 创建 iconset
    ICONSET="AppIcon.iconset"
    mkdir -p "$ICONSET"

    echo "正在生成不同尺寸的图标..."

    # 生成所有需要的尺寸
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

    echo "✅ 各尺寸图标生成成功"

    # 生成 .icns 文件
    iconutil -c icns "$ICONSET" -o AppIcon.icns 2>/dev/null

    if [ -f "AppIcon.icns" ]; then
        echo "✅ .icns 文件生成成功"
        cp AppIcon.icns "/Users/ffff/Desktop/ChatGpt翻译/"
        cp icon_1024.png "/Users/ffff/Desktop/ChatGpt翻译/icon_preview.png"
        echo "✅ 图标已复制到项目目录"
    else
        echo "⚠️  .icns 生成失败，但 PNG 图标可用"
    fi
else
    echo "❌ 无法创建图标"
    echo "请手动创建图标或使用在线工具"
fi

echo ""
echo "================================"
echo "图标创建完成"
echo "================================"
