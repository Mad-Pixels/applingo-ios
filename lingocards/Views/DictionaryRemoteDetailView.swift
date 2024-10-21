import SwiftUI

struct DictionaryRemoteDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var themeManager: ThemeManager // Используем тему из ThemeManager
    @State private var editedDictionary: DictionaryItem

    @Binding var isPresented: Bool
    let onDownload: () -> Void

    init(dictionary: DictionaryItem, isPresented: Binding<Bool>, onDownload: @escaping () -> Void) {
        _editedDictionary = State(initialValue: dictionary)
        _isPresented = isPresented
        self.onDownload = onDownload
    }

    var body: some View {
        let theme = themeManager.currentThemeStyle // Используем текущую тему

        NavigationView {
            ZStack {
                theme.backgroundColor
                    .edgesIgnoringSafeArea(.all) // Применяем фон темы
                
                VStack {
                    Form {
                        // Секция с данными о словаре
                        Section(header: Text(languageManager.localizedString(for: "Dictionary")).foregroundColor(theme.textColor)) {
                            CompTextField(
                                placeholder: languageManager.localizedString(for: "Display Name").capitalizedFirstLetter,
                                text: .constant(editedDictionary.displayName),
                                isEditing: false,
                                theme: theme
                            )
                            CompTextEditor(
                                placeholder: languageManager.localizedString(for: "Description").capitalizedFirstLetter,
                                text: .constant(editedDictionary.description),
                                isEditing: false,
                                theme: theme
                            )
                            .frame(height: 150)
                        }
                        
                        // Секция с категориями
                        Section(header: Text(languageManager.localizedString(for: "Category")).foregroundColor(theme.textColor)) {
                            CompTextField(
                                placeholder: languageManager.localizedString(for: "Category").capitalizedFirstLetter,
                                text: .constant(editedDictionary.category),
                                isEditing: false,
                                theme: theme
                            )
                            CompTextField(
                                placeholder: languageManager.localizedString(for: "Subcategory").capitalizedFirstLetter,
                                text: .constant(editedDictionary.subcategory),
                                isEditing: false,
                                theme: theme
                            )
                        }
                        
                        // Дополнительная информация
                        Section(header: Text(languageManager.localizedString(for: "Additional")).foregroundColor(theme.textColor)) {
                            CompTextField(
                                placeholder: languageManager.localizedString(for: "Author").capitalizedFirstLetter,
                                text: .constant(editedDictionary.author),
                                isEditing: false,
                                theme: theme
                            )
                            CompTextField(
                                placeholder: languageManager.localizedString(for: "Created At").capitalizedFirstLetter,
                                text: .constant(editedDictionary.formattedCreatedAt),
                                isEditing: false,
                                theme: theme
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
