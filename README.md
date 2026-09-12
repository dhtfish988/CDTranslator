# ChatGPT Translator macOS App

A native macOS translation app powered by the OpenAI API, with a clean, simple interface.

## Features

- ✨ Simple and modern user interface
- 🌍 Supports translation between 13 commonly used languages
- 🔄 Quick language switching
- 📋 Copy translations with one click
- ⚡️ High-quality translation based on OpenAI GPT-3.5 Turbo
- 💾 Automatically save your API key settings

## Supported languages

- Chinese (Simplified)
- English
- Japanese
- Korean
- French
- German
- Spanish
- Italian
- Portuguese
- Russian
- Arabic
- Thai
- Vietnamese

## How to use

### 1. Get an OpenAI API key

Create an account on the [OpenAI Platform](https://platform.openai.com/) and generate an API key.

### 2. Open the project

Use Xcode to open the `ChatGPTTranslator/ChatGPTTranslator.xcodeproj` file.

### 3. Build and run

Select the target device as "My Mac" in Xcode and click the Run button (⌘R).

### 4. Configure API Key

When running for the first time, click the gear icon in the upper right corner and enter your OpenAI API Key.

### 5. Start translation

1. Select source and target languages
2. Enter the text to be translated in the left input box
3. Click the "Translate" button
4. The translation results will be displayed on the right
5. Click the "Copy" button to copy the translation results

## System Requirements

- macOS 13.0 or higher
- Xcode 14.0 or higher (for building)

## Project structure

```
ChatGPTTranslator/
├── ChatGPTTranslator/
│   ├── ChatGPTTranslatorApp.swift    # Application entry point
│   ├── ContentView.swift              # Main interface
│   ├── Models/
│   │   ├── TranslationService.swift  # Translation service (API call)
│   │   └── Language.swift             # Language model
│   ├── Assets.xcassets/               # Resource file
│   ├── Info.plist                     # Application configuration
│   └── ChatGPTTranslator.entitlements # Permission configuration
└── ChatGPTTranslator.xcodeproj        # Xcode project file
```

## Main components

### TranslationService

Handles communication with the OpenAI API and is responsible for:
- Send translation request
- Handling API responses
- Error handling and status management

### ContentView

The main interface includes:
- Two-column translation interface (source text | translation result)
- Language selection drop-down menu
- Translation button and operation button
- Status bar displays error or progress information

### SettingsView

Configuration interface, used to set and save OpenAI API Key.

## Notes

- OpenAI API usage is billed separately; monitor your usage.
- The API key is stored locally in UserDefaults. Keep it secure.
- An internet connection is required to use the translation function
- Translation quality depends on OpenAI’s GPT-3.5 model

## Development Plan

- [ ] Add translation history
- [ ] Support switching between translation engines
- [ ] Add shortcut key support
- [ ] Support batch translation
- [ ] Add text-to-speech support
- [ ] Support translation of drag-and-drop files

## License

MIT License

## Contributing

Issues and pull requests are welcome!
