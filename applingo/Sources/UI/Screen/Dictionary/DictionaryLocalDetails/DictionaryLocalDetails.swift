import SwiftUI

struct DictionaryLocalDetails: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject private var style: DictionaryLocalDetailsStyle
    @StateObject private var locale = DictionaryLocalDetailsLocale()
    @StateObject private var dictionaryAction = DictionaryAction()
    
    @State private var isEditing = false
    @State private var isPressedLeading = false
    @State private var isPressedTrailing = false
    @State private var editableDictionary: DatabaseModelDictionary
    
    private let originalDictionary: DatabaseModelDictionary
    
    internal let refresh: () -> Void
    
    /// Initializes the DictionaryLocalDetails.
    /// - Parameters:
    ///   - dictionary: The dictionary to display.
    ///   - isPresented: Binding for the presentation state.
    ///   - refresh: Closure executed to refresh the parent view after an update.
    ///   - style: Optional style configuration; if nil, a themed style is applied.
    init(
        dictionary: DatabaseModelDictionary,
        refresh: @escaping () -> Void,
        style: DictionaryLocalDetailsStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        _style = StateObject(wrappedValue: style)
        _editableDictionary = State(initialValue: dictionary)
        self.originalDictionary = dictionary
        self.refresh = refresh
    }
    
    var body: some View {
        BaseScreen(
            screen: .DictionaryLocalDetails,
            title: locale.screenTitle
        ) {
            ScrollView {
                VStack(spacing: style.spacing) {
                    DictionaryLocalDetailsViewMain(
                        style: style,
                        locale: locale,
                        dictionary: $editableDictionary,
                        isEditing: isEditing
                    )
                    
                    DictionaryLocalDetailsViewCategory(
                        style: style,
                        locale: locale,
                        dictionary: $editableDictionary,
                        isEditing: isEditing
                    )
                    
                    DictionaryLocalDetailsViewAdditional(
                        style: style,
                        locale: locale,
                        dictionary: $editableDictionary,
                        isEditing: isEditing
                    )
                }
                .padding(style.padding)
            }
            .keyboardAdaptive()
            .background(style.backgroundColor)
            .padding(.bottom, style.padding.bottom)
            .onAppear {
                dictionaryAction.setScreen(.DictionaryLocalDetails)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    ButtonNav(
                        isPressed: $isPressedLeading,
                        onTap: {
                            if isEditing {
                                isEditing = false
                                editableDictionary = originalDictionary
                            } else {
                                presentationMode.wrappedValue.dismiss()
                            }
                        },
                        style: isEditing ? .close(ThemeManager.shared.currentThemeStyle) : .back(ThemeManager.shared.currentThemeStyle)
                    )
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    ButtonNav(
                        isPressed: $isPressedTrailing,
                        onTap: {
                            if isEditing {
                                updateDictionary()
                            } else {
                                isEditing = true
                            }
                        },
                        style: isEditing ? .save(ThemeManager.shared.currentThemeStyle) : .edit(ThemeManager.shared.currentThemeStyle)
                    )
                    .disabled(isEditing && isSaveDisabled)
                }
            }
        }
    }
    
    /// Determines if the save button should be disabled.
    private var isSaveDisabled: Bool {
        let trimmed = { (string: String) -> String in
            string.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return trimmed(editableDictionary.name).isEmpty ||
               trimmed(editableDictionary.category).isEmpty ||
               trimmed(editableDictionary.subcategory).isEmpty ||
               trimmed(editableDictionary.author).isEmpty ||
               trimmed(editableDictionary.description).isEmpty
    }
    
    /// Updates the dictionary using the dictionaryAction service.
    private func updateDictionary() {
        dictionaryAction.update(editableDictionary) { _ in
            presentationMode.wrappedValue.dismiss()
            isEditing = false
            refresh()
        }
    }
}
