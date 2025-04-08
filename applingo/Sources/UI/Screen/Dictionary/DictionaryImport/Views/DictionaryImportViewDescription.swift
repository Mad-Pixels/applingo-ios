import SwiftUI

internal struct DictionaryImportViewDescription: View {
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
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                cardView(
                    title: "A",
                    description: locale.screenDescriptionBlockA,
                    required: true
                )
                cardView(
                    title: "B",
                    description: locale.screenDescriptionBlockB,
                    required: true
                )
            }
            .frame(maxWidth: .infinity)
            
            HStack(spacing: 16) {
                cardView(
                    title: "C",
                    description: locale.screenDescriptionBlockC,
                    required: false
                )
                cardView(
                    title: "D",
                    description: locale.screenDescriptionBlockD,
                    required: false
                )
            }
            .frame(maxWidth: .infinity)
        }
    }

    /// Creates a card view with a given title.
    /// - Parameters:
    ///   - title: The title to display on the card.
    ///   - description: The description text.
    ///   - required: A Boolean value indicating whether the card is required.
    /// - Returns: A view representing the card.
    private func cardView(title: String, description: String, required: Bool) -> some View {
        SectionBody {
            VStack(alignment: .center, spacing: style.sectionSpacing) {
                DynamicText(
                    model: DynamicTextModel(text: title.uppercased()),
                    style: .headerGame(
                        themeManager.currentThemeStyle,
                        alignment: .center,
                        lineLimit: 1
                    )
                )
                
                DynamicText(
                    model: DynamicTextModel(text: description),
                    style: .textGame(
                        themeManager.currentThemeStyle,
                        alignment: .center,
                        lineLimit: 1
                    )
                )
                .padding(.top, -12)
                
                DynamicText(
                    model: DynamicTextModel(text: required ? locale.screenTagRequired : locale.screenTagOptional),
                    style: .textLight(
                        themeManager.currentThemeStyle,
                        alignment: .center,
                        lineLimit: 1
                    )
                )
                .padding(.top, -18)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .overlay(
            Group {
                if required {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(style.accentColor, lineWidth: 1)
                }
            }
        )
    }
}
