#!/bin/bash

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

set -e

echo "================================"
echo "Start compiling ChatGPT translator"
echo "================================"

cd "${PROJECT_DIR}"

APP_NAME="ChatGPTTranslator"
BUILD_DIR="build"
APP_BUNDLE="${BUILD_DIR}/${APP_NAME}.app"
CONTENTS_DIR="${APP_BUNDLE}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"

# Clean up old builds
echo "Clean up old build files..."
rm -rf "${BUILD_DIR}"

# Create App Bundle structure
echo "Create App Bundle structure..."
mkdir -p "${MACOS_DIR}"
mkdir -p "${RESOURCES_DIR}"

# Compile Swift code
echo "Compile Swift code..."
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
    ChatGPTTranslator/ChatGPTTranslator/Models/TranslationService.swift \
    ChatGPTTranslator/ChatGPTTranslator/Models/Language.swift

# Create Info.plist
echo "Create Info.plist..."
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
	<string>ChatGPTTranslator</string>
	<key>CFBundleDisplayName</key>
	<string>ChatGPTTranslator</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>1.0</string>
	<key>CFBundleVersion</key>
	<string>1</string>
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
			<key>api.openai.com</key>
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

# Copy resource files
echo "Copy resource files..."
if [ -d "ChatGPTTranslator/ChatGPTTranslator/Assets.xcassets" ]; then
    cp -R ChatGPTTranslator/ChatGPTTranslator/Assets.xcassets "${RESOURCES_DIR}/"
fi

# Set executable permissions
echo "Set executable permissions..."
chmod +x "${MACOS_DIR}/${APP_NAME}"

echo "================================"
echo "Compilation successful!"
echo "Application location: ${APP_BUNDLE}"
echo "================================"
