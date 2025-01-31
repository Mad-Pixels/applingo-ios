import SwiftUI

/// A view that displays the main details of a dictionary,
/// including the name, description, and topic.
struct DictionaryLocalDetailsViewMain: View {
    
    // MARK: - Properties
    
    let dictionary: EditableDictionaryWrapper
    private let locale: DictionaryLocalDetailsLocale
    private let style: DictionaryLocalDetailsStyle
    let isEditing: Bool
    
    // MARK: - Initializer
    
    init(
        dictionary: EditableDictionaryWrapper,
        locale: DictionaryLocalDetailsLocale,
        style: DictionaryLocalDetailsStyle,
        isEditing: Bool
    ) {
        self.dictionary = dictionary
        self.locale = locale
        self.style = style
        self.isEditing = isEditing
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.dictionaryTitle.capitalizedFirstLetter,
                style: .titled(ThemeManager.shared.currentThemeStyle)
            )
            .padding(.top, 8)
            
            VStack(spacing: style.spacing) {
                // Name input field
                InputText(
                    text: Binding(
                        get: { dictionary.dictionary.name },
                        set: { dictionary.dictionary.name = $0 }
                    ),
                    title: locale.displayNameTitle.capitalizedFirstLetter,
                    placeholder: locale.displayNameTitle,
                    isEditing: isEditing
                )
                // Description text area
                InputTextArea(
                    text: Binding(
                        get: { dictionary.dictionary.description },
                        set: { dictionary.dictionary.description = $0 }
                    ),
                    title: locale.descriptionTitle.capitalizedFirstLetter,
                    placeholder: locale.descriptionTitle,
                    isEditing: isEditing
                )
                // Topic input field
                InputText(
                    text: Binding(
                        get: { dictionary.dictionary.topic },
                        set: { dictionary.dictionary.topic = $0 }
                    ),
                    title: locale.displayNameTitle.capitalizedFirstLetter,
                    placeholder: locale.displayNameTitle,
                    isEditing: isEditing
                )
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
