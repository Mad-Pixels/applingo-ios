import SwiftUI
import Foundation

struct WordDetails: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var style: WordDetailsStyle
    @StateObject private var locale = WordDetailsLocale()
    @StateObject private var wordsAction = WordsLocalActionViewModel()
    @StateObject private var wrapper: WordWrapper
    
    @Binding var isPresented: Bool
    let refresh: () -> Void
    private let originalWord: WordItemModel
    
    @State private var isEditing = false
    @State private var isShowingAlert = false
    @State private var isPressedLeading = false
    @State private var isPressedTrailing = false
    @State private var errorMessage: String = ""
    
    init(
        word: WordItemModel,
        isPresented: Binding<Bool>,
        refresh: @escaping () -> Void,
        style: WordDetailsStyle? = nil
    ) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
        _wrapper = StateObject(wrappedValue: WordWrapper(word: word))
        _isPresented = isPresented
        self.originalWord = word
        self.refresh = refresh
    }
    
    var body: some View {
        BaseScreen(
            screen: .wordsDetail,
            title: locale.navigationTitle
        ) {
            ScrollView {
                VStack(spacing: style.spacing) {
                    WordDetailsViewMain(
                        word: $wrapper.word,
                        locale: locale,
                        style: style,
                        isEditing: isEditing
                    )
                        
                    WordDetailsViewAdditional(
                        word: $wrapper.word,
                        tableName: wordsAction.dictionaryDisplayName(wrapper.word),
                        locale: locale,
                        style: style,
                        isEditing: isEditing
                    )
                        
                    WordDetailsViewStatistic(
                        word: wrapper.word,
                        locale: locale,
                        style: style
                    )
                }
                .padding(style.padding)
            }
            .keyboardAdaptive()
            .background(style.backgroundColor)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(locale.navigationTitle)
            .navigationBarItems(
                leading: ButtonNav(
                    style: isEditing ? .close(ThemeManager.shared.currentThemeStyle) : .back(ThemeManager.shared.currentThemeStyle),
                    onTap: {
                        if isEditing {
                            isEditing = false
                            wrapper.word = originalWord
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    },
                    isPressed: $isPressedLeading
                ),
                trailing: ButtonNav(
                    style: isEditing ? .save(ThemeManager.shared.currentThemeStyle) : .edit(ThemeManager.shared.currentThemeStyle),
                    onTap: {
                        if isEditing {
                            updateWord()
                        } else {
                            isEditing = true
                        }
                    },
                    isPressed: $isPressedTrailing
                )
                .disabled(isEditing && isSaveDisabled)
            )
        }
    }
    
    private var isSaveDisabled: Bool {
        wrapper.word.frontText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        wrapper.word.backText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func updateWord() {
        wordsAction.update(wrapper.word) { _ in
            isEditing = false
            presentationMode.wrappedValue.dismiss()
            refresh()
        }
    }
}
