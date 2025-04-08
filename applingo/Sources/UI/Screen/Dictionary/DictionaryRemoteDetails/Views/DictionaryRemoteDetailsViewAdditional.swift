import SwiftUI

internal struct DictionaryRemoteDetailsViewAdditional: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let locale: DictionaryRemoteDetailsLocale
    private let style: DictionaryRemoteDetailsStyle
    
    internal let dictionary: ApiModelDictionaryItem
    
    /// Initializes the DictionaryRemoteDetailsViewAdditional.
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
    
    var body: some View {
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.screenSubtitleAdditional,
                style: .block(themeManager.currentThemeStyle)
            )
            .padding(.top, 8)
            
            VStack(spacing: style.spacing) {
                InputText(
                    text: .constant(dictionary.author),
                    placeholder: "",
                    isEditing: false
                )
                
                InputText(
                    text: .constant(dictionary.date),
                    placeholder: "",
                    isEditing: false
                )
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
