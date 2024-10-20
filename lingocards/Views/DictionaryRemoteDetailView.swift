import SwiftUI

struct DictionaryRemoteDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var languageManager: LanguageManager
    @State private var editedDictionary: DictionaryItem

    @Binding var isPresented: Bool
    let onDownload: () -> Void

    let theme = ThemeProvider.shared.currentTheme() // Используем тему

    init(dictionary: DictionaryItem, isPresented: Binding<Bool>, onDownload: @escaping () -> Void) {
        _editedDictionary = State(initialValue: dictionary)
        _isPresented = isPresented
        self.onDownload = onDownload
    }

    var body: some View {
        NavigationView {
            ZStack {
                theme.backgroundColor
                    .edgesIgnoringSafeArea(.all) // Применяем фон темы
                
                VStack {
                    Form {
                        Section(header: Text(languageManager.localizedString(for: "Dictionary")).foregroundColor(theme.textColor)) {
                            AppTextField(
                                placeholder: languageManager.localizedString(for: "Display Name").capitalizedFirstLetter,
                                text: .constant(editedDictionary.displayName),
                                isEditing: false
                            )
                            
                            AppTextEditor(
                                placeholder: languageManager.localizedString(for: "Description").capitalizedFirstLetter,
                                text: .constant(editedDictionary.description),
                                isEditing: false
                            )
                            .frame(height: 150)
                        }
                        
                        Section(header: Text(languageManager.localizedString(for: "Category")).foregroundColor(theme.textColor)) {
                            AppTextField(
                                placeholder: languageManager.localizedString(for: "Category").capitalizedFirstLetter,
                                text: .constant(editedDictionary.category),
                                isEditing: false
                            )

                            AppTextField(
                                placeholder: languageManager.localizedString(for: "Subcategory").capitalizedFirstLetter,
                                text: .constant(editedDictionary.subcategory),
                                isEditing: false
                            )
                        }
                        
                        Section(header: Text(languageManager.localizedString(for: "Additional")).foregroundColor(theme.textColor)) {
                            AppTextField(
                                placeholder: languageManager.localizedString(for: "Author").capitalizedFirstLetter,
                                text: .constant(editedDictionary.author),
                                isEditing: false
                            )
                            
                            AppTextField(
                                placeholder: languageManager.localizedString(for: "Created At").capitalizedFirstLetter,
                                text: .constant(editedDictionary.formattedCreatedAt),
                                isEditing: false
                            )
                        }
                    }
                    .background(theme.backgroundColor)
                    
                    Spacer()

                    // Кнопка загрузки
                    Button(action: {
                        onDownload()
                    }) {
                        Text(languageManager.localizedString(for: "Download").capitalizedFirstLetter)
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(theme.primaryButtonColor)
                            .foregroundColor(theme.textColor)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
            .navigationTitle(languageManager.localizedString(for: "Details").capitalizedFirstLetter)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
