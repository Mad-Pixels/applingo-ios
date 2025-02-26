import Foundation

protocol ErrorProcessor {
    func process(_ error: Error) -> AppError?
}

protocol ErrorHandler {
    func handle(_ error: AppError)
}

protocol ErrorReporter {
    func report(_ error: AppError)
}
