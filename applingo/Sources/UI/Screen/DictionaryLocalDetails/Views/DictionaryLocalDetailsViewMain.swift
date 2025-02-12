import SwiftUI

/// A view that displays the main details of a dictionary,
/// including the name, description, and topic.
struct DictionaryLocalDetailsViewMain: View {
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
                title: locale.screenSubtitleDictionary,
                style: .titled(ThemeManager.shared.currentThemeStyle)
            )
            .padding(.top, style.paddingBlock)
            
            VStack(spacing: style.spacing) {
                InputText(
                    text: Binding(
                        get: { dictionary.name },
                        set: { dictionary.name = $0 }
                    ),
                    title: locale.screenDescriptionName,
                    placeholder: "",
                    isEditing: isEditing
                )
                
                InputTextArea(
                    text: Binding(
                        get: { dictionary.description },
                        set: { dictionary.description = $0 }
                    ),
                    title: locale.screenDescriptionDescription,
                    placeholder: "",
                    isEditing: isEditing
                )
            }
            .padding(.horizontal, style.paddingBlock)
            .background(Color.clear)
        }
    }
}
