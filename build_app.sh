#!/bin/bash

set -e

echo "开始编译 ChatGPT 翻译器..."

cd "/Users/ffff/Desktop/ChatGpt翻译/ChatGPTTranslator"

# 使用 swiftc 直接编译
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

echo "编译完成!"
