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
                cardView(title: locale.tableColumnA)
                cardView(title: locale.tableColumnB)
            }
            
            HStack(spacing: 16) {
                cardView(title: locale.tableColumnC)
                cardView(title: locale.tableColumnD)
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Creates a card view with a given title.
    /// - Parameter title: The title to display on the card.
    /// - Returns: A view representing the card.
    private func cardView(title: String) -> some View {
        SectionBody {
            VStack(alignment: .leading, spacing: style.sectionSpacing) {
                SectionHeader(
                    title: title.uppercased(),
                    style: .heading(ThemeManager.shared.currentThemeStyle)
                )
            }
        }
        .frame(maxWidth: .infinity)
    }
}
