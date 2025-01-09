import Foundation

struct AppError: Identifiable {
    let id: UUID = UUID()
    let type: AppErrorType
    let originalError: Error?
    let context: AppErrorContext
    let timestamp: Date
    
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(
        type: AppErrorType,
        originalError: Error? = nil,
        context: AppErrorContext,
        timestamp: Date = Date(),
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.type = type
        self.originalError = originalError
        self.context = context
        self.timestamp = timestamp
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
}
