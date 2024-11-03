import SwiftUI

struct DictionaryRemoteDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var editedDictionary: DictionaryItemModel

    @Binding var isPresented: Bool
    let onDownload: () -> Void

    init(dictionary: DictionaryItemModel, isPresented: Binding<Bool>, onDownload: @escaping () -> Void) {
        _editedDictionary = State(initialValue: dictionary)
        _isPresented = isPresented
        self.onDownload = onDownload
    }

    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle

        NavigationView {
            ZStack {
                theme.backgroundViewColor.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Form {
                        Section(header: Text(LanguageManager.shared.localizedString(for: "Dictionary")).foregroundColor(theme.baseTextColor)) {
                            CompTextFieldView(
                                placeholder: LanguageManager.shared.localizedString(
                                    for: "Display Name"
                                ).capitalizedFirstLetter,
                                text: .constant(editedDictionary.displayName),
                                isEditing: false,
                                icon: "book"
                            )
                            CompTextEditorView(
                                placeholder: LanguageManager.shared.localizedString(
                                    for: "Description"
                                ).capitalizedFirstLetter,
                                text: .constant(editedDictionary.description),
                                isEditing: false,
                                icon: "scroll"
                            )
                            .frame(height: 150)
                        }

                        Section(header: Text(LanguageManager.shared.localizedString(for: "Category")).foregroundColor(theme.baseTextColor)) {
                            CompTextFieldView(
                                placeholder: LanguageManager.shared.localizedString(
                                    for: "Category"
                                ).capitalizedFirstLetter,
                                text: .constant(editedDictionary.category),
                                isEditing: false,
                                icon: "cube"
                            )
                            CompTextFieldView(
                                placeholder: LanguageManager.shared.localizedString(
                                    for: "Subcategory"
                                ).capitalizedFirstLetter,
                                text: .constant(editedDictionary.subcategory),
                                isEditing: false,
                                icon: "square.3.layers.3d"
                            )
                        }

                        Section(header: Text(LanguageManager.shared.localizedString(for: "Additional")).foregroundColor(theme.baseTextColor)) {
                            CompTextFieldView(
                                placeholder: LanguageManager.shared.localizedString(
                                    for: "Author"
                                ).capitalizedFirstLetter,
                                text: .constant(editedDictionary.author),
                                isEditing: false,
                                icon: "person"
                            )
                            CompTextFieldView(
                                placeholder: LanguageManager.shared.localizedString(
                                    for: "Created At"
                                ).capitalizedFirstLetter,
                                text: .constant(editedDictionary.formattedCreatedAt),
                                isEditing: false
                            )
                        }
                    }
                    Spacer()

                    CompButtonActionView(
                        title: LanguageManager.shared.localizedString(
                            for: "Download"
                        ).capitalizedFirstLetter,
                        action: onDownload
                    )
                    .padding()
                }
                .background(theme.detailsColor)
            }
            .onAppear {
                FrameManager.shared.setActiveFrame(.dictionaryRemoteDetail)
            }
            .navigationTitle(LanguageManager.shared.localizedString(
                for: "Details"
            ).capitalizedFirstLetter)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text(LanguageManager.shared.localizedString(
                        for: "Close"
                    ).capitalizedFirstLetter)
                        .foregroundColor(theme.accentColor)
                }
            )
        }
    }
}
