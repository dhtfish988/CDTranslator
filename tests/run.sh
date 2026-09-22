#!/bin/bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
test_dir="$(mktemp -d "${TMPDIR:-/tmp}/cdtranslator-tests.XXXXXX")"
trap 'rm -rf "$test_dir"' EXIT
swiftc -target arm64-apple-macos13.0 \
  -sdk "$(xcrun --show-sdk-path --sdk macosx)" \
  -framework SwiftUI -framework Foundation -framework AppKit -framework Vision \
  -parse-as-library -o "$test_dir/TranslationServiceTests" \
  "$project_dir/tests/TranslationServiceTests.swift" \
  "$project_dir/ChatGPTTranslator/ChatGPTTranslator/Models/EnhancedTranslationService.swift"
"$test_dir/TranslationServiceTests"
