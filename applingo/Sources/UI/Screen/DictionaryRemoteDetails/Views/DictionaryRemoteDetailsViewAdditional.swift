import SwiftUI

/// A view that displays additional information of the remote dictionary,
/// such as the author and creation date.
struct DictionaryRemoteDetailsViewAdditional: View {
    
    // MARK: - Properties
    
    let dictionary: ApiModelDictionaryItem
    private let locale: DictionaryRemoteDetailsLocale
    private let style: DictionaryRemoteDetailsStyle
    
    // MARK: - Initializer
    
    /// Initializes the additional details view.
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
                title: locale.additionalTitle.capitalizedFirstLetter,
                style: .titled(ThemeManager.shared.currentThemeStyle)
            )
            .padding(.top, 8)
            
            VStack(spacing: style.spacing) {
                InputText(
                    text: .constant(dictionary.author),
                    placeholder: locale.authorTitle,
                    isEditing: false
                )
                InputText(
                    text: .constant(dictionary.date),
                    placeholder: locale.createdAtTitle,
                    isEditing: false
                )
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
