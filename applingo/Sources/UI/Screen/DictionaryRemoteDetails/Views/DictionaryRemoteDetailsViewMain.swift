import SwiftUI

/// A view that displays the main details of the remote dictionary,
/// including the name, description, and topic.
struct DictionaryRemoteDetailsViewMain: View {
    
    // MARK: - Properties
    
    let dictionary: ApiModelDictionaryItem
    private let locale: DictionaryRemoteDetailsLocale
    private let style: DictionaryRemoteDetailsStyle
    
    // MARK: - Initializer
    
    /// Initializes the main details view.
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
                title: locale.dictionaryTitle.capitalizedFirstLetter,
                style: .titled(ThemeManager.shared.currentThemeStyle)
            )
            .padding(.top, 8)
            
            VStack(spacing: style.spacing) {
                InputText(
                    text: .constant(dictionary.name),
                    placeholder: locale.displayNameTitle,
                    isEditing: false
                )
                InputTextArea(
                    text: .constant(dictionary.description),
                    placeholder: locale.descriptionTitle,
                    isEditing: false
                )
                InputText(
                    text: .constant(dictionary.topic),
                    placeholder: locale.displayNameTitle,
                    isEditing: false
                )
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
