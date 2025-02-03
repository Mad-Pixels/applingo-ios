import SwiftUI

/// A view that displays the main section for adding a word.
/// It includes inputs for the front text, back text, and dictionary selection.
struct WordAddManualViewMain: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Binding var wordItem: DatabaseModelWord
    @Binding var selectedDictionary: DatabaseModelDictionaryRef?
    
    /// List of available dictionary references.
    let dictionaries: [DatabaseModelDictionaryRef]
    private let locale: WordAddManualLocale
    private let style: WordAddManualStyle
    
    /// Initializes the main view.
    /// - Parameters:
    ///   - wordItem: Binding to the word model.
    ///   - selectedDictionary: Binding to the selected dictionary reference.
    ///   - dictionaries: List of dictionary references.
    ///   - locale: Localization object.
    ///   - style: Style configuration.
    init(
        wordItem: Binding<DatabaseModelWord>,
        selectedDictionary: Binding<DatabaseModelDictionaryRef?>,
        dictionaries: [DatabaseModelDictionaryRef],
        locale: WordAddManualLocale,
        style: WordAddManualStyle
    ) {
        self._wordItem = wordItem
        self._selectedDictionary = selectedDictionary
        self.dictionaries = dictionaries
        self.locale = locale
        self.style = style
    }
    
    var body: some View {
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.cardTitle.capitalizedFirstLetter,
                style: .titled(ThemeManager.shared.currentThemeStyle)
            )
            .padding(.top, 8)
            
            VStack(spacing: style.spacing) {
                InputText(
                    text: $wordItem.frontText,
                    title: locale.wordPlaceholder.capitalizedFirstLetter,
                    placeholder: locale.wordPlaceholder,
                    isEditing: true
                )
                InputText(
                    text: $wordItem.backText,
                    title: locale.definitionPlaceholder.capitalizedFirstLetter,
                    placeholder: locale.definitionPlaceholder,
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
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
