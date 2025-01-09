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
}
