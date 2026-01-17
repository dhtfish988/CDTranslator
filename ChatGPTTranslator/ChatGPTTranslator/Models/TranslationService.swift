import Foundation

class TranslationService: ObservableObject {
    @Published var isTranslating = false
    @Published var errorMessage: String?
    var apiKey: String

    private let apiURL = "https://api.openai.com/v1/chat/completions"

    init(apiKey: String = "") {
        self.apiKey = apiKey
    }

    func translate(text: String, from sourceLanguage: String, to targetLanguage: String) async -> String? {
        guard !apiKey.isEmpty else {
            await MainActor.run {
                self.errorMessage = "请先设置 OpenAI API Key"
            }
            return nil
        }

        await MainActor.run {
            self.isTranslating = true
            self.errorMessage = nil
        }

        let prompt = "请将以下\(sourceLanguage)文本翻译成\(targetLanguage)，只返回翻译结果，不要添加任何解释：\n\n\(text)"

        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "你是一个专业的翻译助手。"],
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.3
        ]

        guard let url = URL(string: apiURL) else {
            await MainActor.run {
                self.isTranslating = false
                self.errorMessage = "无效的 API URL"
            }
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw TranslationError.invalidResponse
            }

            if httpResponse.statusCode != 200 {
                let errorText = String(data: data, encoding: .utf8) ?? "Unknown error"
                throw TranslationError.apiError(statusCode: httpResponse.statusCode, message: errorText)
            }

            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let choices = json["choices"] as? [[String: Any]],
                  let firstChoice = choices.first,
                  let message = firstChoice["message"] as? [String: Any],
                  let content = message["content"] as? String else {
                throw TranslationError.invalidResponse
            }

            await MainActor.run {
                self.isTranslating = false
            }

            return content.trimmingCharacters(in: .whitespacesAndNewlines)

        } catch {
            await MainActor.run {
                self.isTranslating = false
                self.errorMessage = "翻译失败: \(error.localizedDescription)"
            }
            return nil
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
