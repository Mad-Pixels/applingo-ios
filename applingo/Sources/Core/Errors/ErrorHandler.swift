// Что-то делает с готовой AppError (например, логирование)
protocol ErrorHandler {
    func handle(_ error: AppError)
}
