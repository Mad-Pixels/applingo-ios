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
    @State private var descriptionText: String = ""
    @State private var errorMessage: String = ""
    @State private var hintText: String = ""
    @State private var isPressedTrailing = false
    @State private var isPressedLeading = false
    @State private var isShowingAlert = false

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
        BaseScreen(
            screen: .wordsAdd,
            title: locale.navigationTitle
        ) {
            ScrollView {
                VStack(spacing: style.spacing) {
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
                .padding(style.padding)
            }
            .keyboardAdaptive()
            .background(style.backgroundColor)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    ButtonNav(
                        style: .back(ThemeManager.shared.currentThemeStyle),
                        onTap: {
                            presentationMode.wrappedValue.dismiss()
                        },
                        isPressed: $isPressedLeading
                    )
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    ButtonNav(
                        style: .save(ThemeManager.shared.currentThemeStyle, disabled: isSaveDisabled),
                        onTap: {
                            save()
                        },
                        isPressed: $isPressedTrailing
                    )
                    .disabled(isSaveDisabled)
                }
            }
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
