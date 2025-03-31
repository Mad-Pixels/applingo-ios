struct FeedbackContext {
    let selectedOption: String
    let correctOption: String?
    
    init(selectedOption: String, correctOption: String? = nil) {
        self.selectedOption = selectedOption
        self.correctOption = correctOption
    }
}
