#!/bin/bash

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

set -e

echo "Start compiling ChatGPT translator..."

cd "${PROJECT_DIR}/ChatGPTTranslator"

# Compile directly using swiftc
swiftc -parse-as-library \
    -target arm64-apple-macos13.0 \
    -import-objc-header ChatGPTTranslator/ChatGPTTranslator.entitlements \
    -framework SwiftUI \
    -framework Foundation \
    -framework AppKit \
    ChatGPTTranslator/ChatGPTTranslatorApp.swift \
    ChatGPTTranslator/ContentView.swift \
    ChatGPTTranslator/Models/TranslationService.swift \
    ChatGPTTranslator/Models/Language.swift \
    -o ChatGPTTranslator.app

echo "Compilation completed!"
