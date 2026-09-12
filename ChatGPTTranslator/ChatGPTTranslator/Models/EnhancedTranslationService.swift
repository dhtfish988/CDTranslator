import Foundation
import Vision
import AppKit

class EnhancedTranslationService: ObservableObject {
    @Published var isTranslating = false
    @Published var errorMessage: String?

    private var translationTask: Task<Void, Never>?
    private let debounceDelay: TimeInterval = 0.8 // Translate after a delay of 0.8 seconds

    // Real-time translation - with debounce
    func translateRealtime(text: String, from sourceLanguage: String, to targetLanguage: String) async -> String? {
        // Cancel previous translation task
        translationTask?.cancel()

        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }

        // Waiting for debounce delay
        try? await Task.sleep(nanoseconds: UInt64(debounceDelay * 1_000_000_000))

        // Check if canceled
        guard !Task.isCancelled else {
            return nil
        }

        return await translate(text: text, from: sourceLanguage, to: targetLanguage)
    }

    // Recognizing text from images
    func recognizeText(from image: NSImage) async -> String? {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            await MainActor.run {
                self.errorMessage = "Unable to process image"
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
                        self.errorMessage = "Text recognition failed: \(error.localizedDescription)"
                        self.isTranslating = false
                    }
                    continuation.resume(returning: nil)
                    return
                }

                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    Task { @MainActor in
                        self.errorMessage = "No text recognized"
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

            // supports Chinese and English recognition
            request.recognitionLanguages = ["zh-Hans", "zh-Hant", "en-US", "ja-JP", "ko-KR"]
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try handler.perform([request])
                } catch {
                    Task { @MainActor in
                        self.errorMessage = "Image processing failed: \(error.localizedDescription)"
                        self.isTranslating = false
                    }
                    continuation.resume(returning: nil)
                }
            }
        }
    }

    // Basic translation function
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
                self.errorMessage = "Invalid URL"
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
                throw TranslationError.apiError(statusCode: httpResponse.statusCode, message: "Request failed")
            }

            guard let json = try JSONSerialization.jsonObject(with: data) as? [Any],
                  let firstArray = json.first as? [Any],
                  !firstArray.isEmpty else {
                throw TranslationError.invalidResponse
            }

            // Combine all translation fragments
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
                    self.errorMessage = "Translation failed: \(error.localizedDescription)"
                }
            }
            return nil
        }
    }

    private func getLanguageCode(_ language: String) -> String {
        // If it is already a language code, return directly
        let knownCodes = ["zh-CN", "en", "ja", "ko", "fr", "de", "es", "it", "pt", "ru", "ar", "th", "vi", "auto"]
        if knownCodes.contains(language) {
            return language
        }

        // Otherwise convert according to language name
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
            return "Invalid response format"
        case .apiError(let statusCode, let message):
            return "API error (\(statusCode)): \(message)"
        }
    }
}
