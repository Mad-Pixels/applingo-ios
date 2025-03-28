import SwiftUI

/// A view that displays the main section for adding a word.
/// It includes inputs for the front text, back text, and dictionary selection.
struct WordAddManualViewMain: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: WordAddManualLocale
    private let style: WordAddManualStyle
    
    @Binding var selectedDictionary: DatabaseModelDictionaryRef?
    @Binding var wordItem: DatabaseModelWord    
    private let dictionaries: [DatabaseModelDictionaryRef]
    
    /// Initializes the main view.
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
        self._selectedDictionary = selectedDictionary
        self._wordItem = wordItem
        self.dictionaries = dictionaries
        self.locale = locale
        self.style = style
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
                    style: .themed(themeManager.currentThemeStyle)
                ) { dictionary in
                    Text(dictionary?.name ?? "")
                }
            }
            .padding(.horizontal, style.paddingBlock)
            .background(Color.clear)
        }
    }
}
