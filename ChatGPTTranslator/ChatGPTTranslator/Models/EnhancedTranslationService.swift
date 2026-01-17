import Foundation
import Vision
import AppKit

class EnhancedTranslationService: ObservableObject {
    @Published var isTranslating = false
    @Published var errorMessage: String?

    private var translationTask: Task<Void, Never>?
    private let debounceDelay: TimeInterval = 0.8 // 延迟0.8秒后翻译

    // 实时翻译 - 带防抖
    func translateRealtime(text: String, from sourceLanguage: String, to targetLanguage: String) async -> String? {
        // 取消之前的翻译任务
        translationTask?.cancel()

        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }

        // 等待防抖延迟
        try? await Task.sleep(nanoseconds: UInt64(debounceDelay * 1_000_000_000))

        // 检查是否被取消
        guard !Task.isCancelled else {
            return nil
        }

        return await translate(text: text, from: sourceLanguage, to: targetLanguage)
    }

    // 从图片识别文字
    func recognizeText(from image: NSImage) async -> String? {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            await MainActor.run {
                self.errorMessage = "无法处理图片"
            }
            return nil
        }

        await MainActor.run {
            self.isTranslating = true
            self.errorMessage = nil
        }

        return await withCheckedContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    Task { @MainActor in
                        self.errorMessage = "文字识别失败: \(error.localizedDescription)"
                        self.isTranslating = false
                    }
                    continuation.resume(returning: nil)
                    return
                }

                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    Task { @MainActor in
                        self.errorMessage = "未识别到文字"
                        self.isTranslating = false
                    }
                    continuation.resume(returning: nil)
                    return
                }

                let recognizedText = observations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }.joined(separator: "\n")

                Task { @MainActor in
                    self.isTranslating = false
                }

                continuation.resume(returning: recognizedText)
            }

            // 支持中英文识别
            request.recognitionLanguages = ["zh-Hans", "zh-Hant", "en-US", "ja-JP", "ko-KR"]
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try handler.perform([request])
                } catch {
                    Task { @MainActor in
                        self.errorMessage = "图片处理失败: \(error.localizedDescription)"
                        self.isTranslating = false
                    }
                    continuation.resume(returning: nil)
                }
            }
        }
    }

    // 基础翻译功能
    private func translate(text: String, from sourceLanguage: String, to targetLanguage: String) async -> String? {
        await MainActor.run {
            self.isTranslating = true
            self.errorMessage = nil
        }

        let sourceLang = getLanguageCode(sourceLanguage)
        let targetLang = getLanguageCode(targetLanguage)

        let baseURL = "https://translate.googleapis.com/translate_a/single"
        var components = URLComponents(string: baseURL)!

        components.queryItems = [
            URLQueryItem(name: "client", value: "gtx"),
            URLQueryItem(name: "sl", value: sourceLang),
            URLQueryItem(name: "tl", value: targetLang),
            URLQueryItem(name: "dt", value: "t"),
            URLQueryItem(name: "q", value: text)
        ]

        guard let url = components.url else {
            await MainActor.run {
                self.isTranslating = false
                self.errorMessage = "无效的 URL"
            }
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Mozilla/5.0", forHTTPHeaderField: "User-Agent")
        request.timeoutInterval = 10

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw TranslationError.invalidResponse
            }

            if httpResponse.statusCode != 200 {
                throw TranslationError.apiError(statusCode: httpResponse.statusCode, message: "请求失败")
            }

            guard let json = try JSONSerialization.jsonObject(with: data) as? [Any],
                  let firstArray = json.first as? [Any],
                  !firstArray.isEmpty else {
                throw TranslationError.invalidResponse
            }

            // 组合所有翻译片段
            var translatedText = ""
            for item in firstArray {
                if let translationArray = item as? [Any],
                   let text = translationArray.first as? String {
                    translatedText += text
                }
            }

            await MainActor.run {
                self.isTranslating = false
            }

            return translatedText.isEmpty ? nil : translatedText

        } catch {
            await MainActor.run {
                self.isTranslating = false
                if !Task.isCancelled {
                    self.errorMessage = "翻译失败: \(error.localizedDescription)"
                }
            }
            return nil
        }
    }

    private func getLanguageCode(_ language: String) -> String {
        // 如果已经是语言代码，直接返回
        let knownCodes = ["zh-CN", "en", "ja", "ko", "fr", "de", "es", "it", "pt", "ru", "ar", "th", "vi", "auto"]
        if knownCodes.contains(language) {
            return language
        }

        // 否则根据语言名称转换
        switch language {
        case "中文", "Chinese": return "zh-CN"
        case "英语", "English": return "en"
        case "日语", "Japanese": return "ja"
        case "韩语", "Korean": return "ko"
        case "法语", "French": return "fr"
        case "德语", "German": return "de"
        case "西班牙语", "Spanish": return "es"
        case "意大利语", "Italian": return "it"
        case "葡萄牙语", "Portuguese": return "pt"
        case "俄语", "Russian": return "ru"
        case "阿拉伯语", "Arabic": return "ar"
        case "泰语", "Thai": return "th"
        case "越南语", "Vietnamese": return "vi"
        default: return "auto"
        }
    }
}

enum TranslationError: LocalizedError {
    case invalidResponse
    case apiError(statusCode: Int, message: String)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "无效的响应格式"
        case .apiError(let statusCode, let message):
            return "API 错误 (\(statusCode)): \(message)"
        }
    }
}
