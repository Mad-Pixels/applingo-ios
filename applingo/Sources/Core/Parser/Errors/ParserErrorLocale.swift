import Foundation
import Combine

/// A class for localizing parser error messages.
final class ParserErrorLocale: ObservableObject {
    static let shared = ParserErrorLocale()
    
    @Published var fileReadFailed: String
    @Published var parsingFailed: String
    @Published var invalidFormat: String
    @Published var notEnoughColumns: String
    @Published var emptyFile: String
    @Published var unsupportedFormat: String
    @Published var errorTitle: String
    
    private init() {
        let lm = LocaleManager.shared
        self.fileReadFailed = lm.localizedString(for: "error.parser.fileReadFailed")
        self.parsingFailed = lm.localizedString(for: "error.parser.parsingFailed")
        self.invalidFormat = lm.localizedString(for: "error.parser.invalidFormat")
        self.notEnoughColumns = lm.localizedString(for: "error.parser.notEnoughColumns")
        self.emptyFile = lm.localizedString(for: "error.parser.emptyFile")
        self.unsupportedFormat = lm.localizedString(for: "error.parser.unsupportedFormat")
        self.errorTitle = lm.localizedString(for: "error.parser.title")
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(localeDidChange),
            name: LocaleManager.localeDidChangeNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Returns the localized message for a given ParserError.
    func localizedMessage(for error: ParserError) -> String {
        switch error {
        case .fileReadFailed:
            return fileReadFailed
        case .parsingFailed:
            return parsingFailed
        case .invalidFormat:
            return invalidFormat
        case .notEnoughColumns:
            return notEnoughColumns
        case .emptyFile:
            return emptyFile
        case .unsupportedFormat:
            return unsupportedFormat
        }
    }
    
    @objc private func localeDidChange() {
        let lm = LocaleManager.shared
        self.fileReadFailed = lm.localizedString(for: "error.parser.fileReadFailed")
        self.parsingFailed = lm.localizedString(for: "error.parser.parsingFailed")
        self.invalidFormat = lm.localizedString(for: "error.parser.invalidFormat")
        self.notEnoughColumns = lm.localizedString(for: "error.parser.notEnoughColumns")
        self.emptyFile = lm.localizedString(for: "error.parser.emptyFile")
        self.unsupportedFormat = lm.localizedString(for: "error.parser.unsupportedFormat")
        self.errorTitle = lm.localizedString(for: "error.parser.title")
    }
}
