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
        Language(code: "zh-CN", name: "Chinese", displayName: "中文"),
        Language(code: "en", name: "English", displayName: "英语"),
        Language(code: "ja", name: "Japanese", displayName: "日语"),
        Language(code: "ko", name: "Korean", displayName: "韩语"),
        Language(code: "fr", name: "French", displayName: "法语"),
        Language(code: "de", name: "German", displayName: "德语"),
        Language(code: "es", name: "Spanish", displayName: "西班牙语"),
        Language(code: "it", name: "Italian", displayName: "意大利语"),
        Language(code: "pt", name: "Portuguese", displayName: "葡萄牙语"),
        Language(code: "ru", name: "Russian", displayName: "俄语"),
        Language(code: "ar", name: "Arabic", displayName: "阿拉伯语"),
        Language(code: "th", name: "Thai", displayName: "泰语"),
        Language(code: "vi", name: "Vietnamese", displayName: "越南语"),
    ]

    func getLanguage(by code: String) -> Language? {
        languages.first { $0.code == code }
    }
}
