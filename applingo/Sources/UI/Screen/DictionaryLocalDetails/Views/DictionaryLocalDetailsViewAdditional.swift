import SwiftUI

/// A view that displays additional details of a dictionary,
/// such as the author and creation date.
struct DictionaryLocalDetailsViewAdditional: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: DictionaryLocalDetailsLocale
    private let style: DictionaryLocalDetailsStyle
    
    @Binding var dictionary: DatabaseModelDictionary
    let isEditing: Bool
    
    // MARK: - Initializer
    /// Initializes the additional details view.
    /// - Parameters:
    ///   - style: `DictionaryLocalDetailsStyle` style configuration.
    ///   - locale: `DictionaryLocalDetailsLocale` localization object.
    ///   - dictionary: Binding to the dictionary model.
    ///   - isEditing: A flag indicating if the view is in editing mode.
    init(
        style: DictionaryLocalDetailsStyle,
        locale: DictionaryLocalDetailsLocale,
        dictionary: Binding<DatabaseModelDictionary>,
        isEditing: Bool
    ) {
        self._dictionary = dictionary
        self.isEditing = isEditing
        self.locale = locale
        self.style = style
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.screenSubtitleAdditional,
                style: .titled(themeManager.currentThemeStyle)
            )
            .padding(.top, style.paddingBlock)
            
            VStack(spacing: style.spacing) {
                InputText(
                    text: Binding(
                        get: { dictionary.author },
                        set: { dictionary.author = $0 }
                    ),
                    title: locale.screenDescriptionAuthor,
                    placeholder: "",
                    isEditing: isEditing
                )
                InputText(
                    text: .constant(dictionary.date),
                    title: locale.screenDescriptionCreatedAt,
                    placeholder: "",
                    isEditing: false
                )
            }
            .padding(.horizontal, style.paddingBlock)
            .background(Color.clear)
        }
    }
}
