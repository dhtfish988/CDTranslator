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
                statusBar(message: isProcessingImage ? "识别图片中..." : "翻译中...", isError: false)
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
            Text("CD翻译")
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
                    Button(action: {
                        selectedImage = nil
                        sourceText = ""
                        translatedText = ""
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 12))
                            Text("清除")
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
                            Text("清空")
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
                        // 自动检测语言并切换翻译方向
                        autoDetectAndTranslate(text: newValue)
                    }
                }
                .onPasteCommand(of: [.image, .png, .jpeg, .tiff]) { providers in
                    handlePastedImage(providers: providers)
                }
                .padding(.horizontal, 8)

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
                    Button(action: {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(translatedText, forType: .string)
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "doc.on.doc.fill")
                                .font(.system(size: 11))
                            Text("复制")
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
        // 尝试多种图片类型
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

        // 如果上面的方法都不行，尝试直接从剪贴板读取
        DispatchQueue.main.async {
            if let image = self.getImageFromPasteboard() {
                self.processImage(image)
            }
        }
    }

    private func getImageFromPasteboard() -> NSImage? {
        let pasteboard = NSPasteboard.general

        // 尝试多种方式读取图片
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

    // 自动检测语言并翻译
    private func autoDetectAndTranslate(text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            translatedText = ""
            return
        }

        Task {
            // 统计中英文字符数量，判断主要语言
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

            // 根据主要语言决定翻译方向
            var fromLang = "auto"
            var toLang = "zh-CN"

            if chineseCount > englishCount {
                // 中文为主 -> 全部翻译成英文
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
                // 英文为主 -> 全部翻译成中文
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
                // 没有明显的中英文，使用 NLLanguageRecognizer 检测
                translateSingleLanguage(text)
                return
            }

            // 执行翻译
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

    // 检测单个字符的语言类型
    private func detectCharacterLanguage(_ char: Character) -> LanguageType {
        let scalars = char.unicodeScalars
        guard let scalar = scalars.first else { return .other }

        // 中文字符范围
        if (0x4E00...0x9FFF).contains(scalar.value) ||  // CJK统一汉字
           (0x3400...0x4DBF).contains(scalar.value) ||  // CJK扩展A
           (0x20000...0x2A6DF).contains(scalar.value) { // CJK扩展B
            return .chinese
        }

        // 英文字符
        if (0x0041...0x005A).contains(scalar.value) ||  // A-Z
           (0x0061...0x007A).contains(scalar.value) {   // a-z
            return .english
        }

        // 数字和标点符号
        return .other
    }

    // 单一语言翻译（原有逻辑）
    private func translateSingleLanguage(_ text: String) {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        let detectedLanguage = recognizer.dominantLanguage

        Task {
            var fromLang = "auto"
            var toLang = "zh-CN"

            if let detected = detectedLanguage {
                if detected == .simplifiedChinese || detected == .traditionalChinese {
                    // 中文 -> 英文
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
                    // 其他语言 -> 中文
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
