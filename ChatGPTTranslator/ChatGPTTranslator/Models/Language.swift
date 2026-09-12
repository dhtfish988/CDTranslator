import Foundation

struct Language: Identifiable, Hashable {
    let id = UUID()
    let code: String
    let name: String
    let displayName: String
}

class LanguageManager {
    static let shared = LanguageManager()

    let languages: [Language] = [
        Language(code: "zh-CN", name: "Chinese", displayName: "Chinese"),
        Language(code: "en", name: "English", displayName: "English"),
        Language(code: "ja", name: "Japanese", displayName: "Japanese"),
        Language(code: "ko", name: "Korean", displayName: "Korean"),
        Language(code: "fr", name: "French", displayName: "French"),
        Language(code: "de", name: "German", displayName: "German"),
        Language(code: "es", name: "Spanish", displayName: "Spanish"),
        Language(code: "it", name: "Italian", displayName: "Italian"),
        Language(code: "pt", name: "Portuguese", displayName: "Portuguese"),
        Language(code: "ru", name: "Russian", displayName: "Russian"),
        Language(code: "ar", name: "Arabic", displayName: "Arabic"),
        Language(code: "th", name: "Thai", displayName: "Thai"),
        Language(code: "vi", name: "Vietnamese", displayName: "Vietnamese"),
    ]

    func getLanguage(by code: String) -> Language? {
        languages.first { $0.code == code }
    }
}
