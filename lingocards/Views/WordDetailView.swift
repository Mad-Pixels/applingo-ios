import SwiftUI

struct WordDetailView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.presentationMode) private var presentationMode  // Управление закрытием модального представления
    @State private var editedWord: WordItem
    @State private var isEditing = false
    
    @Binding var isPresented: Bool
    let onSave: (WordItem) -> Void
    
    private let originalWord: WordItem  // Сохранение оригинального значения для сброса

    init(word: WordItem, isPresented: Binding<Bool>, onSave: @escaping (WordItem) -> Void) {
        _editedWord = State(initialValue: word)
        _isPresented = isPresented
        self.onSave = onSave
        self.originalWord = word  // Сохранение исходного значения
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Основная секция с полями для редактирования
                Section(header: Text("Word")) {
                    TextField("Front Text", text: $editedWord.frontText)
                        .disabled(!isEditing)
                    TextField("Back Text", text: $editedWord.backText)
                        .disabled(!isEditing)
                }
                
                // Секция для дополнительной информации
                Section(header: Text("Additional Information")) {
                    TextField("Description", text: $editedWord.description.unwrap(default: ""))
                        .disabled(!isEditing)
                    TextField("Hint", text: $editedWord.hint.unwrap(default: ""))
                        .disabled(!isEditing)
                }
                
                // Секция со статистикой (убрано поле с датой)
                Section(header: Text("Statistics")) {
                    Text("Success: \(editedWord.success)")
                    Text("Fail: \(editedWord.fail)")
                    Text("Weight: \(editedWord.weight)")
                }
            }
            .navigationTitle("Word Details")
            .navigationBarItems(
                leading: Button(isEditing ? "Cancel" : "Close") {
                    if isEditing {
                        isEditing = false
                        editedWord = originalWord  // Сброс изменений к исходным значениям
                    } else {
                        isPresented = false
                    }
                },
                trailing: Button(isEditing ? "Save" : "Edit") {
                    if isEditing {
                        onSave(editedWord)
                        isEditing = false
                        presentationMode.wrappedValue.dismiss()  // Закрытие модального окна после сохранения
                    } else {
                        isEditing = true
                    }
                }
            )
            .animation(.easeInOut, value: isEditing)  // Плавная анимация при переходе в режим редактирования
        }
    }
}
