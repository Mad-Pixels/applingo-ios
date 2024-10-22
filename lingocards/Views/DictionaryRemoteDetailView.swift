import SwiftUI

struct DictionaryRemoteDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var editedDictionary: DictionaryItem

    @Binding var isPresented: Bool
    let onDownload: () -> Void

    init(dictionary: DictionaryItem, isPresented: Binding<Bool>, onDownload: @escaping () -> Void) {
        _editedDictionary = State(initialValue: dictionary)
        _isPresented = isPresented
        self.onDownload = onDownload
    }

    var body: some View {
        let theme = themeManager.currentThemeStyle

        NavigationView {
            ZStack {
                theme.backgroundViewColor.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Form {
                        Section(header: Text(languageManager.localizedString(for: "Dictionary")).foregroundColor(theme.baseTextColor)) {
                            CompTextField(
                                placeholder: languageManager.localizedString(for: "Display Name").capitalizedFirstLetter,
                                text: .constant(editedDictionary.displayName),
                                isEditing: false,
                                theme: theme,
                                icon: "book"
                            )
                            CompTextEditor(
                                placeholder: languageManager.localizedString(for: "Description").capitalizedFirstLetter,
                                text: .constant(editedDictionary.description),
                                isEditing: false,
                                theme: theme,
                                icon: "scroll"
                            )
                            .frame(height: 150)
                        }

                        Section(header: Text(languageManager.localizedString(for: "Category")).foregroundColor(theme.baseTextColor)) {
                            CompTextField(
                                placeholder: languageManager.localizedString(for: "Category").capitalizedFirstLetter,
                                text: .constant(editedDictionary.category),
                                isEditing: false,
                                theme: theme,
                                icon: "cube"
                            )
                            CompTextField(
                                placeholder: languageManager.localizedString(for: "Subcategory").capitalizedFirstLetter,
                                text: .constant(editedDictionary.subcategory),
                                isEditing: false,
                                theme: theme,
                                icon: "square.3.layers.3d"
                            )
                        }

                        Section(header: Text(languageManager.localizedString(for: "Additional")).foregroundColor(theme.baseTextColor)) {
                            CompTextField(
                                placeholder: languageManager.localizedString(for: "Author").capitalizedFirstLetter,
                                text: .constant(editedDictionary.author),
                                isEditing: false,
                                theme: theme,
                                icon: "person"
                            )
                            CompTextField(
                                placeholder: languageManager.localizedString(for: "Created At").capitalizedFirstLetter,
                                text: .constant(editedDictionary.formattedCreatedAt),
                                isEditing: false,
                                theme: theme
                            )
                        }
                    }
                    Spacer()

                    CompButtonAction(
                        title: languageManager.localizedString(for: "Download").capitalizedFirstLetter,
                        action: onDownload,
                        theme: theme
                    )
                    .padding()
                }
                .background(theme.detailsColor)
            }
            .navigationTitle(languageManager.localizedString(for: "Details").capitalizedFirstLetter)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text(languageManager.localizedString(for: "Close").capitalizedFirstLetter)
                        .foregroundColor(theme.accentColor)
                }
            )
        }
    }
}
