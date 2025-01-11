import SwiftUI
import Foundation

struct ScreenWordDetail: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var style: ScreenWordDetailStyle
    @StateObject private var locale = ScreenWordDetailLocale()
    @StateObject private var wordsAction = WordsLocalActionViewModel()
    @StateObject private var wrapper: WordWrapper
    
    @Binding var isPresented: Bool
    let refresh: () -> Void
    private let originalWord: WordItemModel
    
    @State private var isEditing = false
    @State private var isShowingAlert = false
    @State private var errorMessage: String = ""
    
    init(
        word: WordItemModel,
        isPresented: Binding<Bool>,
        refresh: @escaping () -> Void,
        style: ScreenWordDetailStyle? = nil
    ) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
        _wrapper = StateObject(wrappedValue: WordWrapper(word: word))
        _isPresented = isPresented
        self.originalWord = word
        self.refresh = refresh
    }
    
    var body: some View {
        NavigationView {
            Form {
                WordDetailCardSection(
                    word: $wrapper.word,
                    locale: locale,
                    style: style,
                    isEditing: isEditing
                )
                
                WordDetailAdditionalSection(
                    word: $wrapper.word,
                    tableName: wordsAction.dictionaryDisplayName(wrapper.word),
                    locale: locale,
                    style: style,
                    isEditing: isEditing
                )
                
                WordDetailStatisticsSection(
                    word: wrapper.word,
                    locale: locale,
                    style: style
                )
            }
            .navigationTitle(locale.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(isEditing ? locale.cancelTitle : locale.closeTitle) {
                    if isEditing {
                        isEditing = false
                        wrapper.word = originalWord
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                },
                trailing: Button(isEditing ? locale.saveTitle : locale.editTitle) {
                    if isEditing {
                        updateWord()
                    } else {
                        isEditing = true
                    }
                }
                .disabled(isEditing && isSaveDisabled)
            )
        }
        .onAppear {
            AppStorage.shared.activeScreen = .wordsDetail
            wordsAction.setFrame(.wordDetail)
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text(locale.errorTitle),
                message: Text(errorMessage),
                dismissButton: .default(Text(locale.closeTitle)) {
                    ErrorManager1.shared.clearError()
                }
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
