import SwiftUI

/// A view that displays the details of a local dictionary and allows editing.
/// It contains three sections: main details, category details, and additional details.
struct DictionaryLocalDetails: View {
    
    // MARK: - Environment & State Properties
    
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var style: DictionaryLocalDetailsStyle
    @StateObject private var locale = DictionaryLocalDetailsLocale()
    @StateObject private var dictionaryAction = DictionaryAction()
    @StateObject private var wrapper: EditableDictionaryWrapper
    
    /// Binding flag for the presentation state.
    @Binding var isPresented: Bool
    /// Closure to refresh the parent view after changes.
    let refresh: () -> Void
    /// The original dictionary used to restore data when canceling edits.
    private let originalDictionary: DatabaseModelDictionary
    
    @State private var isEditing = false
    @State private var isPressedLeading = false
    @State private var isPressedTrailing = false
    
    // MARK: - Initializer
    
    /// Initializes a new instance of DictionaryLocalDetails.
    /// - Parameters:
    ///   - dictionary: The dictionary to display.
    ///   - isPresented: Binding for the presentation state.
    ///   - refresh: Closure executed to refresh the parent view after an update.
    ///   - style: Optional style configuration; if nil, a themed style is applied.
    init(
        dictionary: DatabaseModelDictionary,
        isPresented: Binding<Bool>,
        refresh: @escaping () -> Void,
        style: DictionaryLocalDetailsStyle? = nil
    ) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
        _wrapper = StateObject(wrappedValue: EditableDictionaryWrapper(dictionary: dictionary))
        _isPresented = isPresented
        self.refresh = refresh
        self.originalDictionary = dictionary
    }
    
    // MARK: - Body
    
    var body: some View {
        BaseScreen(
            screen: .DictionaryLocalDetails,
            title: locale.navigationTitle
        ) {
            ScrollView {
                VStack(spacing: style.spacing) {
                    DictionaryLocalDetailsViewMain(
                        dictionary: wrapper,
                        locale: locale,
                        style: style,
                        isEditing: isEditing
                    )
                    DictionaryLocalDetailsViewCategory(
                        dictionary: wrapper,
                        locale: locale,
                        style: style,
                        isEditing: isEditing
                    )
                    DictionaryLocalDetailsViewAdditional(
                        dictionary: wrapper,
                        locale: locale,
                        style: style,
                        isEditing: isEditing
                    )
                }
                .padding(style.padding)
            }
            .keyboardAdaptive()
            .background(style.backgroundColor)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // MARK: - Toolbar Leading Item
                ToolbarItem(placement: .navigationBarLeading) {
                    ButtonNav(
                        style: isEditing ? .close(ThemeManager.shared.currentThemeStyle) : .back(ThemeManager.shared.currentThemeStyle),
                        onTap: {
                            if isEditing {
                                // Cancel editing and restore the original dictionary.
                                isEditing = false
                                wrapper.dictionary = originalDictionary
                            } else {
                                presentationMode.wrappedValue.dismiss()
                            }
                        },
                        isPressed: $isPressedLeading
                    )
                }
                // MARK: - Toolbar Trailing Item
                ToolbarItem(placement: .navigationBarTrailing) {
                    ButtonNav(
                        style: isEditing ? .save(ThemeManager.shared.currentThemeStyle) : .edit(ThemeManager.shared.currentThemeStyle),
                        onTap: {
                            if isEditing {
                                updateDictionary()
                            } else {
                                isEditing = true
                            }
                        },
                        isPressed: $isPressedTrailing
                    )
                    .disabled(isEditing && isSaveDisabled)
                }
            }
        }
    }
    
    // MARK: - Private Computed Properties
    
    /// Determines whether the save action should be disabled.
    private var isSaveDisabled: Bool {
        let trimmed = { (string: String) -> String in
            string.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return trimmed(wrapper.dictionary.name).isEmpty ||
               trimmed(wrapper.dictionary.category).isEmpty ||
               trimmed(wrapper.dictionary.subcategory).isEmpty ||
               trimmed(wrapper.dictionary.author).isEmpty ||
               trimmed(wrapper.dictionary.description).isEmpty
    }
    
    // MARK: - Private Methods
    
    /// Updates the dictionary using the dictionaryAction service.
    private func updateDictionary() {
        dictionaryAction.update(wrapper.dictionary) { _ in
            isEditing = false
            presentationMode.wrappedValue.dismiss()
            refresh()
        }
    }
}
