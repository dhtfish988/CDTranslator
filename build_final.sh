#!/bin/bash

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

set -e

echo "================================"
echo "Compile ChatGPT translator v4.0"
echo "real-time translation + image recognition version"
echo "================================"

cd "${PROJECT_DIR}"

APP_NAME="ChatGPTTranslator"
BUILD_DIR="build"
APP_BUNDLE="${BUILD_DIR}/${APP_NAME}.app"
CONTENTS_DIR="${APP_BUNDLE}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"

echo "Clean up old build files..."
rm -rf "${BUILD_DIR}"

echo "Create App Bundle structure..."
mkdir -p "${MACOS_DIR}"
mkdir -p "${RESOURCES_DIR}"

echo "Compile Swift code..."
swiftc \
    -target arm64-apple-macos13.0 \
    -sdk $(xcrun --show-sdk-path --sdk macosx) \
    -framework SwiftUI \
    -framework Foundation \
    -framework AppKit \
    -framework Vision \
    -parse-as-library \
    -o "${MACOS_DIR}/${APP_NAME}" \
    ChatGPTTranslator/ChatGPTTranslator/ChatGPTTranslatorApp.swift \
    ChatGPTTranslator/ChatGPTTranslator/ContentView.swift \
    ChatGPTTranslator/ChatGPTTranslator/Models/EnhancedTranslationService.swift \
    ChatGPTTranslator/ChatGPTTranslator/Models/Language.swift

if [ $? -ne 0 ]; then
    echo "❌ Compilation failed!"
    exit 1
fi

echo "Create Info.plist..."
cat > "${CONTENTS_DIR}/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleExecutable</key>
	<string>ChatGPTTranslator</string>
	<key>CFBundleIdentifier</key>
	<string>com.chatgpt.translator.enhanced</string>
	<key>CFBundleName</key>
	<string>ChatGPTTranslator</string>
	<key>CFBundleDisplayName</key>
	<string>ChatGPTTranslator</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>4.0</string>
	<key>CFBundleVersion</key>
	<string>4</string>
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
			<key>googleapis.com</key>
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

echo "Copy resource files..."
if [ -d "ChatGPTTranslator/ChatGPTTranslator/Assets.xcassets" ]; then
    cp -R ChatGPTTranslator/ChatGPTTranslator/Assets.xcassets "${RESOURCES_DIR}/"
fi

echo "Set executable permissions..."
chmod +x "${MACOS_DIR}/${APP_NAME}"

echo "================================"
echo "✅ Compiled successfully!"
echo "Application location: ${APP_BUNDLE}"
echo "================================"

echo ""
echo "Deleting old versions..."
rm -rf /Applications/${APP_NAME}.app

echo "Installing to Applications folder..."
cp -R "${APP_BUNDLE}" /Applications/
echo "✅ Installation completed!"
echo ""
echo "Starting application..."
open /Applications/${APP_NAME}.app
echo "================================"
echo ""
echo "🎉 ChatGPT Translator v4.0 installation completed!"
echo ""
echo "✨ New features:"
echo "  • Real-time translation - Translate as you type, no need to click a button"
echo "  • Image recognition - supports text recognition and translation from images"
echo "  • Copy and Paste - Press Cmd+V to paste the image"
echo "  • Drag and drop to upload - click \" to select the picture \" to upload the picture"
echo "  • Multi-line support - supports long text translations"
echo ""
echo "🚀 Let’s start using it!"
