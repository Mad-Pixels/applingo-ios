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
                title: locale.screenSubtitleDictionary,
                style: .titled(ThemeManager.shared.currentThemeStyle)
            )
            .padding(.top, 8)
            
            VStack(spacing: style.spacing) {
                InputText(
                    text: Binding(
                        get: { dictionary.dictionary.name },
                        set: { dictionary.dictionary.name = $0 }
                    ),
                    title: locale.screenDescriptionName,
                    placeholder: "",
                    isEditing: isEditing
                )
                
                InputTextArea(
                    text: Binding(
                        get: { dictionary.dictionary.description },
                        set: { dictionary.dictionary.description = $0 }
                    ),
                    title: locale.screenDescriptionDescription,
                    placeholder: "",
                    isEditing: isEditing
                )
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
