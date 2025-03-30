import SwiftUI

struct DictionaryLocalDetailsViewMain: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @Binding var dictionary: DatabaseModelDictionary
    
    private let locale: DictionaryLocalDetailsLocale
    private let style: DictionaryLocalDetailsStyle
    
    internal let isEditing: Bool
    
    /// Initializes the DictionaryLocalDetailsViewMain.
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
                title: locale.screenSubtitleDictionary,
                style: .block(themeManager.currentThemeStyle)
            )
            .padding(.top, style.paddingBlock)
            
            VStack(spacing: style.spacing) {
                InputTextArea(
                    text: Binding(
                        get: { dictionary.name },
                        set: { dictionary.name = $0 }
                    ),
                    title: locale.screenDescriptionName,
                    placeholder: "",
                    isEditing: isEditing
                )
                
                InputTextArea(
                    text: Binding(
                        get: { dictionary.description },
                        set: { dictionary.description = $0 }
                    ),
                    title: locale.screenDescriptionDescription,
                    placeholder: "",
                    isEditing: isEditing
                )
            }
            .padding(.horizontal, style.paddingBlock)
            .background(Color.clear)
        }
    }
}
