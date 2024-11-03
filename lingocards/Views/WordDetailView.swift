import SwiftUI

struct WordDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var wordsAction: WordsLocalActionViewModel

    @State private var editedWord: WordItemModel
    @State private var errorMessage: String = ""
    @State private var isShowingAlert = false
    @State private var isEditing = false

    @Binding var isPresented: Bool
    let refresh: () -> Void
    private let originalWord: WordItemModel

    init(word: WordItemModel, isPresented: Binding<Bool>, refresh: @escaping () -> Void) {
        guard let dbQueue = DatabaseManager.shared.databaseQueue else {
            fatalError("Database is not connected")
        }
        let wordRepository = RepositoryWord(dbQueue: dbQueue)
        _wordsAction = StateObject(wrappedValue: WordsLocalActionViewModel(repository: wordRepository))
        
        _editedWord = State(initialValue: word)
        _isPresented = isPresented
        self.originalWord = word
        self.refresh = refresh
    }

    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle

        NavigationView {
            ZStack {
                theme.backgroundViewColor.edgesIgnoringSafeArea(.all)

                Form {
                    Section(header: Text(LanguageManager.shared.localizedString(for: "Card"))
                        .modifier(HeaderBlockTextStyle())) {
                            CompTextFieldView(
                                placeholder: LanguageManager.shared.localizedString(
                                    for: "Word"
                                ).capitalizedFirstLetter,
                                text: $editedWord.frontText,
                                isEditing: isEditing,
                                icon: "rectangle.and.pencil.and.ellipsis"
                            )
                            CompTextFieldView(
                                placeholder: LanguageManager.shared.localizedString(
                                    for: "Definition"
                                ).capitalizedFirstLetter,
                                text: $editedWord.backText,
                                isEditing: isEditing,
                                icon: "translate"
                            )
                        }

                    Section(header: Text(LanguageManager.shared.localizedString(for: "Additional"))
                        .modifier(HeaderBlockTextStyle())) {
                            CompTextFieldView(
                                placeholder: LanguageManager.shared.localizedString(
                                    for: "TableName"
                                ).capitalizedFirstLetter,
                                text: $editedWord.tableName,
                                isEditing: false
                            )
                            CompTextFieldView(
                                placeholder: LanguageManager.shared.localizedString(for: "Hint").capitalizedFirstLetter,
                                text: $editedWord.hint.unwrap(default: ""),
                                isEditing: isEditing,
                                icon: "tag"
                            )
                            CompTextEditorView(
                                placeholder: LanguageManager.shared.localizedString(
                                    for: "Description"
                                ).capitalizedFirstLetter,
                                text: $editedWord.description.unwrap(default: ""),
                                isEditing: isEditing,
                                icon: "scroll"
                            )
                            .frame(height: 150)
                    }

                    Section(header: Text(LanguageManager.shared.localizedString(for: "Statistics"))
                        .modifier(HeaderBlockTextStyle())) {
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
                    wordsAction.setFrame(.wordDetail)
                }
                .onReceive(NotificationCenter.default.publisher(for: .errorVisibilityChanged)) { _ in
                    if let error = ErrorManager.shared.currentError,
                       error.frame == .wordDetail {
                        errorMessage = error.localizedMessage
                        isShowingAlert = true
                    }
                }
                .navigationTitle(LanguageManager.shared.localizedString(for: "Details").capitalizedFirstLetter)
                .navigationBarItems(
                    leading: Button(
                        isEditing ? LanguageManager.shared.localizedString(
                            for: "Cancel"
                        ).capitalizedFirstLetter : LanguageManager.shared.localizedString(
                            for: "Close"
                        ).capitalizedFirstLetter
                    ) {
                        if isEditing {
                            isEditing = false
                            editedWord = originalWord
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    },
                    trailing: Button(isEditing ? LanguageManager.shared.localizedString(
                        for: "Save"
                    ).capitalizedFirstLetter : LanguageManager.shared.localizedString(
                        for: "Edit"
                    ).capitalizedFirstLetter
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
                .alert(isPresented: $isShowingAlert) {
                    CompAlertView(
                        title: LanguageManager.shared.localizedString(for: "Error"),
                        message: errorMessage,
                        closeAction: {
                            ErrorManager.shared.clearError()
                        }
                    )
                }
            }
        }
    }

    private func update(_ word: WordItemModel) {
        wordsAction.update(word) { result in
            if case .success = result {
                self.presentationMode.wrappedValue.dismiss()
                self.isEditing = false
                refresh()
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
