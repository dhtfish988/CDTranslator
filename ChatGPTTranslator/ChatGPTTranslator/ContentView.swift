import SwiftUI
import UniformTypeIdentifiers
import NaturalLanguage

struct ContentView: View {
    @StateObject private var translationService = EnhancedTranslationService()
    @State private var sourceText = ""
    @State private var translatedText = ""
    @State private var sourceLanguage = LanguageManager.shared.languages[1]
    @State private var targetLanguage = LanguageManager.shared.languages[0]
    @State private var selectedImage: NSImage?
    @State private var isProcessingImage = false

    var body: some View {
        VStack(spacing: 0) {
            topToolbar
            Divider()

            HStack(spacing: 0) {
                sourceTextArea
                Divider()
                translatedTextArea
            }
            .frame(maxHeight: .infinity)

            if let errorMessage = translationService.errorMessage {
                statusBar(message: errorMessage, isError: true)
            } else if translationService.isTranslating || isProcessingImage {
                statusBar(message: isProcessingImage ? "Recognizing text in image..." : "Translating...", isError: false)
            }
        }
        .onAppear {
            NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                if event.modifierFlags.contains(.command) && event.charactersIgnoringModifiers == "v" {
                    if let image = self.getImageFromPasteboard() {
                        self.processImage(image)
                        return nil
                    }
                }
                return event
            }
        }
    }

    private var topToolbar: some View {
        HStack {
            Text("CDTranslator")
                .font(.headline)

            Text("Real-time translation · Image recognition")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.leading, 8)

            Spacer()

            HStack(spacing: 12) {
                LanguagePicker(selectedLanguage: $sourceLanguage, label: "Source language")

                Button(action: swapLanguages) {
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.system(size: 16))
                }
                .buttonStyle(.plain)
                .foregroundColor(.blue)

                LanguagePicker(selectedLanguage: $targetLanguage, label: "Target language")
            }
        }
        .padding()
        .background(Color(NSColor.windowBackgroundColor))
    }

    private var sourceTextArea: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if selectedImage != nil {
                    Text("Image recognition")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else {
                    Text("Enter text")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                if selectedImage != nil {
                    Button(action: {
                        selectedImage = nil
                        sourceText = ""
                        translatedText = ""
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 12))
                            Text("Clear")
                                .font(.system(size: 12))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.orange.opacity(0.15))
                        .foregroundColor(.orange)
                        .cornerRadius(6)
                    }
                    .buttonStyle(.plain)
                } else if !sourceText.isEmpty {
                    Button(action: {
                        sourceText = ""
                        translatedText = ""
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "trash.fill")
                                .font(.system(size: 11))
                            Text("Clear")
                                .font(.system(size: 12))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.red.opacity(0.12))
                        .foregroundColor(.red)
                        .cornerRadius(6)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding([.horizontal, .top])

            if let image = selectedImage {
                imagePreview(image)
            } else {
                textInputArea
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var textInputArea: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $sourceText)
                .font(.system(size: 14))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scrollContentBackground(.hidden)
                .background(Color(NSColor.textBackgroundColor))
                .onChange(of: sourceText) { newValue in
                    Task {
                        // Automatically detect language and switch translation direction
                        autoDetectAndTranslate(text: newValue)
                    }
                }
                .onPasteCommand(of: [.image, .png, .jpeg, .tiff]) { providers in
                    handlePastedImage(providers: providers)
                }
                .padding(.horizontal, 8)

            // Placeholder prompt
            if sourceText.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Type to translate automatically...")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary.opacity(0.5))
                    Text("Press Cmd+V to paste and translate an image")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary.opacity(0.4))
                }
                .padding(.leading, 13)
                .padding(.top, 2)
                .allowsHitTesting(false)
            }
        }
    }

    private func imagePreview(_ image: NSImage) -> some View {
        ScrollView {
            VStack(spacing: 12) {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .cornerRadius(8)
                    .shadow(radius: 2)

                if !sourceText.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Recognized text:")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text(sourceText)
                            .font(.system(size: 13))
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(NSColor.controlBackgroundColor))
                            .cornerRadius(6)
                            .textSelection(.enabled)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.textBackgroundColor))
    }

    private var translatedTextArea: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Translation results")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()

                if !translatedText.isEmpty {
                    Button(action: {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(translatedText, forType: .string)
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "doc.on.doc.fill")
                                .font(.system(size: 11))
                            Text("Copy")
                                .font(.system(size: 12))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.green.opacity(0.15))
                        .foregroundColor(.green)
                        .cornerRadius(6)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding([.horizontal, .top])

            ZStack(alignment: .topLeading) {
                ScrollView {
                    Text(translatedText)
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .textSelection(.enabled)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(NSColor.textBackgroundColor))

                if translatedText.isEmpty {
                    Text("Your translation appears here...")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary.opacity(0.5))
                        .padding()
                        .allowsHitTesting(false)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func statusBar(message: String, isError: Bool) -> some View {
        HStack {
            Image(systemName: isError ? "exclamationmark.triangle" : "info.circle")
                .foregroundColor(isError ? .red : .blue)
            Text(message)
                .font(.caption)
                .foregroundColor(isError ? .red : .primary)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(isError ? Color.red.opacity(0.1) : Color.blue.opacity(0.1))
    }

    private func swapLanguages() {
        let temp = sourceLanguage
        sourceLanguage = targetLanguage
        targetLanguage = temp

        if !translatedText.isEmpty && selectedImage == nil {
            sourceText = translatedText
            translatedText = ""
        }
    }

    private func handlePastedImage(providers: [NSItemProvider]) {
        // Try multiple image types
        let imageTypes = [UTType.image.identifier, UTType.png.identifier, UTType.jpeg.identifier, UTType.tiff.identifier]

        for provider in providers {
            for imageType in imageTypes {
                if provider.hasItemConformingToTypeIdentifier(imageType) {
                    provider.loadItem(forTypeIdentifier: imageType, options: nil) { item, error in
                        var loadedImage: NSImage?

                        if let data = item as? Data {
                            loadedImage = NSImage(data: data)
                        } else if let url = item as? URL {
                            loadedImage = NSImage(contentsOf: url)
                        } else if let image = item as? NSImage {
                            loadedImage = image
                        }

                        if let image = loadedImage {
                            DispatchQueue.main.async {
                                self.processImage(image)
                            }
                        }
                    }
                    return
                }
            }
        }

        // If none of the above methods work, try reading directly from the clipboard
        DispatchQueue.main.async {
            if let image = self.getImageFromPasteboard() {
                self.processImage(image)
            }
        }
    }

    private func getImageFromPasteboard() -> NSImage? {
        let pasteboard = NSPasteboard.general

        // Try multiple ways to read pictures
        if let imageData = pasteboard.data(forType: .tiff),
           let image = NSImage(data: imageData) {
            return image
        }

        if let imageData = pasteboard.data(forType: .png),
           let image = NSImage(data: imageData) {
            return image
        }

        if pasteboard.canReadObject(forClasses: [NSImage.self], options: nil),
           let image = pasteboard.readObjects(forClasses: [NSImage.self], options: nil)?.first as? NSImage {
            return image
        }

        return nil
    }

    private func processImage(_ image: NSImage) {
        selectedImage = image
        isProcessingImage = true
        sourceText = ""
        translatedText = ""

        Task {
            if let recognizedText = await translationService.recognizeText(from: image) {
                sourceText = recognizedText
                autoDetectAndTranslate(text: recognizedText)
            }
            isProcessingImage = false
        }
    }

    // Automatically detect language and translate
    private func autoDetectAndTranslate(text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            translatedText = ""
            return
        }

        Task {
            // Count the number of Chinese and English characters and determine the main language
            var chineseCount = 0
            var englishCount = 0

            for char in text {
                let charType = detectCharacterLanguage(char)
                if charType == .chinese {
                    chineseCount += 1
                } else if charType == .english {
                    englishCount += 1
                }
            }

            // Determine the translation direction based on the main language
            var fromLang = "auto"
            var toLang = "zh-CN"

            if chineseCount > englishCount {
                // Mainly Chinese -> All translated into English
                fromLang = "zh-CN"
                toLang = "en"

                await MainActor.run {
                    if let zhLang = LanguageManager.shared.languages.first(where: { $0.code == "zh-CN" }) {
                        sourceLanguage = zhLang
                    }
                    if let enLang = LanguageManager.shared.languages.first(where: { $0.code == "en" }) {
                        targetLanguage = enLang
                    }
                }
            } else if englishCount > 0 {
                // Mainly in English -> All translated into Chinese
                fromLang = "en"
                toLang = "zh-CN"

                await MainActor.run {
                    if let enLang = LanguageManager.shared.languages.first(where: { $0.code == "en" }) {
                        sourceLanguage = enLang
                    }
                    if let zhLang = LanguageManager.shared.languages.first(where: { $0.code == "zh-CN" }) {
                        targetLanguage = zhLang
                    }
                }
            } else {
                // There is no obvious Chinese and English, use NLlanguageRecognizer to detect
                translateSingleLanguage(text)
                return
            }

            // Perform translation
            if let result = await translationService.translateRealtime(
                text: text,
                from: fromLang,
                to: toLang
            ) {
                await MainActor.run {
                    translatedText = result
                }
            }
        }
    }

    // Detect the language type of a single character
    private func detectCharacterLanguage(_ char: Character) -> LanguageType {
        let scalars = char.unicodeScalars
        guard let scalar = scalars.first else { return .other }

        // Chinese character range
        if (0x4E00...0x9FFF).contains(scalar.value) ||  // CJK unified Chinese characters
           (0x3400...0x4DBF).contains(scalar.value) ||  // CJK extension A
           (0x20000...0x2A6DF).contains(scalar.value) { // CJK extension B
            return .chinese
        }

        // English characters
        if (0x0041...0x005A).contains(scalar.value) ||  // A-Z
           (0x0061...0x007A).contains(scalar.value) {   // a-z
            return .english
        }

        // Numbers and punctuation
        return .other
    }

    // Single language translation (original logic)
    private func translateSingleLanguage(_ text: String) {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        let detectedLanguage = recognizer.dominantLanguage

        Task {
            var fromLang = "auto"
            var toLang = "zh-CN"

            if let detected = detectedLanguage {
                if detected == .simplifiedChinese || detected == .traditionalChinese {
                    // Chinese -> English
                    fromLang = "zh-CN"
                    toLang = "en"

                    await MainActor.run {
                        if let zhLang = LanguageManager.shared.languages.first(where: { $0.code == "zh-CN" }) {
                            sourceLanguage = zhLang
                        }
                        if let enLang = LanguageManager.shared.languages.first(where: { $0.code == "en" }) {
                            targetLanguage = enLang
                        }
                    }
                } else {
                    // Other languages -> Chinese
                    toLang = "zh-CN"

                    let langCode = detected.rawValue
                    await MainActor.run {
                        if let detectedLang = LanguageManager.shared.languages.first(where: {
                            $0.code == langCode || $0.code.hasPrefix(langCode)
                        }) {
                            sourceLanguage = detectedLang
                        }
                        if let zhLang = LanguageManager.shared.languages.first(where: { $0.code == "zh-CN" }) {
                            targetLanguage = zhLang
                        }
                    }
                }
            }

            if let result = await translationService.translateRealtime(
                text: text,
                from: fromLang,
                to: toLang
            ) {
                await MainActor.run {
                    translatedText = result
                }
            }
        }
    }
}

enum LanguageType {
    case chinese
    case english
    case other
}

struct LanguagePicker: View {
    @Binding var selectedLanguage: Language
    let label: String

    var body: some View {
        Menu {
            ForEach(LanguageManager.shared.languages) { language in
                Button(action: {
                    selectedLanguage = language
                }) {
                    HStack {
                        Text(language.displayName)
                        if selectedLanguage.code == language.code {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(selectedLanguage.displayName)
                    .font(.system(size: 13))
                Image(systemName: "chevron.down")
                    .font(.system(size: 10))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(6)
        }
        .menuStyle(.borderlessButton)
    }
}

#Preview {
    ContentView()
}
