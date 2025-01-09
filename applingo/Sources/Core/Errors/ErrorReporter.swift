// Отправляет ошибку куда-то (например, на сервер)
protocol ErrorReporter {
    func report(_ error: AppError)
}
