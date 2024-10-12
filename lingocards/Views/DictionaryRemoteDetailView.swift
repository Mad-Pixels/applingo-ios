import SwiftUI

struct DictionaryRemoteDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var languageManager: LanguageManager
    @State private var editedDictionary: DictionaryItem

    @Binding var isPresented: Bool
    let onDownload: () -> Void

    init(dictionary: DictionaryItem, isPresented: Binding<Bool>, onDownload: @escaping () -> Void) {
        _editedDictionary = State(initialValue: dictionary)
        _isPresented = isPresented
        self.onDownload = onDownload
    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text(languageManager.localizedString(for: "Dictionary"))) {
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
                    
                    Section(header: Text(languageManager.localizedString(for: "Category"))) {
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
                    
                    Section(header: Text(languageManager.localizedString(for: "Additional"))) {
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

                Spacer()

                // Download Button
                Button(action: {
                    onDownload()
                }) {
                    Text(languageManager.localizedString(for: "Download").capitalizedFirstLetter)
                }
                .buttonStyle(ButtonMain())
                .padding()
            }
            .navigationTitle(languageManager.localizedString(for: "Details").capitalizedFirstLetter)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
