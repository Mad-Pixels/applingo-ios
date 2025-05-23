protocol AbstractGameValidation {
    func validate(answer: Any) -> GameValidationResult
    func playFeedback(_ result: GameValidationResult, answer: String?, selected: String?)
}
