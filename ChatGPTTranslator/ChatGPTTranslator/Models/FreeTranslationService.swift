import Foundation

class FreeTranslationService: ObservableObject {
    @Published var isTranslating = false
    @Published var errorMessage: String?

    func translate(text: String, from sourceLanguage: String, to targetLanguage: String) async -> String? {
        await MainActor.run {
            self.isTranslating = true
            self.errorMessage = nil
        }

        // Use Google Translate unofficial API
        let result = await translateWithGoogle(text: text, from: sourceLanguage, to: targetLanguage)

        await MainActor.run {
            self.isTranslating = false
        }

        return result
    }

    private func translateWithGoogle(text: String, from sourceLanguage: String, to targetLanguage: String) async -> String? {
        let sourceLang = getLanguageCode(sourceLanguage)
        let targetLang = getLanguageCode(targetLanguage)

        // Google Translate unofficial API endpoint
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
                self.errorMessage = "Invalid URL"
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
                throw TranslationError.apiError(statusCode: httpResponse.statusCode, message: "Request failed")
            }

            // Parsing Google Translate responses
            // Response format: [[["Translation result","Original text",null,null,3]],null,"en",null,null,null,null,[]]
            guard let json = try JSONSerialization.jsonObject(with: data) as? [Any],
                  let firstArray = json.first as? [Any],
                  let translationArray = firstArray.first as? [Any],
                  let translatedText = translationArray.first as? String else {
                throw TranslationError.invalidResponse
            }

            return translatedText

        } catch {
            await MainActor.run {
                self.errorMessage = "Translation failed: \(error.localizedDescription)"
            }
            return nil
        }
    }

    private func getLanguageCode(_ language: String) -> String {
        switch language {
        case "\u{4e2d}\u{6587}", "Chinese": return "zh-CN"
        case "\u{82f1}\u{8bed}", "English": return "en"
        case "\u{65e5}\u{8bed}", "Japanese": return "ja"
        case "\u{97e9}\u{8bed}", "Korean": return "ko"
        case "\u{6cd5}\u{8bed}", "French": return "fr"
        case "\u{5fb7}\u{8bed}", "German": return "de"
        case "\u{897f}\u{73ed}\u{7259}\u{8bed}", "Spanish": return "es"
        case "\u{610f}\u{5927}\u{5229}\u{8bed}", "Italian": return "it"
        case "\u{8461}\u{8404}\u{7259}\u{8bed}", "Portuguese": return "pt"
        case "\u{4fc4}\u{8bed}", "Russian": return "ru"
        case "\u{963f}\u{62c9}\u{4f2f}\u{8bed}", "Arabic": return "ar"
        case "\u{6cf0}\u{8bed}", "Thai": return "th"
        case "\u{8d8a}\u{5357}\u{8bed}", "Vietnamese": return "vi"
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
            return "Invalid response format"
        case .apiError(let statusCode, let message):
            return "API error (\(statusCode)): \(message)"
        }
    }
}
