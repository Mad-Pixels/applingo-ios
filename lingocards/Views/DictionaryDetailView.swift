import SwiftUI

class EditableDictionaryWrapper: ObservableObject {
    @Published var dictionary: DictionaryItemModel
    
    init(dictionary: DictionaryItemModel) {
        self.dictionary = dictionary
    }
}

struct DictionaryDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var dictionaryAction: DictionaryLocalActionViewModel
    @StateObject private var wrapper: EditableDictionaryWrapper

    @State private var errorMessage: String = ""
    @State private var isShowingErrorAlert = false
    @State private var isEditing = false

    @Binding var isPresented: Bool
    let refresh: () -> Void
    private let originalDictionary: DictionaryItemModel

    init(
        dictionary: DictionaryItemModel,
        isPresented: Binding<Bool>,
        refresh: @escaping () -> Void
    ) {
        _dictionaryAction = StateObject(wrappedValue: DictionaryLocalActionViewModel())
        _wrapper = StateObject(wrappedValue: EditableDictionaryWrapper(dictionary: dictionary))
        _isPresented = isPresented
        self.refresh = refresh
        self.originalDictionary = dictionary
    }

    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle

        NavigationView {
            ZStack {
                theme.backgroundViewColor.edgesIgnoringSafeArea(.all)

                Form {
                    Section(header: Text(LanguageManager.shared.localizedString(for: "Dictionary"))
                        .modifier(HeaderBlockTextStyle())) {
                            CompTextFieldView(
                                placeholder: LanguageManager.shared.localizedString(
                                    for: "Display Name"
                                ).capitalizedFirstLetter,
                                text: Binding(
                                    get: { wrapper.dictionary.displayName },
                                    set: { wrapper.dictionary.displayName = $0 }
                                ),
                                isEditing: isEditing,
                                icon: "book"
                            )
                            CompTextEditorView(
                                placeholder: LanguageManager.shared.localizedString(
                                    for: "Description"
                                ).capitalizedFirstLetter,
                                text: Binding(
                                    get: { wrapper.dictionary.description },
                                    set: { wrapper.dictionary.description = $0.isEmpty ? "" : $0 }
                                ),
                                isEditing: isEditing,
                                icon: "scroll"
                            )
                            .frame(height: 150)
                    }

                    Section(header: Text(LanguageManager.shared.localizedString(for: "Category"))
                        .modifier(HeaderBlockTextStyle())) {
                            CompTextFieldView(
                                placeholder: LanguageManager.shared.localizedString(
                                    for: "Category"
                                ).capitalizedFirstLetter,
                                text: Binding(
                                    get: { wrapper.dictionary.category },
                                    set: { wrapper.dictionary.category = $0 }
                                ),
                                isEditing: isEditing,
                                icon: "cube"
                            )
                            CompTextFieldView(
                                placeholder: LanguageManager.shared.localizedString(
                                    for: "Subcategory"
                                ).capitalizedFirstLetter,
                                text: Binding(
                                    get: { wrapper.dictionary.subcategory },
                                    set: { wrapper.dictionary.subcategory = $0 }
                                ),
                                isEditing: isEditing,
                                icon: "square.3.layers.3d"
                            )
                    }

                    Section(header: Text(LanguageManager.shared.localizedString(for: "Additional"))
                        .modifier(HeaderBlockTextStyle())) {
                            CompTextFieldView(
                                placeholder: LanguageManager.shared.localizedString(
                                    for: "Author"
                                ).capitalizedFirstLetter,
                                text: Binding(
                                    get: { wrapper.dictionary.author },
                                    set: { wrapper.dictionary.author = $0 }
                                ),
                                isEditing: isEditing,
                                icon: "person"
                            )
                            CompTextFieldView(
                                placeholder: LanguageManager.shared.localizedString(
                                    for: "Created At"
                                ).capitalizedFirstLetter,
                                text: .constant(wrapper.dictionary.formattedCreatedAt),
                                isEditing: false
                            )
                    }
                }
                .onAppear {
                    FrameManager.shared.setActiveFrame(.dictionaryDetail)
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
                            wrapper.dictionary = originalDictionary
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    },
                    trailing: Button(
                        isEditing ? LanguageManager.shared.localizedString(
                            for: "Save"
                        ).capitalizedFirstLetter : LanguageManager.shared.localizedString(
                            for: "Edit"
                        ).capitalizedFirstLetter
                    ) {
                        if isEditing {
                            updateDictionary()
                        } else {
                            isEditing = true
                        }
                    }
                    .disabled(isEditing && isSaveDisabled)
                )
                .animation(.easeInOut, value: isEditing)
                .alert(isPresented: $isShowingErrorAlert) {
                    Alert(
                        title: Text(LanguageManager.shared.localizedString(for: "Error")),
                        message: Text(LanguageManager.shared.localizedString(for: "DbErrorDescription")),
                        dismissButton: .default(Text(LanguageManager.shared.localizedString(for: "Close")))
                    )
                }
            }
        }
    }

    private func updateDictionary() {
        dictionaryAction.update(wrapper.dictionary) { _ in
            self.isEditing = false
            self.presentationMode.wrappedValue.dismiss()
            refresh()
        }
    }
    
    private var isSaveDisabled: Bool {
        wrapper.dictionary.displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        wrapper.dictionary.category.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        wrapper.dictionary.subcategory.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        wrapper.dictionary.author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        wrapper.dictionary.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
