import SwiftUI

/// A view that displays a description section composed of cards with column titles.
struct DictionaryImportViewDescription: View {
    
    // MARK: - Properties
    
    let locale: DictionaryImportLocale
    let style: DictionaryImportStyle
   
    // MARK: - Body
    
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
    
    // MARK: - Private Methods
    
    /// Creates a card view with a given title.
    /// - Parameters:
    ///   - title: The title to display on the card.
    ///   - description: The description text.
    ///   - required: A Boolean value indicating whether the card is required.
    /// - Returns: A view representing the card.
    private func cardView(title: String, description: String, required: Bool) -> some View {
        SectionBody {
            VStack(alignment: .center, spacing: style.sectionSpacing) {
                Text(title.uppercased())
                    .font(style.titleFont)
                    .foregroundColor(style.accentColor)
                    .multilineTextAlignment(.center)
                Text(description)
                    .font(style.descriptionFont)
                    .foregroundColor(style.descriptionColor)
                    .multilineTextAlignment(.center)
                    .padding(.top, -12)
                Text(required ? locale.screenTagRequired : locale.screenTagOptional)
                    .font(.system(size: 12))
                    .foregroundColor(required ? style.accentColor : style.textColor)
                    .italic()
                    .multilineTextAlignment(.center)
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
