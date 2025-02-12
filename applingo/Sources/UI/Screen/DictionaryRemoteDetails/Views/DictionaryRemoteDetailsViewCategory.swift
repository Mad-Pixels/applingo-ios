import SwiftUI

/// A view that displays the category details of the remote dictionary,
/// including category and subcategory information.
struct DictionaryRemoteDetailsViewCategory: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: DictionaryRemoteDetailsLocale
    private let style: DictionaryRemoteDetailsStyle
    
    let dictionary: ApiModelDictionaryItem
    
    // MARK: - Initializer
    /// Initializes the additional details view.
    /// - Parameters:
    ///   - style: `DictionaryRemoteDetailsStyle` style configuration.
    ///   - locale: `DictionaryRemoteDetailsLocale` localization object.
    ///   - dictionary: The remote dictionary item.
    init(
        style: DictionaryRemoteDetailsStyle,
        locale: DictionaryRemoteDetailsLocale,
        dictionary: ApiModelDictionaryItem
    ) {
        self.dictionary = dictionary
        self.locale = locale
        self.style = style
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.screenSubtitleCategory,
                style: .titled(ThemeManager.shared.currentThemeStyle)
            )
            .padding(.top, 8)
            
            VStack(spacing: style.spacing) {
                InputText(
                    text: .constant(dictionary.category),
                    placeholder: "",
                    isEditing: false
                )
                
                InputText(
                    text: .constant(dictionary.subcategory),
                    placeholder: "",
                    isEditing: false
                )
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
