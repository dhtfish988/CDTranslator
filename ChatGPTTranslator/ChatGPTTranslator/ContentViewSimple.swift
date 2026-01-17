import SwiftUI
import UniformTypeIdentifiers

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
                statusBar(message: isProcessingImage ? "识别图片中..." : "翻译中...", isError: false)
            }
        }
    }

    private var topToolbar: some View {
        HStack {
            Text("ChatGPT 翻译器")
                .font(.headline)

            Text("实时翻译 · 图片识别")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.leading, 8)

            Spacer()

            HStack(spacing: 12) {
                LanguagePicker(selectedLanguage: $sourceLanguage, label: "源语言")

                Button(action: swapLanguages) {
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.system(size: 16))
                }
                .buttonStyle(.plain)
                .foregroundColor(.blue)

                LanguagePicker(selectedLanguage: $targetLanguage, label: "目标语言")
            }
        }
        .padding()
        .background(Color(NSColor.windowBackgroundColor))
    }

    private var sourceTextArea: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if selectedImage != nil {
                    Text("图片识别")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else {
                    Text("输入文本")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                if selectedImage != nil {
                    Button("清除") {
                        selectedImage = nil
                        sourceText = ""
                        translatedText = ""
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.orange)
                    .font(.caption)
                } else if !sourceText.isEmpty {
                    Button("清空") {
                        sourceText = ""
                        translatedText = ""
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.blue)
                    .font(.caption)
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
                .padding(.horizontal, 8)
                .scrollContentBackground(.hidden)
                .background(Color(NSColor.textBackgroundColor))
                .onChange(of: sourceText) { newValue in
                    Task {
                        if let result = await translationService.translateRealtime(
                            text: newValue,
                            from: sourceLanguage.name,
                            to: targetLanguage.name
                        ) {
                            translatedText = result
                        }
                    }
                }
                .onPasteCommand(of: [.image, .png, .jpeg, .tiff]) { providers in
                    handlePastedImage(providers: providers)
                }

            // 占位符提示
            if sourceText.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("输入文字自动翻译...")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary.opacity(0.5))
                    Text("按 Cmd+V 粘贴图片识别翻译")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary.opacity(0.4))
                }
                .padding(.horizontal, 12)
                .padding(.top, 8)
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
                        Text("识别的文字:")
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
                Text("翻译结果")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()

                if !translatedText.isEmpty {
                    Button("复制") {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(translatedText, forType: .string)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.blue)
                    .font(.caption)
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
                    Text("翻译结果实时显示...")
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
        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { item, error in
                    if let data = item as? Data, let image = NSImage(data: data) {
                        DispatchQueue.main.async {
                            processImage(image)
                        }
                    } else if let url = item as? URL, let image = NSImage(contentsOf: url) {
                        DispatchQueue.main.async {
                            processImage(image)
                        }
                    }
                }
                break
            }
        }
    }

    private func processImage(_ image: NSImage) {
        selectedImage = image
        isProcessingImage = true
        sourceText = ""
        translatedText = ""

        Task {
            if let recognizedText = await translationService.recognizeText(from: image) {
                sourceText = recognizedText

                if let translated = await translationService.translateRealtime(
                    text: recognizedText,
                    from: sourceLanguage.name,
                    to: targetLanguage.name
                ) {
                    translatedText = translated
                }
            }
            isProcessingImage = false
        }
    }
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
