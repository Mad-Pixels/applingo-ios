import SwiftUI

internal struct DictionaryImportViewNote: View {
    @EnvironmentObject private var themeManager: ThemeManager

    private let locale: DictionaryImportLocale
    private let style: DictionaryImportStyle
    
    /// Initializes the WordDetailsViewStatistic.
    /// - Parameters:
    ///   - style: The style configuration.
    ///   - locale: The localization object.
    init(style: DictionaryImportStyle, locale: DictionaryImportLocale) {
        self.locale = locale
        self.style = style
    }

    var body: some View {
        SectionBody {
            VStack(alignment: .leading, spacing: style.sectionSpacing) {
                DynamicText(
                    model: DynamicTextModel(text: locale.screenTextNote),
                    style: .textMain(
                        themeManager.currentThemeStyle,
                        alignment: .center
                    )
                )
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 4)
        }
        .frame(maxWidth: .infinity)
    }
}
