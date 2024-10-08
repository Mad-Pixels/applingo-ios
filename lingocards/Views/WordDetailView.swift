import SwiftUI

struct WordDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var languageManager: LanguageManager
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
                        languageManager.localizedString(for: "Hint").capitalizedFirstLetter,
                        text: $editedWord.hint.unwrap(default: "")
                    )
                        .disabled(!isEditing)
                    TextField(
                        languageManager.localizedString(for: "Description").capitalizedFirstLetter,
                        text: $editedWord.description.unwrap(default: "")
                    )
                        .disabled(!isEditing)
                }

                Section(header: Text(languageManager.localizedString(for: "Statistics"))) {
                    VStack(alignment: .leading, spacing: 16) {
                        CompBarChartView(
                            title: languageManager.localizedString(for: "Answers"),
                            barData: [
                                BarData(value: Double(editedWord.fail), label: "fail", color: .red),
                                BarData(value: Double(editedWord.success), label: "success", color: .green)
                            ]
                        )
                        .padding(.bottom, 4)

                        CompProgressChartView(
                            value: calculateWeight(),
                            title: languageManager.localizedString(for: "Count"),
                            color: .blue
                        )
                        .padding(.bottom, 0)
                    }
                }
            }
            .navigationTitle(languageManager.localizedString(for: "Details").capitalizedFirstLetter)
            .navigationBarItems(
                leading: Button(
                    isEditing ? languageManager.localizedString(for: "Cancel").capitalizedFirstLetter :
                        languageManager.localizedString(for: "Close").capitalizedFirstLetter
                ) {
                    if isEditing {
                        isEditing = false
                        editedWord = originalWord
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                },
                trailing: Button(isEditing ? languageManager.localizedString(for: "Save").capitalizedFirstLetter :
                                    languageManager.localizedString(for: "Edit").capitalizedFirstLetter
                ) {
                    if isEditing {
                        onSave(editedWord)
                        isEditing = false
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        isEditing = true
                    }
                }
            )
            .animation(.easeInOut, value: isEditing)
        }
    }

    private func calculateWeight() -> Double {
        let total = Double(editedWord.success + editedWord.fail)
        guard total > 0 else { return 0 }
        return Double(editedWord.fail) / total
    }
}
