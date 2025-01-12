import SwiftUI

struct WordAddMainSection: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Binding var wordItem: WordItemModel
    @Binding var selectedDictionary: DictionaryItemModel?
    let dictionaries: [DictionaryItemModel]
    private let locale: ScreenWordAddLocale
    private let style: ScreenWordAddStyle
    
    init(
        wordItem: Binding<WordItemModel>,
        selectedDictionary: Binding<DictionaryItemModel?>,
        dictionaries: [DictionaryItemModel],
        locale: ScreenWordAddLocale,
        style: ScreenWordAddStyle
    ) {
        self._wordItem = wordItem
        self._selectedDictionary = selectedDictionary
        self.dictionaries = dictionaries
        self.locale = locale
        self.style = style
    }
    
    var body: some View {
        Section(header: Text(locale.cardTitle)) {
            VStack(spacing: style.spacing) {
                InputText(
                    text: $wordItem.frontText,
                    placeholder: locale.wordPlaceholder,
                    icon: "rectangle.and.pencil.and.ellipsis"
                )
                
                InputText(
                    text: $wordItem.backText,
                    placeholder: locale.definitionPlaceholder,
                    icon: "translate"
                )
                
                ItemPicker(
                    selectedValue: $selectedDictionary,
                    items: dictionaries,
                    style: .themed(themeManager.currentThemeStyle)
                ) { dictionary in
                    Text(dictionary?.displayName ?? "")
                }
            }
            .padding(style.padding)
        }
    }
}
