/// Model for the DynamicText component.
/// Contains the text to be displayed.
struct DynamicTextModel: Equatable {
    let text: String
    
    // Equatable implementation to support animations during changes
    static func == (lhs: DynamicTextModel, rhs: DynamicTextModel) -> Bool {
        return lhs.text == rhs.text
    }
}
