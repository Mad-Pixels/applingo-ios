import Foundation

struct NetworkErrorProcessor: ErrorProcessor {
    func process(_ error: Error) -> AppError? {
        guard let networkError = error as? URLError else { return nil }
        
        return AppError(
            type: .network(statusCode: networkError.errorCode),
            originalError: networkError,
            context: AppErrorContext(
                source: .network,
                screen: AppStorage.shared.activeScreen,
                metadata: [
                    "url": networkError.failingURL?.absoluteString ?? "",
                    "code": networkError.errorCode
                ],
                severity: .error
            ),
            title: LocaleManager.shared.localizedString(for: "error.network.title"),
            message: networkError.localizedDescription,
            actionTitle: LocaleManager.shared.localizedString(for: "general.retry"),
            action: { /* Retry logic */ }
        )
    }
}
