import SwiftUI

internal struct WordAddManualViewMain: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @Binding var selectedDictionary: DatabaseModelDictionaryRef?
    @Binding var wordItem: DatabaseModelWord
    
    private let dictionaries: [DatabaseModelDictionaryRef]
    private let locale: WordAddManualLocale
    private let style: WordAddManualStyle
    
    /// Initializes the WordAddManualViewMain.
    /// - Parameters:
    ///   - style: Style configuration.
    ///   - locale: Localization object.
    ///   - wordItem: Binding to the word model.
    ///   - selectedDictionary: Binding to the selected dictionary reference.
    ///   - dictionaries: List of dictionary references.
    init(
        style: WordAddManualStyle,
        locale: WordAddManualLocale,
        wordItem: Binding<DatabaseModelWord>,
        selectedDictionary: Binding<DatabaseModelDictionaryRef?>,
        dictionaries: [DatabaseModelDictionaryRef]
    ) {
        self.dictionaries = dictionaries
        self.locale = locale
        self.style = style
        
        self._selectedDictionary = selectedDictionary
        self._wordItem = wordItem
    }
    
    var body: some View {
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.screenSubtitleWord,
                style: .block(themeManager.currentThemeStyle)
            )
            .padding(.top, style.paddingBlock)
            
            VStack(spacing: style.spacing) {
                InputText(
                    text: $wordItem.frontText,
                    title: locale.screenDescriptionFrontText,
                    placeholder: "",
                    isEditing: true
                )
                
                InputText(
                    text: $wordItem.backText,
                    title: locale.screenDescriptionBackText,
                    placeholder: "",
                    isEditing: true
                )
                
                ItemPicker(
                    selectedValue: $selectedDictionary,
                    items: dictionaries,
                    content:  { dictionary in
                        DynamicText(
                            model: DynamicTextModel(text: dictionary?.name ?? ""),
                            style: .picker(
                                themeManager.currentThemeStyle,
                                fontSize: 13
                            )
                        )
                    },
                    style: .themed(themeManager.currentThemeStyle))
            }
            .padding(.horizontal, style.paddingBlock)
            .background(Color.clear)
        }
    }
}
