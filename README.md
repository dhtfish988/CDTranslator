# CDTranslator

A small macOS translation app. Type and it translates as you go, picking the
direction itself; paste a screenshot with `Cmd+V` and it reads the text out of the
image first. SwiftUI, 806 lines of Swift, no configuration and no API key.

macOS 13+, Apple silicon.

## What it does

- **Translate while typing.** Text is translated as you type, with no button to
  press; the app decides which way to translate from what you have entered, so you
  do not have to set the direction first.
- **Read text out of images.** `Cmd+V` with a screenshot or picture on the clipboard
  runs OCR on it and translates the result. Recognition uses Apple's **Vision**
  framework, so that step happens on your Mac and the image is never uploaded.
- **13 languages** — Chinese (Simplified), English, Japanese, Korean, French,
  German, Spanish, Italian, Portuguese, Russian, Arabic, Thai, Vietnamese.
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

**Build check.** The four files above compile to an arm64 Mach-O with the macOS 27.0
SDK (Xcode 26), targeting macOS 13.0. Two warnings remain, both from `Vision` not
being `Sendable` — `VNImageRequestHandler` captured in a `@Sendable` closure in
`EnhancedTranslationService.swift`. The build produces a working binary; it has not
been notarised, and it is signed ad-hoc by the linker, so Gatekeeper will treat it
as unidentified on another machine.

## What is in this repository

The four files listed above are the app. Everything else is history, and it is worth
knowing which is which before reading the source:

| | |
|---|---|
| **Built** | `ChatGPTTranslatorApp.swift`, `ContentView.swift`, `Models/EnhancedTranslationService.swift`, `Models/Language.swift` |
| Earlier UI drafts | `ContentViewSimple.swift`, `ContentViewFree.swift`, `ContentViewEnhanced.swift`, `ContentView.swift.v3`, `ContentView.swift.v4` |
| Earlier backends | `Models/TranslationService.swift`, `Models/ChatGPTTranslationService.swift` (OpenAI, needed a key), `Models/FreeTranslationService.swift` |
| Other build scripts | `build_chatgpt.sh`, `build_free.sh`, `build_simple.sh`, `build_final.sh` — each swaps in one of the backends above |
| Earlier READMEs | `README_v3.md`, `README_v4.md` |
| Icon generation | the `create_*_icon.sh` scripts and `icon_temp/` |
| App Store drafts | `AppStore_Materials/`, and the publishing guides |

The app started out calling OpenAI and needing an API key, which is what
`README_v3.md` and the older docs describe. It does not work that way any more.
`Utils/ClipboardMonitor.swift` is also present but not compiled into the current
build.

## Limitations

- Apple silicon only — the build script targets `arm64-apple-macos13.0`.
- No tests.
- Not signed with a Developer ID and not notarised.
- Translation quality is whatever the endpoint returns; there is no glossary, no
  context window and no way to correct a result.
- OCR accuracy is Vision's, which is good on screenshots and poorer on photographs
  of text at an angle.
- No translation history, no shortcut to summon the window, no batch input.

## License

MIT — see [LICENSE](LICENSE).

Uses Apple's SwiftUI, AppKit and Vision frameworks. No third-party code is vendored.
