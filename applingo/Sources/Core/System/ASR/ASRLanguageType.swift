import Speech

class ASRLanguageType {
    static let shared = ASRLanguageType()
    
    private var languageMap: [String: String] = [:]
    
    private init() {
        // Map common 2-letter ISO codes to full locale identifiers
        languageMap = [
            "en": "en-US",
            "ru": "ru-RU",
            "fr": "fr-FR",
            "de": "de-DE",
            "es": "es-ES",
            "it": "it-IT",
            "ja": "ja-JP",
            "zh": "zh-CN",
            "ko": "ko-KR",
            "ar": "ar-SA",
            "he": "he-IL",
            "pt": "pt-BR"
            // Add more mappings as needed
        ]
        
        // Dynamically check for available recognizers and update map
        cacheAvailableLanguages()
    }
    
    private func cacheAvailableLanguages() {
        for locale in SFSpeechRecognizer.supportedLocales() {
            let languageCode = locale.languageCode?.lowercased() ?? ""
            if !languageCode.isEmpty {
                // Only add to map if we don't already have this language or if this is a default variant
                if languageMap[languageCode] == nil || locale.identifier.contains(languageCode + "-") {
                    languageMap[languageCode] = locale.identifier
                }
            }
        }
    }
    
    /// Returns the full language code for the given short key.
    /// - Parameter key: A two-letter language code.
    /// - Returns: The full language code from the mapping, or an empty string if not found.
    func get(for key: String) -> String {
        return languageMap[key.lowercased()] ?? ""
    }
    
    /// Return Boolean answer, support or not support language code.
    func supported(for key: String) -> Bool {
        let locale = get(for: key)
        if locale.isEmpty {
            return false
        }
        return SFSpeechRecognizer(locale: Locale(identifier: locale)) != nil
    }
    
    /// Returns all supported language identifiers
    func allSupportedLanguages() -> [String] {
        return SFSpeechRecognizer.supportedLocales().map { $0.identifier }
    }
}
