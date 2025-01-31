import SwiftUI

/// A view that displays the category details of the remote dictionary,
/// including category and subcategory information.
struct DictionaryRemoteDetailsViewCategory: View {
    
    // MARK: - Properties
    
    let dictionary: ApiModelDictionaryItem
    private let locale: DictionaryRemoteDetailsLocale
    private let style: DictionaryRemoteDetailsStyle
    
    // MARK: - Initializer
    
    /// Initializes the category details view.
    /// - Parameters:
    ///   - dictionary: The remote dictionary item.
    ///   - locale: The localization object.
    ///   - style: The style configuration.
    init(
        dictionary: ApiModelDictionaryItem,
        locale: DictionaryRemoteDetailsLocale,
        style: DictionaryRemoteDetailsStyle
    ) {
        self.dictionary = dictionary
        self.locale = locale
        self.style = style
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
                InputText(
                    text: .constant(dictionary.category),
                    placeholder: locale.categoryTitle,
                    isEditing: false
                )
                InputText(
                    text: .constant(dictionary.subcategory),
                    placeholder: locale.subcategoryTitle,
                    isEditing: false
                )
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
