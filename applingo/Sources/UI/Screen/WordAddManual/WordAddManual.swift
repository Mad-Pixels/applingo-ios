import SwiftUI

struct WordAddManual: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var style: WordAddManualStyle
    @StateObject private var locale = WordAddManualLocale()
    @StateObject private var wordsAction = WordsLocalActionViewModel()
    @StateObject private var dictionaryGetter = DictionaryLocalGetterViewModel()
    
    @Binding var isPresented: Bool
    let refresh: () -> Void
    
    @State private var selectedDictionary: DictionaryItemModel?
    @State private var wordItem = WordItemModel.empty()
    @State private var hintText: String = ""
    @State private var descriptionText: String = ""
    @State private var isShowingAlert = false
    @State private var errorMessage: String = ""
    
    init(
        isPresented: Binding<Bool>,
        refresh: @escaping () -> Void,
        style: WordAddManualStyle? = nil
    ) {
        self._isPresented = isPresented
        self.refresh = refresh
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    var body: some View {
        BaseScreen(screen: .wordsAdd, title: locale.navigationTitle) {
            Form {
                WordAddManualViewMain(
                    wordItem: $wordItem,
                    selectedDictionary: $selectedDictionary,
                    dictionaries: dictionaryGetter.dictionaries,
                    locale: locale,
                    style: style
                )
                
                WordAddManualViewAdditional(
                    hint: $hintText,
                    description: $descriptionText,
                    locale: locale,
                    style: style
                )
            }
            .navigationTitle(locale.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(locale.cancelTitle) {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button(locale.saveTitle) {
                    save()
                }
                .disabled(isSaveDisabled)
            )
        }
        .onChange(of: hintText) { wordItem.hint = $0 }
        .onChange(of: descriptionText) { wordItem.description = $0 }
        .onChange(of: dictionaryGetter.dictionaries) { dictionaries in
            if selectedDictionary == nil {
                selectedDictionary = dictionaries.first
            }
        }
    }
    
    private var isSaveDisabled: Bool {
        wordItem.frontText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        wordItem.backText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func save() {
        guard let selectedDictionary = selectedDictionary else { return }
        
        let newWord = WordItemModel(
            id: wordItem.id,
            tableName: selectedDictionary.tableName,
            frontText: wordItem.frontText,
            backText: wordItem.backText,
            description: descriptionText.isEmpty ? nil : descriptionText,
            hint: hintText.isEmpty ? nil : hintText,
            createdAt: wordItem.createdAt,
            success: wordItem.success,
            weight: wordItem.weight,
            fail: wordItem.fail
        )
        
        wordsAction.save(newWord) { result in
            if case .success = result {
                presentationMode.wrappedValue.dismiss()
                refresh()
            }
        }
    }
}
