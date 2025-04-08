struct FeedbackContext {
    let selectedOption: String
    let correctOption: String?
    let customOption: String?
    
    init(selectedOption: String, correctOption: String? = nil, customOption: String? = nil) {
        self.selectedOption = selectedOption
        self.correctOption = correctOption
        self.customOption = customOption
    }
}
