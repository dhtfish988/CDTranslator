import Foundation

class ChatGPTTranslationService: ObservableObject {
    @Published var isTranslating = false
    @Published var errorMessage: String?

    var accessToken: String
    private let baseURL = "https://chatgpt.com"

    init(accessToken: String = "") {
        self.accessToken = accessToken
    }

    func translate(text: String, from sourceLanguage: String, to targetLanguage: String) async -> String? {
        guard !accessToken.isEmpty else {
            await MainActor.run {
                self.errorMessage = "Please set up ChatGPT Access Token first"
            }
            return nil
        }

        await MainActor.run {
            self.isTranslating = true
            self.errorMessage = nil
        }

        // Construct translation prompt words
        let prompt = "Translate the following text from \(sourceLanguage) to \(targetLanguage). Only provide the translation, without any explanations:\n\n\(text)"

        // ChatGPT conversation API request body
        let conversationId = UUID().uuidString
        let messageId = UUID().uuidString
        let parentMessageId = UUID().uuidString

        let requestBody: [String: Any] = [
            "action": "next",
            "messages": [
                [
                    "id": messageId,
                    "author": ["role": "user"],
                    "content": [
                        "content_type": "text",
                        "parts": [prompt]
                    ]
                ]
            ],
            "conversation_id": conversationId,
            "parent_message_id": parentMessageId,
            "model": "gpt-4",
            "timezone_offset_min": -480,
            "suggestions": [],
            "history_and_training_disabled": false,
            "conversation_mode": ["kind": "primary_assistant"],
            "force_paragen": false,
            "force_rate_limit": false
        ]

        guard let url = URL(string: "\(baseURL)/backend-api/conversation") else {
            await MainActor.run {
                self.isTranslating = false
                self.errorMessage = "Invalid API URL"
            }
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("https://chatgpt.com", forHTTPHeaderField: "Origin")
        request.setValue("https://chatgpt.com/", forHTTPHeaderField: "Referer")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw TranslationError.invalidResponse
            }

            if httpResponse.statusCode == 401 {
                throw TranslationError.authenticationFailed
            }

            if httpResponse.statusCode != 200 {
                let errorText = String(data: data, encoding: .utf8) ?? "Unknown error"
                throw TranslationError.apiError(statusCode: httpResponse.statusCode, message: errorText)
            }

            // Parsing streaming responses
            let responseText = String(data: data, encoding: .utf8) ?? ""
            let result = parseStreamResponse(responseText)

            await MainActor.run {
                self.isTranslating = false
            }

            return result

        } catch {
            await MainActor.run {
                self.isTranslating = false
                self.errorMessage = "Translation failed: \(error.localizedDescription)"
            }
            return nil
        }
    }

    private func parseStreamResponse(_ response: String) -> String? {
        // ChatGPT uses Server-Sent Events (SSE) format
        let lines = response.components(separatedBy: "\n")
        var translatedText = ""

        for line in lines {
            if line.hasPrefix("data: ") {
                let jsonString = line.replacingOccurrences(of: "data: ", with: "")

                // Skip special markers
                if jsonString == "[DONE]" {
                    break
                }

                guard let jsonData = jsonString.data(using: .utf8),
                      let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
                      let message = json["message"] as? [String: Any],
                      let content = message["content"] as? [String: Any],
                      let parts = content["parts"] as? [String] else {
                    continue
                }

                // Accumulated translated text
                if let part = parts.first {
                    translatedText = part
                }
            }
        }

        return translatedText.isEmpty ? nil : translatedText
    }
}

enum TranslationError: LocalizedError {
    case invalidResponse
    case authenticationFailed
    case apiError(statusCode: Int, message: String)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response format"
        case .authenticationFailed:
            return "Authentication failed, please check Access Token"
        case .apiError(let statusCode, let message):
            return "API error (\(statusCode)): \(message)"
        }
    }
}
