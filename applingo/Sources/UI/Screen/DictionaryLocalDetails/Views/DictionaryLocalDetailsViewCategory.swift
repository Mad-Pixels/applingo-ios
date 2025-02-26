import SwiftUI

/// A view that displays and allows editing of the dictionary's category and subcategory.
struct DictionaryLocalDetailsViewCategory: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: DictionaryLocalDetailsLocale
    private let style: DictionaryLocalDetailsStyle
    
    @Binding var dictionary: DatabaseModelDictionary
    let isEditing: Bool
    
    // MARK: - Initializer
    /// Initializes the additional details view.
    /// - Parameters:
    ///   - style: `DictionaryLocalDetailsStyle` style configuration.
    ///   - locale: `DictionaryLocalDetailsLocale` localization object.
    ///   - dictionary: Binding to the dictionary model.
    ///   - isEditing: A flag indicating if the view is in editing mode.
    init(
        style: DictionaryLocalDetailsStyle,
        locale: DictionaryLocalDetailsLocale,
        dictionary: Binding<DatabaseModelDictionary>,
        isEditing: Bool
    ) {
        self._dictionary = dictionary
        self.isEditing = isEditing
        self.locale = locale
        self.style = style
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.screenSubtitleCategory,
                style: .titled(ThemeManager.shared.currentThemeStyle)
            )
            .padding(.top, style.paddingBlock)
            
            VStack(spacing: style.spacing) {
                InputText(
                    text: Binding(
                        get: { dictionary.category },
                        set: { dictionary.category = $0 }
                    ),
                    title: locale.screenDescriptionName,
                    placeholder: "",
                    isEditing: isEditing
                )
                
                InputText(
                    text: Binding(
                        get: { dictionary.subcategory },
                        set: { dictionary.subcategory = $0 }
                    ),
                    title: locale.screenDescriptionSubcategory,
                    placeholder: "",
                    isEditing: isEditing
                )
            }
            .padding(.horizontal, style.paddingBlock)
            .background(Color.clear)
        }
    }
}
