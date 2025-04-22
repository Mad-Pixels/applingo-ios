import Foundation

@MainActor
final class ASRPrepare {
    static let shared = ASRPrepare()
    
    private var cache: [String: ASR] = [:]
    
    private init() {}

    /// Get ASR instance for a specific language.
    /// If not initialized, creates and prepares it.
    func get(for languageCode: String) async throws -> ASR {
        if let cached = cache[languageCode] {
            return cached
        }

        let asr = ASR()

        guard asr.isAvailable(for: languageCode) else {
            throw ASRError.unsupportedLanguage(code: languageCode)
        }

        let status = await asr.requestAuthorization()
        guard status == .authorized else {
            throw ASRError.authorizationDenied
        }

        cache[languageCode] = asr
        return asr
    }
}
