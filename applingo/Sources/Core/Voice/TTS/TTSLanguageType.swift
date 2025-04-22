import AVFoundation

class TTSLanguageType {
    static let shared = TTSLanguageType()
    
    private var languageMap: [String: String] = [:]
    
    private init() {
        for fullCode in AVSpeechSynthesisVoice.speechVoices().map({ $0.language }) {
            let key = String(fullCode.prefix(2)).lowercased()
            
            if key == "en" {
                languageMap[key] = "en-US"
                continue
            }
            
            if languageMap[key] == nil {
                languageMap[key] = fullCode
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
        return !get(for: key).isEmpty
    }
}
