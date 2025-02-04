import SwiftUI

/// A view that displays additional details of a dictionary,
/// such as the author and creation date.
struct DictionaryLocalDetailsViewAdditional: View {
    
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
                title: locale.screenSubtitleAdditional,
                style: .titled(ThemeManager.shared.currentThemeStyle)
            )
            .padding(.top, 8)
            
            VStack(spacing: style.spacing) {
                InputText(
                    text: Binding(
                        get: { dictionary.dictionary.author },
                        set: { dictionary.dictionary.author = $0 }
                    ),
                    title: locale.screenDescriptionAuthor,
                    placeholder: "",
                    isEditing: isEditing
                )
                InputText(
                    text: .constant(dictionary.dictionary.date),
                    title: locale.screenDescriptionCreatedAt,
                    placeholder: "",
                    isEditing: false
                )
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
