import SwiftUI

internal struct DictionaryLocalDetailsViewCategory: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @Binding var dictionary: DatabaseModelDictionary

    private let locale: DictionaryLocalDetailsLocale
    private let style: DictionaryLocalDetailsStyle
    
    internal let isEditing: Bool
    
    /// Initializes the DictionaryLocalDetailsViewCategory.
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
                title: locale.screenSubtitleCategory,
                style: .block(themeManager.currentThemeStyle)
            )
            .padding(.top, style.paddingBlock)
            
            VStack(spacing: style.spacing) {
                InputText(
                    text: Binding(
                        get: { dictionary.category },
                        set: { dictionary.category = $0 }
                    ),
                    title: locale.screenDescriptionName,
                    placeholder: "",
                    isEditing: isEditing
                )
                
                InputText(
                    text: Binding(
                        get: { dictionary.subcategory },
                        set: { dictionary.subcategory = $0 }
                    ),
                    title: locale.screenDescriptionSubcategory,
                    placeholder: "",
                    isEditing: isEditing
                )
            }
            .padding(.horizontal, style.paddingBlock)
            .background(Color.clear)
        }
    }
}
