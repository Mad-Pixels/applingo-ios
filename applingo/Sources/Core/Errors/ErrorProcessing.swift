// Обрабатывает сырую ошибку и превращает её в AppError
protocol ErrorProcessor {
    func process(_ error: Error) -> AppError
}
