import SwiftUI

struct WordDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    
    @State private var editedWord: WordItemModel
    @State private var isShowingErrorAlert = false
    @State private var isEditing = false

    @Binding var isPresented: Bool
    let onSave: (WordItemModel, @escaping (Result<Void, Error>) -> Void) -> Void
    private let originalWord: WordItemModel

    init(
        word: WordItemModel,
        isPresented: Binding<Bool>,
        onSave: @escaping (WordItemModel, @escaping (Result<Void, Error>) -> Void) -> Void
    ) {
        _editedWord = State(initialValue: word)
        _isPresented = isPresented
        self.onSave = onSave
        self.originalWord = word
    } 

    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle

        NavigationView {
            ZStack {
                theme.backgroundViewColor.edgesIgnoringSafeArea(.all)

                Form {
                    Section(header: Text(LanguageManager.shared.localizedString(for: "Card"))
                        .modifier(HeaderBlockTextStyle(theme: theme))) {
                            CompTextFieldView(
                                placeholder: LanguageManager.shared.localizedString(for: "Word").capitalizedFirstLetter,
                                text: $editedWord.frontText,
                                isEditing: isEditing,
                                theme: theme,
                                icon: "rectangle.and.pencil.and.ellipsis"
                            )
                            CompTextFieldView(
                                placeholder: LanguageManager.shared.localizedString(for: "Definition").capitalizedFirstLetter,
                                text: $editedWord.backText,
                                isEditing: isEditing,
                                theme: theme,
                                icon: "translate"
                            )
                        }

                    Section(header: Text(LanguageManager.shared.localizedString(for: "Additional"))
                        .modifier(HeaderBlockTextStyle(theme: theme))) {
                            CompTextFieldView(
                                placeholder: LanguageManager.shared.localizedString(for: "TableName").capitalizedFirstLetter,
                                text: $editedWord.tableName,
                                isEditing: false,
                                theme: theme
                            )
                            CompTextFieldView(
                                placeholder: LanguageManager.shared.localizedString(for: "Hint").capitalizedFirstLetter,
                                text: $editedWord.hint.unwrap(default: ""),
                                isEditing: isEditing,
                                theme: theme,
                                icon: "tag"
                            )
                            CompTextEditorView(
                                placeholder: LanguageManager.shared.localizedString(for: "Description").capitalizedFirstLetter,
                                text: $editedWord.description.unwrap(default: ""),
                                isEditing: isEditing,
                                theme: theme,
                                icon: "scroll"
                            )
                            .frame(height: 150)
                    }

                    Section(header: Text(LanguageManager.shared.localizedString(for: "Statistics"))
                        .modifier(HeaderBlockTextStyle(theme: theme))) {
                            VStack(alignment: .leading, spacing: 16) {
                                CompBarChartView(
                                    title: LanguageManager.shared.localizedString(for: "Answers"),
                                    barData: [
                                        BarData(value: Double(editedWord.fail), label: "fail", color: .red),
                                        BarData(value: Double(editedWord.success), label: "success", color: .green)
                                    ]
                                )
                                .padding(.bottom, 4)

                                CompProgressChartView(
                                    value: calculateWeight(),
                                    title: LanguageManager.shared.localizedString(for: "Count"),
                                    color: .blue
                                )
                                .padding(.bottom, 0)
                            }
                        }
                }
                .onAppear {
                    FrameManager.shared.setActiveFrame(.wordDetail)
                }
                .navigationTitle(LanguageManager.shared.localizedString(for: "Details").capitalizedFirstLetter)
                .navigationBarItems(
                    leading: Button(
                        isEditing ? LanguageManager.shared.localizedString(for: "Cancel").capitalizedFirstLetter :
                            LanguageManager.shared.localizedString(for: "Close").capitalizedFirstLetter
                    ) {
                        if isEditing {
                            isEditing = false
                            editedWord = originalWord
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    },
                    trailing: Button(isEditing ? LanguageManager.shared.localizedString(for: "Save").capitalizedFirstLetter :
                                        LanguageManager.shared.localizedString(for: "Edit").capitalizedFirstLetter
                    ) {
                        if isEditing {
                            update(editedWord)
                        } else {
                            isEditing = true
                        }
                    }
                    .disabled(isEditing && isSaveDisabled)
                )
                .animation(.easeInOut, value: isEditing)
                .alert(isPresented: $isShowingErrorAlert) {
                    CompAlertView(
                        title: LanguageManager.shared.localizedString(for: "Error"),
                        message: ErrorManager.shared.currentError?.errorDescription ?? "",
                        closeAction: {
                            ErrorManager.shared.clearError()
                        },
                        theme: theme
                    )
                }
            }
        }
    }

    private func update(_ word: WordItemModel) {
        let previousWord = editedWord

        onSave(word) { result in
            if case .success = result {
                self.isEditing = false
                self.presentationMode.wrappedValue.dismiss()
            } else {
                self.editedWord = previousWord
            }
        }
    }

    private func calculateWeight() -> Double {
        let total = Double(editedWord.success + editedWord.fail)
        guard total > 0 else { return 0 }
        return Double(editedWord.fail) / total
    }
    
    private var isSaveDisabled: Bool {
        editedWord.frontText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        editedWord.backText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
