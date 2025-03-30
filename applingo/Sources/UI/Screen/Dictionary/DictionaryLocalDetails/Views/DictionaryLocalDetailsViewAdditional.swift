import SwiftUI

internal struct DictionaryLocalDetailsViewAdditional: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @Binding var dictionary: DatabaseModelDictionary
    
    private let locale: DictionaryLocalDetailsLocale
    private let style: DictionaryLocalDetailsStyle
    
    internal let isEditing: Bool
    
    /// Initializes the DictionaryLocalDetailsViewAdditional.
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
        self.isEditing = isEditing
        self.locale = locale
        self.style = style
        
        self._dictionary = dictionary
    }
    
    var body: some View {
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.screenSubtitleAdditional,
                style: .block(themeManager.currentThemeStyle)
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
