import SwiftUI

struct ContentView: View {
    @StateObject private var translationService = FreeTranslationService()
    @State private var sourceText = ""
    @State private var translatedText = ""
    @State private var sourceLanguage = LanguageManager.shared.languages[1]
    @State private var targetLanguage = LanguageManager.shared.languages[0]

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
            } else if translationService.isTranslating {
                statusBar(message: "翻译中...", isError: false)
            }
        }
    }

    private var topToolbar: some View {
        HStack {
            Text("ChatGPT 翻译器")
                .font(.headline)

            Text("免费版 - 无需登录")
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
                Text("输入文本")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()

                if !sourceText.isEmpty {
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

            TextEditor(text: $sourceText)
                .font(.system(size: 14))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 8)
                .scrollContentBackground(.hidden)
                .background(Color(NSColor.textBackgroundColor))

            HStack {
                Spacer()
                Button("翻译") {
                    Task {
                        if let result = await translationService.translate(
                            text: sourceText,
                            from: sourceLanguage.name,
                            to: targetLanguage.name
                        ) {
                            translatedText = result
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(sourceText.isEmpty || translationService.isTranslating)
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
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

            ScrollView {
                Text(translatedText.isEmpty ? "翻译结果将显示在这里" : translatedText)
                    .font(.system(size: 14))
                    .foregroundColor(translatedText.isEmpty ? .secondary : .primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .textSelection(.enabled)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(NSColor.textBackgroundColor))
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

        if !translatedText.isEmpty {
            sourceText = translatedText
            translatedText = ""
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
