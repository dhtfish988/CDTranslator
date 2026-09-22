# CDTranslator

A small macOS translation app. Type and it translates as you go, picking the
direction itself; paste a screenshot with `Cmd+V` and it reads the text out of the
image first. It uses a normal SwiftUI window and needs no API key.

macOS 13+, Apple silicon.

## What it does

- **Translate while typing.** Text is translated as you type, with no button to
  press; the app decides which way to translate from what you have entered, so you
  do not have to set the direction first.
- **Read text out of images.** `Cmd+V` with a screenshot or picture on the clipboard
  runs OCR on it and translates the result. Recognition uses Apple's **Vision**
  framework, so that step happens on your Mac and the image is never uploaded.
- **Automatic direction.** The main path sends mostly Chinese text to English and
  Latin-letter text to Simplified Chinese; other input falls back to language
  detection and generally translates to Chinese. These heuristics can misclassify
  languages. The menus list 13 languages, but their selections are not wired into
  the main translation path, so arbitrary language-pair selection is not supported.
- **One-click copy** of the result.

## How translation works, and the caveat that comes with it

Translation calls `https://translate.googleapis.com/translate_a/single`, which is
the endpoint behind Google's own translate web widget. It needs no key and no
account, which is why the app needs no setup.

**It is not a documented, supported API.** Nothing obliges Google to keep it
working, it is rate-limited by whatever they decide, and using it from an
application is not clearly within Google's terms of service. It is good enough for
a personal tool and it is the wrong foundation for anything you intend to ship or
charge for. If this app ever needs to be dependable, the translation call is the
part to replace — with the paid Cloud Translation API, DeepL, or an on-device model.

Text you translate is sent to Google. The OCR step is local; the translation step is
not.

## Build

There is **no Xcode project in this repository.** The app is compiled directly with
`swiftc`:

```bash
./build_cd.sh
```

Read that script before running it. Besides compiling, it **deletes any existing
copy from `/Applications`, installs the new build there, and launches it.** To just
get a binary without touching `/Applications`, run the compile step on its own:

```bash
swiftc -target arm64-apple-macos13.0 \
  -sdk "$(xcrun --show-sdk-path --sdk macosx)" \
  -framework SwiftUI -framework Foundation -framework AppKit -framework Vision \
  -parse-as-library -o CDTranslator \
  ChatGPTTranslator/ChatGPTTranslator/ChatGPTTranslatorApp.swift \
  ChatGPTTranslator/ChatGPTTranslator/ContentView.swift \
  ChatGPTTranslator/ChatGPTTranslator/Models/EnhancedTranslationService.swift \
  ChatGPTTranslator/ChatGPTTranslator/Models/Language.swift
```

**Build check (2026-09-22, source commit `2b22434`).** The four files above compiled
to an arm64 Mach-O on macOS 26.7 with Xcode 27.0 and the macOS 27.0 SDK, targeting
macOS 13.0. Four warnings remain, all in
`EnhancedTranslationService.swift` and all from Swift concurrency checking against
`Vision`, which predates `Sendable`: `VNImageRequestHandler`, `VNRecognizeTextRequest`
and `self` are each captured in a `@Sendable` closure, and the compiler suggests
`@preconcurrency import Vision` to silence the set. This was a compile-only check;
the binary was not installed or run. It is ad-hoc signed, not notarised, and has no
App Sandbox entitlement. The entitlements file in the source tree is not used by
this build command. No UI, OCR or translation-service result was validated here.

## What is in this repository

The four files listed above form the current build. Earlier files are retained for
reference; this build check does not validate those variants:

| | |
|---|---|
| **Built** | `ChatGPTTranslatorApp.swift`, `ContentView.swift`, `Models/EnhancedTranslationService.swift`, `Models/Language.swift` |
| Earlier UI drafts | `ContentViewSimple.swift`, `ContentViewFree.swift`, `ContentViewEnhanced.swift`, `ContentView.swift.v3`, `ContentView.swift.v4` |
| Earlier backends | `Models/TranslationService.swift`, `Models/ChatGPTTranslationService.swift` (OpenAI, needed a key), `Models/FreeTranslationService.swift` |
| Other build scripts | `build_chatgpt.sh`, `build_free.sh`, `build_simple.sh`, `build_final.sh`, `build_app.sh` — each swaps in one of the backends above |
| Docs | `CDTranslator_User_Guide.md`, and `docs/index.html`, which is the privacy policy published at <https://dhtfish988.github.io/CDTranslator/> |
| App Store copy | `AppStore_Materials/` |

The app started out calling OpenAI and needing an API key; it does not work that way
any more. `Utils/ClipboardMonitor.swift` is present but not compiled into the current
build.

Icon-generation scripts, intermediate icon artwork, App Store submission notes, two
superseded READMEs and some dead API-analysis notes were removed in a later commit.
They are still in the git history if you need them.

## Limitations

- Apple silicon only — the build script targets `arm64-apple-macos13.0`.
- No tests.
- Not signed with a Developer ID and not notarised.
- The current build does not enable App Sandbox.
- Translation quality is whatever the endpoint returns; there is no glossary, no
  context window and no way to correct a result.
- OCR accuracy is Vision's, which is good on screenshots and poorer on photographs
  of text at an angle.
- No translation history, no shortcut to summon the window, no batch input.

## License

MIT — see [LICENSE](LICENSE).

Uses Apple's SwiftUI, AppKit and Vision frameworks. No third-party code is vendored.
