//import SwiftUI
//
//private class EditableWordWrapper: ObservableObject {
//    @Published var word: WordItemModel
//    
//    init(word: WordItemModel) {
//        self.word = word
//    }
//}
//
//struct WordDetailView: View {
//    @Environment(\.presentationMode) private var presentationMode
//    @StateObject private var wordsAction: WordsLocalActionViewModel
//    @StateObject private var wrapper: EditableWordWrapper
//
//    @State private var errorMessage: String = ""
//    @State private var isShowingAlert = false
//    @State private var isEditing = false
//
//    @Binding var isPresented: Bool
//    let refresh: () -> Void
//    private let originalWord: WordItemModel
//
//    init(
//        word: WordItemModel,
//        isPresented: Binding<Bool>,
//        refresh: @escaping () -> Void
//    ) {
//        _wordsAction = StateObject(wrappedValue: WordsLocalActionViewModel())
//        _wrapper = StateObject(wrappedValue: EditableWordWrapper(word: word))
//        _isPresented = isPresented
//        self.originalWord = word
//        self.refresh = refresh
//    }
//
//    var body: some View {
//        let theme = ThemeManager.shared.currentThemeStyle
//
//        NavigationView {
//            ZStack {
//                theme.backgroundPrimary.edgesIgnoringSafeArea(.all)
//
//                Form {
//                    Section(header: Text(LanguageManager.shared.localizedString(for: "Card"))
//                        .modifier(HeaderBlockTextStyle())) {
//                            CompTextFieldView(
//                                placeholder: LanguageManager.shared.localizedString(
//                                    for: "Word"
//                                ).capitalizedFirstLetter,
//                                text: Binding(
//                                    get: { wrapper.word.frontText },
//                                    set: { wrapper.word.frontText = $0 }
//                                ),
//                                isEditing: isEditing,
//                                icon: "rectangle.and.pencil.and.ellipsis"
//                            )
//                            CompTextFieldView(
//                                placeholder: LanguageManager.shared.localizedString(
//                                    for: "Definition"
//                                ).capitalizedFirstLetter,
//                                text: Binding(
//                                    get: { wrapper.word.backText },
//                                    set: { wrapper.word.backText = $0 }
//                                ),
//                                isEditing: isEditing,
//                                icon: "translate"
//                            )
//                    }
//
//                    Section(header: Text(LanguageManager.shared.localizedString(for: "Additional"))
//                        .modifier(HeaderBlockTextStyle())) {
//                            CompTextFieldView(
//                                placeholder: LanguageManager.shared.localizedString(
//                                    for: "TableName"
//                                ).capitalizedFirstLetter,
//                                text: .constant(wordsAction.dictionaryDisplayName(wrapper.word)),
//                                isEditing: false
//                            )
//                            CompTextFieldView(
//                                placeholder: LanguageManager.shared.localizedString(for: "Hint").capitalizedFirstLetter,
//                                text: Binding(
//                                    get: { wrapper.word.hint ?? "" },
//                                    set: { wrapper.word.hint = $0.isEmpty ? nil : $0 }
//                                ),
//                                isEditing: isEditing,
//                                icon: "tag"
//                            )
//                            CompTextEditorView(
//                                placeholder: LanguageManager.shared.localizedString(
//                                    for: "Description"
//                                ).capitalizedFirstLetter,
//                                text: Binding(
//                                    get: { wrapper.word.description ?? "" },
//                                    set: { wrapper.word.description = $0.isEmpty ? nil : $0 }
//                                ),
//                                isEditing: isEditing,
//                                icon: "scroll"
//                            )
//                            .frame(height: 150)
//                    }
//
//                    Section(header: Text(LanguageManager.shared.localizedString(for: "Statistics"))
//                        .modifier(HeaderBlockTextStyle())) {
//                            VStack(alignment: .leading, spacing: 16) {
//                                CompBarChartView(
//                                    title: LanguageManager.shared.localizedString(for: "Answers"),
//                                    barData: [
//                                        BarData(value: Double(wrapper.word.fail), label: "fail", color: .red),
//                                        BarData(value: Double(wrapper.word.success), label: "success", color: .green)
//                                    ]
//                                )
//                                .padding(.bottom, 4)
//
//                                CompProgressChartView(
//                                    value: calculateWeight(),
//                                    title: LanguageManager.shared.localizedString(for: "Count"),
//                                    color: .blue
//                                )
//                                .padding(.bottom, 0)
//                            }
//                    }
//                }
//                .onAppear {
//                    AppStorage.shared.activeScreen = .wordsDetail
//                    wordsAction.setFrame(.wordDetail)
//                }
//                .onReceive(NotificationCenter.default.publisher(for: .errorVisibilityChanged)) { _ in
//                    if let error = ErrorManager1.shared.currentError,
//                       error.frame == .wordDetail {
//                        errorMessage = error.localizedMessage
//                        isShowingAlert = true
//                    }
//                }
//                .navigationTitle(LanguageManager.shared.localizedString(for: "Details").capitalizedFirstLetter)
//                .navigationBarItems(
//                    leading: Button(
//                        isEditing ? LanguageManager.shared.localizedString(
//                            for: "Cancel"
//                        ).capitalizedFirstLetter : LanguageManager.shared.localizedString(
//                            for: "Close"
//                        ).capitalizedFirstLetter
//                    ) {
//                        if isEditing {
//                            isEditing = false
//                            wrapper.word = originalWord
//                        } else {
//                            presentationMode.wrappedValue.dismiss()
//                        }
//                    },
//                    trailing: Button(
//                        isEditing ? LanguageManager.shared.localizedString(
//                            for: "Save"
//                        ).capitalizedFirstLetter : LanguageManager.shared.localizedString(
//                            for: "Edit"
//                        ).capitalizedFirstLetter
//                    ) {
//                        if isEditing {
//                            updateWord()
//                        } else {
//                            isEditing = true
//                        }
//                    }
//                    .disabled(isEditing && isSaveDisabled)
//                )
//                .animation(.easeInOut, value: isEditing)
//                .alert(isPresented: $isShowingAlert) {
//                    CompAlertView(
//                        title: LanguageManager.shared.localizedString(for: "Error"),
//                        message: errorMessage,
//                        closeAction: {
//                            ErrorManager1.shared.clearError()
//                        }
//                    )
//                }
//            }
//        }
//    }
//
//    private func updateWord() {
//        wordsAction.update(wrapper.word) { _ in
//            self.isEditing = false
//            self.presentationMode.wrappedValue.dismiss()
//            refresh()
//        }
//    }
//
//    private func calculateWeight() -> Int {
//        let normalizedWeight = Double(wrapper.word.weight) / 100.0
//        return Int(floor(normalizedWeight))
//    }
//    
//    private var isSaveDisabled: Bool {
//        wrapper.word.frontText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
//        wrapper.word.backText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
//    }
//}
