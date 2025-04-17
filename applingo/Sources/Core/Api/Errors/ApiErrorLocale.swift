import Foundation
import Combine

/// A class for localizing API error messages.
final class APIErrorLocale: ObservableObject {
    static let shared = APIErrorLocale()
    
    @Published var baseURLNotConfigured: String
    @Published var invalidBaseURL: String
    @Published var invalidEndpointURL: String
    @Published var invalidAPIResponse: String
    @Published var apiErrorMessage: String
    @Published var httpError: String
    @Published var s3Error: String
    @Published var errorTitle: String
    
    private init() {
        let lm = LocaleManager.shared
        self.baseURLNotConfigured = lm.localizedString(for: "error.api.baseURLNotConfigured")
        self.invalidBaseURL = lm.localizedString(for: "error.api.invalidBaseURL")
        self.invalidEndpointURL = lm.localizedString(for: "error.api.invalidEndpointURL")
        self.invalidAPIResponse = lm.localizedString(for: "error.api.invalidAPIResponse")
        self.apiErrorMessage = lm.localizedString(for: "error.api.apiErrorMessage")
        self.httpError = lm.localizedString(for: "error.api.httpError")
        self.s3Error = lm.localizedString(for: "error.api.s3Error")
        self.errorTitle = lm.localizedString(for: "error.api.title")
        
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
        self.baseURLNotConfigured = lm.localizedString(for: "error.api.baseURLNotConfigured")
        self.invalidBaseURL = lm.localizedString(for: "error.api.invalidBaseURL")
        self.invalidEndpointURL = lm.localizedString(for: "error.api.invalidEndpointURL")
        self.invalidAPIResponse = lm.localizedString(for: "error.api.invalidAPIResponse")
        self.apiErrorMessage = lm.localizedString(for: "error.api.apiErrorMessage")
        self.httpError = lm.localizedString(for: "error.api.httpError")
        self.s3Error = lm.localizedString(for: "error.api.s3Error")
        self.errorTitle = lm.localizedString(for: "error.api.title")
    }
}
