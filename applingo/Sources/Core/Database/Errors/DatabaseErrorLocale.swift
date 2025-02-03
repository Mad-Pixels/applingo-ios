import Foundation
import Combine

/// A class for localizing database error messages.
final class DatabaseErrorLocale: ObservableObject {
    static let shared = DatabaseErrorLocale()
    
    @Published var connectionNotEstablished: String
    @Published var emptyActiveDictionaries: String
    @Published var invalidSearchParameters: String
    @Published var alreadyConnected: String
    @Published var connectionFailed: String
    @Published var csvImportFailed: String
    @Published var migrationFailed: String
    @Published var duplicateWord: String
    @Published var updateFailed: String
    @Published var deleteFailed: String
    @Published var invalidWord: String
    @Published var invalidOffset: String
    @Published var invalidLimit: String
    @Published var wordNotFound: String
    @Published var errorTitle: String
    
    private init() {
        let lm = LocaleManager.shared
        self.connectionNotEstablished = lm.localizedString(for: "error.database.connectionNotEstablished")
        self.emptyActiveDictionaries = lm.localizedString(for: "error.database.emptyActiveDictionaries")
        self.invalidSearchParameters = lm.localizedString(for: "error.database.invalidSearchParameters")
        self.alreadyConnected = lm.localizedString(for: "error.database.alreadyConnected")
        self.connectionFailed = lm.localizedString(for: "error.database.connectionFailed")
        self.csvImportFailed = lm.localizedString(for: "error.database.csvImportFailed")
        self.migrationFailed = lm.localizedString(for: "error.database.migrationFailed")
        self.duplicateWord = lm.localizedString(for: "error.database.duplicateWord")
        self.updateFailed = lm.localizedString(for: "error.database.updateFailed")
        self.deleteFailed = lm.localizedString(for: "error.database.deleteFailed")
        self.invalidWord = lm.localizedString(for: "error.database.invalidWord")
        self.invalidOffset = lm.localizedString(for: "error.database.invalidOffset")
        self.invalidLimit = lm.localizedString(for: "error.database.invalidLimit")
        self.wordNotFound = lm.localizedString(for: "error.database.wordNotFound")
        self.errorTitle = lm.localizedString(for: "error.database.title")
        
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
    
    @objc private func localeDidChange() {
        let lm = LocaleManager.shared
        self.connectionNotEstablished = lm.localizedString(for: "error.database.connectionNotEstablished")
        self.emptyActiveDictionaries = lm.localizedString(for: "error.database.emptyActiveDictionaries")
        self.invalidSearchParameters = lm.localizedString(for: "error.database.invalidSearchParameters")
        self.alreadyConnected = lm.localizedString(for: "error.database.alreadyConnected")
        self.connectionFailed = lm.localizedString(for: "error.database.connectionFailed")
        self.csvImportFailed = lm.localizedString(for: "error.database.csvImportFailed")
        self.migrationFailed = lm.localizedString(for: "error.database.migrationFailed")
        self.duplicateWord = lm.localizedString(for: "error.database.duplicateWord")
        self.updateFailed = lm.localizedString(for: "error.database.updateFailed")
        self.deleteFailed = lm.localizedString(for: "error.database.deleteFailed")
        self.invalidWord = lm.localizedString(for: "error.database.invalidWord")
        self.invalidOffset = lm.localizedString(for: "error.database.invalidOffset")
        self.invalidLimit = lm.localizedString(for: "error.database.invalidLimit")
        self.wordNotFound = lm.localizedString(for: "error.database.wordNotFound")
        self.errorTitle = lm.localizedString(for: "error.database.title")
    }
}
