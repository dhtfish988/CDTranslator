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
                self.errorMessage = "Please set the OpenAI API Key first"
            }
            return nil
        }

        await MainActor.run {
            self.isTranslating = true
            self.errorMessage = nil
        }

        let prompt = "Please translate the following \(sourceLanguage) text into \(targetLanguage). Return only the translation, without any explanation: \n\n\(text)"

        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "You are a professional translation assistant."],
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.3
        ]

        guard let url = URL(string: apiURL) else {
            await MainActor.run {
                self.isTranslating = false
                self.errorMessage = "Invalid API URL"
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
                self.errorMessage = "Translation failed: \(error.localizedDescription)"
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
            return "Invalid response format"
        case .apiError(let statusCode, let message):
            return "API error (\(statusCode)): \(message)"
        }
    }
}
