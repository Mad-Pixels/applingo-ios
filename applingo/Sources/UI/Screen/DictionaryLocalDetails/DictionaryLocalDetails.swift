import SwiftUI

struct DictionaryLocalDetails: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var style: DictionaryLocalDetailsStyle
    @StateObject private var locale = DictionaryLocalDetailsLocale()
    @StateObject private var dictionaryAction = DictionaryLocalActionViewModel()
    @StateObject private var wrapper: EditableDictionaryWrapper
    
    @Binding var isPresented: Bool
    let refresh: () -> Void
    private let originalDictionary: DictionaryItemModel
    
    @State private var isEditing = false
    @State private var isPressedLeading = false
    @State private var isPressedTrailing = false
   
    init(
        dictionary: DictionaryItemModel,
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
    
    var body: some View {
        BaseScreen(
            screen: .dictionariesLocalDetail,
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
            .navigationTitle(locale.navigationTitle)
            .navigationBarItems(
                leading: ButtonNav(
                    style: isEditing ? .close(ThemeManager.shared.currentThemeStyle) : .back(ThemeManager.shared.currentThemeStyle),
                    onTap: {
                        if isEditing {
                            isEditing = false
                            wrapper.dictionary = originalDictionary
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    },
                    isPressed: $isPressedLeading
                ),
                trailing: ButtonNav(
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
            )
        }
    }
   
    private var isSaveDisabled: Bool {
        wrapper.dictionary.displayName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty ||
        wrapper.dictionary.category.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty ||
        wrapper.dictionary.subcategory.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty ||
        wrapper.dictionary.author.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty ||
        wrapper.dictionary.description.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }
   
    private func updateDictionary() {
        dictionaryAction.update(wrapper.dictionary) { _ in
            self.isEditing = false
            self.presentationMode.wrappedValue.dismiss()
            refresh()
        }
    }
}
