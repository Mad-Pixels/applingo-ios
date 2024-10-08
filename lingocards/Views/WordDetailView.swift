import SwiftUI

struct WordDetailView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.presentationMode) private var presentationMode
    @State private var editedWord: WordItem
    @State private var isEditing = false
    
    @Binding var isPresented: Bool
    let onSave: (WordItem) -> Void
    
    private let originalWord: WordItem

    init(word: WordItem, isPresented: Binding<Bool>, onSave: @escaping (WordItem) -> Void) {
        _editedWord = State(initialValue: word)
        _isPresented = isPresented

        self.onSave = onSave
        self.originalWord = word
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(languageManager.localizedString(for: "Card"))) {
                    TextField(
                        languageManager.localizedString(for: "Word").capitalizedFirstLetter,
                        text: $editedWord.frontText
                    )
                        .disabled(!isEditing)
                    TextField(
                        languageManager.localizedString(for: "Definition").capitalizedFirstLetter,
                        text: $editedWord.backText
                    )
                        .disabled(!isEditing)
                }
                
                Section(header: Text(languageManager.localizedString(for: "Additional"))) {
                    TextField(
                        languageManager.localizedString(for: "Description").capitalizedFirstLetter,
                        text: $editedWord.description.unwrap(default: "")
                    )
                        .disabled(!isEditing)
                    TextField(
                        languageManager.localizedString(for: "Hint").capitalizedFirstLetter,
                        text: $editedWord.hint.unwrap(default: "")
                    )
                        .disabled(!isEditing)
                }
                
                
                Section(header: Text(languageManager.localizedString(for: "Statistics"))) {

                }
            }
            .navigationTitle(languageManager.localizedString(for: "Details").capitalizedFirstLetter)
            .navigationBarItems(
                leading: Button(
                    isEditing ? languageManager.localizedString(for: "Cancel") :
                        languageManager.localizedString(for: "Close")
                ) {
                    if isEditing {
                        isEditing = false
                        editedWord = originalWord
                    } else {
                        isPresented = false
                    }
                },
                trailing: Button(isEditing ? languageManager.localizedString(for: "Save") :
                                    languageManager.localizedString(for: "Edit"))
                {
                    if isEditing {
                        onSave(editedWord)
                        isEditing = false
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        isEditing = true
                    }
                }
            )
            .animation(.easeInOut, value: isEditing)  // Плавная анимация при переходе в режим редактирования
        }
    }
}
