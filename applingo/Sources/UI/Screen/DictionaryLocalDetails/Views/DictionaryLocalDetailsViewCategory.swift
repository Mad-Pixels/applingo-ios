import SwiftUI

/// A view that displays and allows editing of the dictionary's category and subcategory.
struct DictionaryLocalDetailsViewCategory: View {
    
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
                title: locale.categoryTitle.capitalizedFirstLetter,
                style: .titled(ThemeManager.shared.currentThemeStyle)
            )
            .padding(.top, 8)
            
            VStack(spacing: style.spacing) {
                // Category input field
                InputText(
                    text: Binding(
                        get: { dictionary.dictionary.category },
                        set: { dictionary.dictionary.category = $0 }
                    ),
                    title: locale.categoryTitle.capitalizedFirstLetter,
                    placeholder: locale.categoryTitle,
                    isEditing: isEditing
                )
                // Subcategory input field
                InputText(
                    text: Binding(
                        get: { dictionary.dictionary.subcategory },
                        set: { dictionary.dictionary.subcategory = $0 }
                    ),
                    title: locale.subcategoryTitle.capitalizedFirstLetter,
                    placeholder: locale.subcategoryTitle,
                    isEditing: isEditing
                )
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
