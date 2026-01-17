#!/bin/bash

set -e

echo "================================"
echo "编译 ChatGPT 翻译器 (使用官方接口)"
echo "================================"

cd "/Users/ffff/Desktop/ChatGpt翻译"

APP_NAME="ChatGPTTranslator"
BUILD_DIR="build"
APP_BUNDLE="${BUILD_DIR}/${APP_NAME}.app"
CONTENTS_DIR="${APP_BUNDLE}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"

echo "清理旧的构建文件..."
rm -rf "${BUILD_DIR}"

echo "创建 App Bundle 结构..."
mkdir -p "${MACOS_DIR}"
mkdir -p "${RESOURCES_DIR}"

echo "编译 Swift 代码..."
swiftc \
    -target arm64-apple-macos13.0 \
    -sdk $(xcrun --show-sdk-path --sdk macosx) \
    -framework SwiftUI \
    -framework Foundation \
    -framework AppKit \
    -parse-as-library \
    -o "${MACOS_DIR}/${APP_NAME}" \
    ChatGPTTranslator/ChatGPTTranslator/ChatGPTTranslatorApp.swift \
    ChatGPTTranslator/ChatGPTTranslator/ContentView.swift \
    ChatGPTTranslator/ChatGPTTranslator/Models/ChatGPTTranslationService.swift \
    ChatGPTTranslator/ChatGPTTranslator/Models/Language.swift

if [ $? -ne 0 ]; then
    echo "❌ 编译失败!"
    exit 1
fi

echo "创建 Info.plist..."
cat > "${CONTENTS_DIR}/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleExecutable</key>
	<string>ChatGPTTranslator</string>
	<key>CFBundleIdentifier</key>
	<string>com.chatgpt.translator</string>
	<key>CFBundleName</key>
	<string>ChatGPT翻译器</string>
	<key>CFBundleDisplayName</key>
	<string>ChatGPT翻译器</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>2.0</string>
	<key>CFBundleVersion</key>
	<string>2</string>
	<key>LSMinimumSystemVersion</key>
	<string>13.0</string>
	<key>NSHighResolutionCapable</key>
	<true/>
	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSAllowsArbitraryLoads</key>
		<false/>
		<key>NSExceptionDomains</key>
		<dict>
			<key>chatgpt.com</key>
			<dict>
				<key>NSExceptionAllowsInsecureHTTPLoads</key>
				<false/>
				<key>NSIncludesSubdomains</key>
				<true/>
			</dict>
		</dict>
	</dict>
</dict>
</plist>
EOF

echo "复制资源文件..."
if [ -d "ChatGPTTranslator/ChatGPTTranslator/Assets.xcassets" ]; then
    cp -R ChatGPTTranslator/ChatGPTTranslator/Assets.xcassets "${RESOURCES_DIR}/"
fi

echo "设置可执行权限..."
chmod +x "${MACOS_DIR}/${APP_NAME}"

echo "================================"
echo "✅ 编译成功!"
echo "应用位置: ${APP_BUNDLE}"
echo "================================"

echo ""
echo "正在安装到 Applications 文件夹..."
cp -R "${APP_BUNDLE}" /Applications/
echo "✅ 安装完成!"
echo ""
echo "正在启动应用..."
open /Applications/${APP_NAME}.app
echo "================================"
