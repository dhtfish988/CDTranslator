import Foundation

class FreeTranslationService: ObservableObject {
    @Published var isTranslating = false
    @Published var errorMessage: String?

    func translate(text: String, from sourceLanguage: String, to targetLanguage: String) async -> String? {
        await MainActor.run {
            self.isTranslating = true
            self.errorMessage = nil
        }

        // 使用 Google Translate 非官方 API
        let result = await translateWithGoogle(text: text, from: sourceLanguage, to: targetLanguage)

        await MainActor.run {
            self.isTranslating = false
        }

        return result
    }

    private func translateWithGoogle(text: String, from sourceLanguage: String, to targetLanguage: String) async -> String? {
        let sourceLang = getLanguageCode(sourceLanguage)
        let targetLang = getLanguageCode(targetLanguage)

        // Google Translate 非官方 API 端点
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
                self.errorMessage = "无效的 URL"
            }
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Mozilla/5.0", forHTTPHeaderField: "User-Agent")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw TranslationError.invalidResponse
            }

            if httpResponse.statusCode != 200 {
                throw TranslationError.apiError(statusCode: httpResponse.statusCode, message: "请求失败")
            }

            // 解析 Google Translate 响应
            // 响应格式: [[["翻译结果","原文",null,null,3]],null,"en",null,null,null,null,[]]
            guard let json = try JSONSerialization.jsonObject(with: data) as? [Any],
                  let firstArray = json.first as? [Any],
                  let translationArray = firstArray.first as? [Any],
                  let translatedText = translationArray.first as? String else {
                throw TranslationError.invalidResponse
            }

            return translatedText

        } catch {
            await MainActor.run {
                self.errorMessage = "翻译失败: \(error.localizedDescription)"
            }
            return nil
        }
    }

    private func getLanguageCode(_ language: String) -> String {
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
        default: return "en"
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
