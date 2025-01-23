import SwiftUI

struct WordAddManualViewMain: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Binding var wordItem: DatabaseModelWord
    @Binding var selectedDictionary: DatabaseModelDictionary?
    let dictionaries: [DatabaseModelDictionary]
    private let locale: WordAddManualLocale
    private let style: WordAddManualStyle
    
    init(
        wordItem: Binding<DatabaseModelWord>,
        selectedDictionary: Binding<DatabaseModelDictionary?>,
        dictionaries: [DatabaseModelDictionary],
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
